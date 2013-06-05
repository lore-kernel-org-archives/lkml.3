Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab3FEFM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:12:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:37327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab3FEFMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:12:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,804,1363158000"; 
   d="scan'208";a="348323965"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <51AE8FC7.8090300@intel.com>
References: <1370358196-5699-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130604150956.05843E0090@blue.fi.intel.com>
 <51AE8FC7.8090300@intel.com>
Subject: Re: [PATCH] x86/tlb_info: detect more tlb configuration
Content-Transfer-Encoding: 7bit
Message-Id: <20130605051501.8A226E0090@blue.fi.intel.com>
Date: Wed,  5 Jun 2013 08:15:01 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi wrote:
> On 06/04/2013 11:09 PM, Kirill A. Shutemov wrote:
> > 
> > Kirill A. Shutemov wrote:
> >> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >>
> > 
> > Err.. Forgot CC lists.
> > 
> >> Software Developerâ€™s Manual covers two more TLB configurations:
> >>
> >> 63H Data TLB: 1 GByte pages, 4-way set associative, 4 entries
> >> 76H Instruction TLB: 2M/4M pages, fully associative, 8 entries
> 
> Acked-by: Alex Shi <alex.shi@intel.com>
> 
> BTW,
> What the new CPU has them?

All starting from SandyBridge, I believe.

-- 
 Kirill A. Shutemov
