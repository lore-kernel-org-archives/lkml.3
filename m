Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaKYOsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:48:24 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36015 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaKYOsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:48:23 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Romain Perier <romain.perier@gmail.com>, johan@kernel.org,
        lee.jones@linaro.org, broonie@kernel.org, robh@kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, mark.rutland@arm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com
Subject: Re: [PATCH v5 1/2] of: Rename "poweroff-source" property to "system-power-controller"
Date: Tue, 25 Nov 2014 15:52:05 +0100
Message-ID: <1745187.YOripSYQvX@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141125144007.9904BC44343@trevor.secretlab.ca>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com> <1416918506-9366-2-git-send-email-romain.perier@gmail.com> <20141125144007.9904BC44343@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 14:40:07 schrieb Grant Likely:
> On Tue, 25 Nov 2014 12:28:25 +0000
> , Romain Perier <romain.perier@gmail.com>
> 
>  wrote:
> > It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff
> > capability"). As discussed on the mailing list, it makes more sense to
> > rename back to the old established property name, without the vendor
> > prefix. Problem being that the word "source" usually tends to be used for
> > inputs and that is out of control of the OS. The poweroff capability is
> > an output which simply turns the system-power off. Also, this property
> > might be used by drivers which power-off the system and power back on
> > subsequent RTC alarms. This seems to suggest to remove "poweroff" from
> > the property name and to choose "system-power-controller" as the more
> > generic name. This patchs adds the required renaming changes and defines
> > an helper function which checks if this property is set.
> > 
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> 
> For both patches:
> Acked-by: Grant Likely <grant.likely@linaro.org>
> 
> Let me know if I need to take this series through my tree. Also, does it
> need to go into v3.18 and be backported to stable? Or just v3.19.

The original change [that is fixed now] is only scheduled for 3.19 and in
Mark Brown's tree [0]. So there shouldn't be anything to do for you now.


Heiko



[0] https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=topic/power-off
