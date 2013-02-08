Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946939Ab3BHT2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:28:19 -0500
Received: from relayoutw01.hubtelecom.net ([94.199.126.69]:51159 "EHLO
	relayoutw01.hubtelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946826Ab3BHT2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:28:18 -0500
Date: Fri, 8 Feb 2013 20:28:13 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [GIT PULL] ab8500-dependent MFD functions for GPIO IRQs
Message-ID: <20130208192813.GC20996@sortiz-mobl>
References: <CACRpkdbC+UnoxOj8AJFteYy+sjYe8+OUnT1Tyc_qBZH4Wy6sww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbC+UnoxOj8AJFteYy+sjYe8+OUnT1Tyc_qBZH4Wy6sww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Assp-Version: 2.0.1(3.0.23) on relayoutw01.hubtelecom.net
X-Assp-Message/IP-Score: 39 (Bayesian Probability: 0.6587)
X-Assp-Envelope-From: sameo@linux.intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

On Fri, Feb 08, 2013 at 02:37:58PM +0100, Linus Walleij wrote:
> Hi Sam,
> 
> could you please pull these changes into your MFD branch for the
> next merge window?
> 
> These should be merged on top of Lee Jones' patch stack and
> deal with how the GPIO IRQs are handled.
> 
> I based this off v3.8-rc6 as your branch appear to be.
> If there are conflicts you need help with, tell me if you want me
> to rebase it on your for-next branch or any other baseline.
> 
> After this I have only one ACKed patch in the pinctrl tree
> that may conflict any other stuff, and that's this one:
> http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=patch;h=56813f798e8cb3f79a25e0523e782d910f376083
> 
> This is in the middle of a branch that has been used as
> a baseline by others and by other commits in the pinctrl
> tree, so sadly I cannot take it out.
> 
> Please pull it in!
Thanks for that, I pulled it now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
