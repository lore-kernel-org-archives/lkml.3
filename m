Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3EFKHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:07:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab3EFKHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:07:39 -0400
Date: Mon, 6 May 2013 12:11:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, hpa@zytor.com, ciminaghi@gnudd.com,
        jaswinder.singh@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        djbw@fb.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, wim@iguana.be, cjb@laptop.org,
        davidb@codeaurora.org, nico@fluxnic.net, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
Message-ID: <20130506101112.GA22084@pd.tnic>
References: <20130505123633.GA14095@pd.tnic>
 <50C93A83.8040106@zytor.com>
 <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <50C93718.2090706@zytor.com>
 <20121213181449.GA15966@mail.gnudd.com>
 <20130505202422.GA13758@mail.gnudd.com>
 <20130505203932.GA12742@pd.tnic>
 <20130506094154.GA9464@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130506094154.GA9464@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 11:41:54AM +0200, Ingo Molnar wrote:
> A lot happened meanwhile - patches got acked, applied - so I expected
> a resend of the patches that are still pending, with all acks in place
> in the patches (not in the cover letter), and against Linus's latest
> tree.

That one above was a single submission anyway and it could go in now
since it fixes a build issue. I don't know about the rest of the set
though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
