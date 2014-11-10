Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaKJQDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:03:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaKJQDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:03:50 -0500
Date: Mon, 10 Nov 2014 17:03:45 +0100
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
Message-ID: <20141110160345.GB9565@pd.tnic>
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141106163430.GB4737@pd.tnic>
 <545BA884.5040406@amd.com>
 <20141108090355.GB14837@pd.tnic>
 <5460E13B.4090302@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5460E13B.4090302@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 10:00:59AM -0600, Aravind Gopalakrishnan wrote:
> No, There aren't any bits in MSR_AMD64_IBS_FETCH_EXTD_CTL that we need to
> configure right now.
> So, have included it here mainly to keep the MSR listing consistent with the
> manual.

Please remove it then. We put MSRs in msr-index.h which are in use only.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
