Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3EEUgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 16:36:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3EEUgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 16:36:35 -0400
Date: Sun, 5 May 2013 22:39:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: hpa@zytor.com, ciminaghi@gnudd.com, jaswinder.singh@linaro.org,
        will.deacon@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        mingo@redhat.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
Message-ID: <20130505203932.GA12742@pd.tnic>
References: <20130505123633.GA14095@pd.tnic>
 <50C93A83.8040106@zytor.com>
 <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <50C93718.2090706@zytor.com>
 <20121213181449.GA15966@mail.gnudd.com>
 <20130505202422.GA13758@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130505202422.GA13758@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 05, 2013 at 10:24:22PM +0200, Alessandro Rubini wrote:
> > Did this got fixed in some tree in the meantime? Because I still see it on
> > current Linus + tip/master:
> > 
> > arch/x86/pci/sta2x11-fixup.c:186:2: warning: initialization from incompatible pointer type [enabled by default]
> > arch/x86/pci/sta2x11-fixup.c:186:2: warning: (near initialization for âsta2x11_dma_ops.freeâ) [enabled by default]
> 
> Last time I sent the patch was on Feb 22nd:
> 
>    The .free field of struct dma_map_ops features a prototype that is
>    different from what lib/swiotlb.c offers. The new "attrs" argument in
>    dma_ops.free is missing from the generic implementation.
> 
>    This removes the build warning by providing a function that just calls
>    swiotlb_free_coherent() without passing "attrs", like others do.
> 
> I got no reply.

It probably fell through the cracks...

> This is the link:
> 
>     http://lkml.org/lkml/2013/2/22/111
> 
> It is in patchwork here:
> 
>     https://patchwork.kernel.org/patch/2175551/

Ingo, hpa, can you guys pick it up?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
