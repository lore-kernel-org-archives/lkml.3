Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaGIS6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:58:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:35346 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbaGIS6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:58:48 -0400
Date: Wed, 9 Jul 2014 15:58:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] perf kvm: add stat support for s390
Message-ID: <20140709185841.GA5721@kernel.org>
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <53BD720F.8010902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD720F.8010902@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 10:47:11AM -0600, David Ahern escreveu:
> fixed Arnaldo's address so this patch set gets on his radar.

Thanks, applied to my perf/core branch, will be in the next pull req to
Ingo.

- Arnaldo
 
> 
> On 7/3/14, 8:29 AM, Alexander Yarygin wrote:
> >Currently, a lot of code in buildin-kvm.c are x86 specific.
> >In accordance with the proposal of David Ahern, we moved the code under
> >#ifdefs from buildin-kvm.c into tools/perf/arch/*/kvm-stat.c. Architecture
> >specific constants were added in arch/*/include/uapi/perf-kvm.h. Also,
> >generic perf kvm stat structures were moved into the new file util/kvm-stat.h.
> >
> >So, patches 1-3 reduce architecture dependency of buildin-kvm.c.
> >Patch 4 implements s390 specific functions. Since some events on s390
> >can have tree-like structure, the patch also adds functions to handle
> >these events in generic code.
> >
> >The patch set based on linux-3.16-rc1 including patches in
> >"perf kvm: refactoring and small changes".
> >
> >Link to the "perf kvm: refactoring and small changes" patch series:
> >https://lkml.org/lkml/2014/7/3/461
> >Link to the previous thread: https://lkml.org/lkml/2014/4/25/331
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
