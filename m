Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3A3JBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:01:42 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45198 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3A3JBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:01:40 -0500
Date: Wed, 30 Jan 2013 09:01:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [BUG] snowball board locks up on boot
Message-ID: <20130130090134.GR18212@gmail.com>
References: <1359047682.21576.154.camel@gandalf.local.home>
 <CACRpkdZU80XB2GiDtc7nh0hgMpyVYesi+xwhndu50jGS1L=wiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZU80XB2GiDtc7nh0hgMpyVYesi+xwhndu50jGS1L=wiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I tried to get my snowball board working on the latest kernel, but it
> > locks up hard very early on boot up.
> >
> > I bisected it down to this commit:
> >
> > commit ebc96db7632f987e0b9bffcb782cf5cfb8afb0dd
> > Author: Ulf Hansson <ulf.hansson@linaro.org>
> > Date:   Mon Aug 27 15:45:53 2012 +0200
> >
> >     ARM: ux500: Switch to use common clock framework
> 
> Yeah the new common clock framework is a bit like a heart
> transplant on the platforms you convert, some fallout is expected.
> 
> However I thought we had all the clk fixes covered by -rc4 :-(
> 
> I don't have a Snowball right now myself, so have to ask
> for help here (non snowball ux500's work just fine for me).
> 
> Lee, are you still booting the Snowball on new kernels
> everyday, and do you know if some fix is still missing?

Can you provide your bootlog please Steven?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
