Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaKJVnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:43:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaKJVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:43:52 -0500
Date: Mon, 10 Nov 2014 22:43:46 +0100
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH V2] perf, amd, ibs: Update IBS MSRs and feature
 definitions
Message-ID: <20141110214346.GD9565@pd.tnic>
References: <1415651066-13523-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415651066-13523-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:24:26PM -0600, Aravind Gopalakrishnan wrote:
> New Fam15h models carry extra feature bits and extend
> the MSR register space for IBS ops. Adding them here.
> 
> While at it, add functionality to read IbsBrTarget and
> OpData4 depending on their availability if user wants a
> PERF_SAMPLE_RAW.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
> Changes in V2 (per Boris suggestion)
>  - Remove unused MSR listing

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
