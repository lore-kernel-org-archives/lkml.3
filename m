Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKHJEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 04:04:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaKHJED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 04:04:03 -0500
Date: Sat, 8 Nov 2014 10:03:55 +0100
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
Message-ID: <20141108090355.GB14837@pd.tnic>
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141106163430.GB4737@pd.tnic>
 <545BA884.5040406@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <545BA884.5040406@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:57:40AM -0600, Aravind Gopalakrishnan wrote:
> On 11/6/2014 10:34 AM, Borislav Petkov wrote:
> >On Thu, Nov 06, 2014 at 10:26:22AM -0600, Aravind Gopalakrishnan wrote:
> >>diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> >>index e21331c..ba7b609 100644
> >>--- a/arch/x86/include/uapi/asm/msr-index.h
> >>+++ b/arch/x86/include/uapi/asm/msr-index.h
> >>@@ -206,6 +206,8 @@
> >>  #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
> >>  #define MSR_AMD64_IBSCTL		0xc001103a
> >>  #define MSR_AMD64_IBSBRTARGET		0xc001103b
> >>+#define MSR_AMD64_IBS_FETCH_EXTD_CTL	0xc001103c
> >>+#define MSR_AMD64_IBSOPDATA4		0xc001103d
> >>  #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
> >>  /* Fam 16h MSRs */

> But Why?
> IBS_CAPS_BRNTRGT and IBS_CAPS_OPDATA4 indicate support for the respective
> MSRs

Ok, I was just making sure.

Btw, MSR_AMD64_IBS_FETCH_EXTD_CTL seems unused. Forgotten?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
