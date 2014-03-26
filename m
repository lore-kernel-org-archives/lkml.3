Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaCZPZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:25:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51387 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaCZPZW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:11:3>);
	Wed, 26 Mar 2014 11:25:22 -0400
Message-Id: <5332FF6C02000078000027A5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 26 Mar 2014 15:25:16 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <stefano.stabellini@eu.citrix.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>, <jeremy@goop.org>,
        <fenghua.yu@intel.com>, <matt.fleming@intel.com>,
        <tony.luck@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>, <konrad.wilk@oracle.com>,
        "Tang Liang" <liang.tang@oracle.com>, <eshelton@pobox.com>,
        <mingo@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 4/5] xen: Define EFI related stuff
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-5-git-send-email-daniel.kiper@oracle.com>
 <alpine.DEB.2.02.1403261452160.2747@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1403261452160.2747@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.03.14 at 15:58, <stefano.stabellini@eu.citrix.com> wrote:
>> +struct xenpf_efi_runtime_call {
>> +	uint32_t function;
>> +    /*
>> +     * This field is generally used for per sub-function flags (defined
>> +     * below), except for the XEN_EFI_get_next_high_monotonic_count case,
>> +     * where it holds the single returned value.
>> +     */
>> +	uint32_t misc;
>> +	unsigned long status;
> 
> I realize that this is just the same as xen/include/public/platform.h,
> but this field should be xen_ulong_t.

Care to supply a patch to the canonical header?

Jan

