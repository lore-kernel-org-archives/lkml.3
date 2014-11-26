Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaKZRxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:53:12 -0500
Received: from gloria.sntech.de ([95.129.55.99]:46671 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaKZRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:53:10 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Pinctrl fixes for rockchip
Date: Wed, 26 Nov 2014 18:56:54 +0100
Message-ID: <1796168.f97MNRYGcl@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416437493-25588-1-git-send-email-dianders@chromium.org>
References: <1416437493-25588-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Am Mittwoch, 19. November 2014, 14:51:31 schrieb Doug Anderson:
> These two patches fix some pinctrl issues on rockchip.  The first
> fixes a real issue where interrupts were being left on in
> suspend/resume and waking the system up when they shouldn't.  The
> second fixes purely theoretical problems but seems clean.
> 
> I've tested these patches more extensively on a non-mainline tree but
> have done basic compile and boot testing on mainline.  I don't have
> suspend/resume working so well on mainline yet, so I haven't tested
> fully there.

As indicated by my review-tag in the patches, these look good to me.
Do you want to take them normally [they should simply go on top of the other 
patches] or do you prefer another pull request - which feels strange for only 
two patches :-) .


Thanks
Heiko

