Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaHYVWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:22:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36795 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557AbaHYVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:22:31 -0400
Date: Mon, 25 Aug 2014 14:22:24 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: mpe@ellerman.id.au, acme@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf powerpc: Skip callchain code must include
 util/debug.h
Message-ID: <20140825212223.GA866@us.ibm.com>
References: <20140825182307.49774a04@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825182307.49774a04@kryten>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082521-0928-0000-0000-00000464A334
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard [anton@samba.org] wrote:
| Fix a compile error, the prototype for pr_debug could not be found.
| 
Arnaldo pushed this patch to Ingo recently.

	https://lkml.org/lkml/2014/8/22/393

| Signed-off-by: Anton Blanchard <anton@samba.org>
| ---
| 
| Index: b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
| ===================================================================
| --- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
| +++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
| @@ -15,6 +15,7 @@
| 
|  #include "util/thread.h"
|  #include "util/callchain.h"
| +#include "util/debug.h"
| 
|  /*
|   * When saving the callchain on Power, the kernel conservatively saves

