Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab3E1Ji3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:38:29 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35883 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807Ab3E1JiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:38:21 -0400
Date: Tue, 28 May 2013 10:38:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 7/7] Documentation: Update binding for Nomadik and DBx5x
 based platforms
Message-ID: <20130528093815.GH22683@gmail.com>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
 <1369232581-18923-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdYyZZSy4VgFc+Uo=5iAF++EPmHM0U2pHcLdkDZc=Xb_sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYyZZSy4VgFc+Uo=5iAF++EPmHM0U2pHcLdkDZc=Xb_sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  Required properties:
> > -- compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
> > -              "stericsson,nmk-pinctrl-stn8815"
> > +- compatible: "stericsson,db8500-pinctrl", "stericsson,db8540-pinctrl",
> > +              "stericsson,stn8815-pinctrl"
> 
> OK...
> 
> >         pinctrl@80157000 {
> > -               compatible = "stericsson,nmk-pinctrl";
> > +               compatible = "stericsson,u8500-pinctrl";
> 
> This does not look like a supported compatible string?

Do you still think this, or did you change you mind?

If so, what makes you think it? How does it differ from:

compatible = "arm,cortex-a9-twd-timer";
compatible = "arm,rtc-pl031";
compatible = "stericsson,db8500-gpio",
compatible = "stericsson,db8500-musb",
compatible = "stericsson,db8500-dma40",
compatible = "stericsson,db8500-prcmu";
compatible = "stericsson,db8500-prcmu-timer-4";
compatible = "stericsson,db8500-thermal";
compatible = "stericsson,db8500-prcmu-regulator";



-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
