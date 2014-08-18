Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaHRXaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:30:04 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58594 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaHRXaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:30:01 -0400
Date: Mon, 18 Aug 2014 16:29:56 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: jolsa@redhat.com, andi@firstfloor.org,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140818232956.GB6955@us.ibm.com>
References: <20140806001754.GA28735@us.ibm.com>
 <20140807084436.GB29832@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807084436.GB29832@distanz.ch>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081823-9332-0000-0000-000001BA414C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Klauser [tklauser@distanz.ch] wrote:
| > diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
| > index 6c1b8a7..1bb400e8 100644
| > --- a/tools/perf/arch/powerpc/util/header.c
| > +++ b/tools/perf/arch/powerpc/util/header.c
| > @@ -6,6 +6,7 @@
| >  
| >  #include "../../util/header.h"
| >  #include "../../util/util.h"
| > +#include "../../util/jevents.h"
| >  
| >  #define mfspr(rn)       ({unsigned long rval; \
| >  			 asm volatile("mfspr %0," __stringify(rn) \
| > @@ -32,3 +33,14 @@ get_cpuid(char *buffer, size_t sz)
| >  	}
| >  	return -1;
| >  }
| > +
| > +char *
| > +get_cpu_str(void)
| > +{
| > Changelog[v2]:
| > 	[Michael Ellerman]: Use PVR instead of AUXV variables
| 
| This was probably not intended to be here and the patch does not apply
| due to these lines.

Sorry about that. Will resend.

Sukadev

