Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3FSFcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:32:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59765 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab3FSFcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:32:10 -0400
Date: Tue, 18 Jun 2013 22:31:13 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: mingo@kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
Message-ID: <20130619053113.GA5025@us.ibm.com>
References: <20130607204008.GA3281@us.ibm.com>
 <23819.1371616910@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23819.1371616910@ale.ozlabs.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061905-7182-0000-0000-000007662AED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling [mikey@neuling.org] wrote:
| Suka,
| 
| One of these two patches breaks pmac32_defconfig and I suspect all other
| 32 bit configs (against mainline)
| 
| arch/powerpc/perf/core-book3s.c: In function 'record_and_restart':
| arch/powerpc/perf/core-book3s.c:1632:4: error: passing argument 1 of 'ppmu->get_mem_data_src' from incompatible pointer type [-Werror]
| arch/powerpc/perf/core-book3s.c:1632:4: note: expected 'struct perf_sample_data *' but argument is of type 'struct perf_sample_data *'
| 
| benh is busy enough without this junk.  Please check the simple things
| like white space and compile errors!

Sorry about that.

BTW, this was an early patch more to get some feedback on mapping of
memory hierarchy levels to Power and not intended to be merged. I have
been reworking the patch based on other comments.

Sukadev

