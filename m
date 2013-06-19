Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3FSQP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:15:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40107 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab3FSQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:15:53 -0400
Date: Wed, 19 Jun 2013 09:14:46 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com
Subject: Re: [PATCH 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130619161446.GB13326@us.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061916-7182-0000-0000-00000769A836
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runzhen Wang [runzhen@linux.vnet.ibm.com] wrote:
| Power7 supports over 530 different perf events but only a small
| subset of these can be specified by name, for the remaining
| events, we must specify them by their raw code:
| 
|         perf stat -e r2003c <application>
| 
| This patch makes all the POWER7 events available in sysfs.
| So we can instead specify these as:
| 
|         perf stat -e 'cpu/PM_CMPLU_STALL_DFU/' <application>
| 
| where PM_CMPLU_STALL_DFU is the r2003c in previous example.
| 
| Before this patch is applied, the size of power7-pmu.o is:
| 
| $ size arch/powerpc/perf/power7-pmu.o
|    text	   data	    bss	    dec	    hex	filename
|    3073	   2720	      0	   5793	   16a1	arch/powerpc/perf/power7-pmu.o
| 
| and after the patch is applied, it is:
| 
| $ size arch/powerpc/perf/power7-pmu.o
|    text	   data	    bss	    dec	    hex	filename
|   14451	  31112	      0	  45563	   b1fb	arch/powerpc/perf/power7-pmu.o
| 
| Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>

Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

