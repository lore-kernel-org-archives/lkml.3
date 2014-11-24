Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaKXNIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:08:39 -0500
Received: from gloria.sntech.de ([95.129.55.99]:53949 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbaKXNIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:08:38 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to "system-power-controller"
Date: Mon, 24 Nov 2014 14:12:19 +0100
Message-ID: <1651776.uhbV5BHLKC@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CABgxDo+t1DUMHwWygibR-w=FL458N6k0G68HM2M7R76gJugyVg@mail.gmail.com>
References: <1415885699-1465-1-git-send-email-user@radxa> <CABgxDoLA=QL6vzU-v1w4vMZ3qhorjRdYOWFFMrjJE6xvZ7QO3g@mail.gmail.com> <CABgxDo+t1DUMHwWygibR-w=FL458N6k0G68HM2M7R76gJugyVg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 24. November 2014, 14:01:02 schrieb Romain Perier:
> 2014-11-24 13:58 GMT+01:00 Romain Perier <romain.perier@gmail.com>:
> > So I need to resend this patch which would only introduce an helper
> > function which checks for "system-power-controller" property (it would
> > also have a new commit message).
> > As you suggested, this helper might be named
> > "of_device_is_system_power_controller" ?
> 
> I mean, the backward compatibility can be handled directly from the
> device driver which would use the new property, no ?

yep, that is what Grant asked for ... to have drivers that need backward-
compatibility (like with the "ti,"-prefix) to do this themselfs.


Heiko
