Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3EEMfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 08:35:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab3EEMfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 08:35:09 -0400
Date: Sun, 5 May 2013 14:36:33 +0200
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
Message-ID: <20130505123633.GA14095@pd.tnic>
References: <50C93A83.8040106@zytor.com>
 <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <50C93718.2090706@zytor.com>
 <20121213181449.GA15966@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121213181449.GA15966@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 07:14:49PM +0100, Alessandro Rubini wrote:
> This is a long-standing problem, but with not practical effects. I
> proposed a pair of different fixes quite some months ago. I'll respin
> the problem tomorrow.

Did this got fixed in some tree in the meantime? Because I still see it on
current Linus + tip/master:

arch/x86/pci/sta2x11-fixup.c:186:2: warning: initialization from incompatible pointer type [enabled by default]
arch/x86/pci/sta2x11-fixup.c:186:2: warning: (near initialization for ‘sta2x11_dma_ops.free’) [enabled by default]

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
