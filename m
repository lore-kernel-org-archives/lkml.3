Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaBYRDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:03:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:59252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBYRDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:03:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL] integrator base patches for v3.15
Date: Tue, 25 Feb 2014 18:03:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>
References: <CACRpkdYeaMqTNUTqBSg6vNa9=VucjpFFkx3diHJJNgZTg+iq1w@mail.gmail.com> <201402241117.48617.arnd@arndb.de> <CACRpkdbtv2ZQbt0=7QhBZSRRAdONgKeKCO9yj=UwWRAU2WOWwA@mail.gmail.com>
In-Reply-To: <CACRpkdbtv2ZQbt0=7QhBZSRRAdONgKeKCO9yj=UwWRAU2WOWwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402251803.08685.arnd@arndb.de>
X-Provags-ID: V02:K0:WrsZgqr/7VfBy+3jVIMCHPjnganLUenAob5OIDzBbL/
 YQpN8cgXcQKRZJW0NNn29gptoEibtV51r7LMHU4fN7yFMMRE+s
 8f74GM076vcAITWyf67J7sAB/BCFHbbILxGFPSI2O2IU+zOACx
 Fj8ERi/2SjF/xwPzWnLbI7aAvjAOqAIYIaVqFQ16IsjnIzhF41
 eTEjU0O4ThfELnpLewuU2OokYyZeOwgIGqzDQFwMN0+QAIptgD
 5/Xnuak1A2D/nk2eWReVsaf7GdB8bchs111PQniAU0GgAtRR+o
 LC1zG36YPPFPHDH5ybXuQ6wvwuckM15NALCMnA1sIQdS7oTLmZ
 VKHEm/iBSV0l5IXs/0TA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 February 2014, Linus Walleij wrote:
> >
> > irqchip: VIC: export vic_init_cascaded
> >
> > vic_init_cascaded is called by integrator impd1 code that can
> > be a loadable module, so the function has to be exported.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Can either of you pls apply this directly to the ARM SoC tree?
> 

Applied on next/drivers now.

	ARnd
