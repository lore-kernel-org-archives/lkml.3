Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3GTLno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:43:44 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:43561 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3GTLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:43:43 -0400
Date: Sat, 20 Jul 2013 12:43:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 20/22] ARM: ux500: Remove '0x's from Spear 300 DTS file
Message-ID: <20130720114337.GC4681@laptop>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
 <1374242333-6852-20-git-send-email-lee.jones@linaro.org>
 <CAOh2x==EBzy6MMy0Jv1=VSAD7Kdw7=Jag8g4oz-kfRH0XafGaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOh2x==EBzy6MMy0Jv1=VSAD7Kdw7=Jag8g4oz-kfRH0XafGaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013, Viresh Kumar wrote:

> On Fri, Jul 19, 2013 at 7:28 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/spear300.dtsi | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/spear300.dtsi b/arch/arm/boot/dts/spear300.dtsi
> > index f79b3df..8970a4a 100644
> > --- a/arch/arm/boot/dts/spear300.dtsi
> > +++ b/arch/arm/boot/dts/spear300.dtsi
> > @@ -52,7 +52,7 @@
> >                         status = "disabled";
> >                 };
> >
> > -               shirq: interrupt-controller@0x50000000 {
> > +               shirq: interrupt-controller@50000000 {
> >                         compatible = "st,spear300-shirq";
> >                         reg = <0x50000000 0x1000>;
> >                         interrupts = <28>;
> 
> Should Ux500 come in subject line? And please write Spear as
> SPEAr.

Yes, you're right, I will correct them.

I did this for all twenty odd patches, whoops!

> Otherwise all three patches look fine.
> 
> Ackedy-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
