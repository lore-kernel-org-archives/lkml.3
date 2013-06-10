Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3FJVtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:49:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42739 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3FJVte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:49:34 -0400
Date: Mon, 10 Jun 2013 14:48:48 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: mingo@kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
Message-ID: <20130610214848.GA2666@us.ibm.com>
References: <20130607204008.GA3281@us.ibm.com>
 <51B58843.5020809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B58843.5020809@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061021-7282-0000-0000-0000182310F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| > The former approach seems less confusing and this patch uses that approach.
| > 
| 
| Yeah, the former approach is simpler and makes sense.

Ok. Seems to make sense at least on Power.

<snip>

| > + * We use the table, dcache_src_map, to map this value 1 to PERF_MEM_LVL_L3,
| > + * the arch-neutral representation of the L3 cache.
| > + *
| > + * Similarly, in case of marked data TLB miss, bits 14..17 of the MMCRA
| > + * indicate the load source of a marked DTLB  entry. dtlb_src_map[] gives
| > + * the mapping to the arch-neutral values of the TLB source.
| 
| 
| Where did you define dtlb_src_map[] ?

Ah, the comment belongs in another patch that I am working on. That patch
maps the PERF_MEM_TLB* flags to Power7.

Thanks for the comments.

Sukadev

