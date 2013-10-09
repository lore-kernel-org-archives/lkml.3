Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3JIMQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab3JIMQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:16:49 -0400
Date: Wed, 9 Oct 2013 14:16:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
Message-ID: <20131009121624.GA5459@krava.redhat.com>
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com>
 <1381221956-16699-4-git-send-email-adrian.hunter@intel.com>
 <20131008140236.GD1348@krava.redhat.com>
 <525506C5.3020101@intel.com>
 <20131009101249.GC1005@krava.redhat.com>
 <5255320C.9020009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5255320C.9020009@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 01:38:04PM +0300, Adrian Hunter wrote:
> On 09/10/13 13:12, Jiri Olsa wrote:
> > On Wed, Oct 09, 2013 at 10:33:25AM +0300, Adrian Hunter wrote:
> >> On 08/10/13 17:02, Jiri Olsa wrote:
> >>> On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:

SNIP

> > 
> > so.. the name of the section, name of the <function> plus the first
> > instruction decode seem wrong.. I can see that in every symbol I
> > annotate in the report and in annotate command as well.
> 
> If you use the --asm-raw option you can see the bytes:
> 
> 	66 66 66 90 
> 
> That looks like a "nop" e.g. K8_NOP4 in arch/x86/include/asm/nops.h
> 

hum, wierd for all those functions to start with nop

ok, how about the '<load0>' function name?

thanks,
jirka
