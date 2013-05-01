Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab3EAJM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:12:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34714
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab3EAJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:12:51 -0400
Date: Wed, 1 May 2013 11:11:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: fix typo in perf_event_intel_uncore.c
Message-ID: <20130501091120.GC28253@dyad.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:49:28PM -0400, Vince Weaver wrote:
> 
> Sandy Bridge was misspelled.  Either that or the Intel marketing names
> are getting even more obscure.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index b43200d..0d5ec6d 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -2857,7 +2857,7 @@ static int __init uncore_cpu_init(void)
>  			snb_uncore_cbox.num_boxes = max_cores;
>  		msr_uncores = snb_msr_uncores;
>  		break;
> -	case 45: /* Sandy Birdge-EP */
> +	case 45: /* Sandy Bridge-EP */

hehe indeed, we should be careful though we might give them ideas! :-)
