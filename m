Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3FETje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:39:34 -0400
Received: from gloria.sntech.de ([95.129.55.99]:49854 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab3FETjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:39:33 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 07/10] pinctrl: add pinctrl driver for Rockchip SoCs
Date: Wed, 5 Jun 2013 20:50:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de> <CACRpkdZty-TszfBTOab4_PUi8dy5DYim=wNERv=pyqC3HNuT4w@mail.gmail.com> <51AF72F9.3060307@wwwdotorg.org>
In-Reply-To: <51AF72F9.3060307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306052050.00410.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Juni 2013, 19:18:49 schrieb Stephen Warren:
> On 06/05/2013 01:01 AM, Linus Walleij wrote:
> > On Tue, Jun 4, 2013 at 2:05 PM, Heiko Stübner <heiko@sntech.de> wrote:
> ...
> 
> >> The only problem is the pull stuff mentioned above that is either pull
> >> up or down without the driver having knowledge about it. And
> >> generic_pinconf only knows about them separately right now.
> > 
> > Create a separate patch adding PIN_CONFIG_BIAS_PULL_AUTO
> > to include/linux/pinctrl/pinconf-generic.h, don't forget the
> > kerneldoc, and patching drivers/pinctrl/pinconf-generic.c.
> 
> "AUTO" sounds really rather generic. Based on just the word "AUTO", I
> have no idea if it's a HW- or SW-supplied default, or what the algorithm
> is for determining the automatically selected value. Perhaps
> s/AUTO/PIN_DEFAULT/ or something like that?

I would also go with PIN_DEFAULT, which somehow captures what the function 
does better than "AUTO". So, if no-one objects I'll go with Stephen's 
suggestion.


> While the concept is simple enough, it's unusual enough that such a
> patch would hopefully have a comment containing a full explanation of
> exactly what this option means.

of course :-)
