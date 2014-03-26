Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaCZPfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:35:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7652 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbaCZPfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:35:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,736,1389744000"; 
   d="scan'208";a="113787677"
Date: Wed, 26 Mar 2014 15:34:30 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: <stefano.stabellini@eu.citrix.com>, <david.vrabel@citrix.com>,
        <ian.campbell@citrix.com>, <jeremy@goop.org>, <fenghua.yu@intel.com>,
        <matt.fleming@intel.com>, <tony.luck@intel.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        <konrad.wilk@oracle.com>, Tang Liang <liang.tang@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 4/5] xen: Define EFI related stuff
In-Reply-To: <5332FF6C02000078000027A5@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1403261534210.2747@kaball.uk.xensource.com>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com> <1395781076-12000-5-git-send-email-daniel.kiper@oracle.com> <alpine.DEB.2.02.1403261452160.2747@kaball.uk.xensource.com> <5332FF6C02000078000027A5@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Jan Beulich wrote:
> >>> On 26.03.14 at 15:58, <stefano.stabellini@eu.citrix.com> wrote:
> >> +struct xenpf_efi_runtime_call {
> >> +	uint32_t function;
> >> +    /*
> >> +     * This field is generally used for per sub-function flags (defined
> >> +     * below), except for the XEN_EFI_get_next_high_monotonic_count case,
> >> +     * where it holds the single returned value.
> >> +     */
> >> +	uint32_t misc;
> >> +	unsigned long status;
> > 
> > I realize that this is just the same as xen/include/public/platform.h,
> > but this field should be xen_ulong_t.
> 
> Care to supply a patch to the canonical header?

I will.
