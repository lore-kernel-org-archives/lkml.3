Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab3E2Slf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:41:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62906 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3E2Sl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:41:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130528093815.GH22683@gmail.com>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
	<1369232581-18923-8-git-send-email-lee.jones@linaro.org>
	<CACRpkdYyZZSy4VgFc+Uo=5iAF++EPmHM0U2pHcLdkDZc=Xb_sQ@mail.gmail.com>
	<20130528093815.GH22683@gmail.com>
Date: Wed, 29 May 2013 20:41:26 +0200
Message-ID: <CACRpkdYyZuReZEJCO6h8Ez3=7AmOm=JdT0_Gd+hDaGFnNJ8cGw@mail.gmail.com>
Subject: Re: [PATCH 7/7] Documentation: Update binding for Nomadik and DBx5x
 based platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:38 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> >  Required properties:
>> > -- compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
>> > -              "stericsson,nmk-pinctrl-stn8815"
>> > +- compatible: "stericsson,db8500-pinctrl", "stericsson,db8540-pinctrl",
>> > +              "stericsson,stn8815-pinctrl"
>>
>> OK...
>>
>> >         pinctrl@80157000 {
>> > -               compatible = "stericsson,nmk-pinctrl";
>> > +               compatible = "stericsson,u8500-pinctrl";
>>
>> This does not look like a supported compatible string?
>
> Do you still think this, or did you change you mind?

Que? It is not among the listed compatible strings?

> If so, what makes you think it? How does it differ from:
>
> compatible = "arm,cortex-a9-twd-timer";
> compatible = "arm,rtc-pl031";
> compatible = "stericsson,db8500-gpio",
> compatible = "stericsson,db8500-musb",
> compatible = "stericsson,db8500-dma40",
> compatible = "stericsson,db8500-prcmu";
> compatible = "stericsson,db8500-prcmu-timer-4";
> compatible = "stericsson,db8500-thermal";
> compatible = "stericsson,db8500-prcmu-regulator";

It says u8500-pinctrl, not db8500-pinctrl.

Could it be that you're not actually seeing your own typo?

Yours,
Linus Walleij
