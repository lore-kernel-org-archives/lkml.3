Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbaGCOrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:47:13 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:33561 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbaGCOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:47:11 -0400
Message-ID: <53B56CE8.1040306@de.ibm.com>
Date: Thu, 03 Jul 2014 16:47:04 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/4] perf kvm: Refactoring and small improvements
References: <1404395992-17095-1-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404395992-17095-1-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070314-2966-0000-0000-0000006A3940
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 15:59, Alexander Yarygin wrote:
> Hello,
> 
> We divided patch series "perf/s390/kvm: trace events, perf kvm stat"
> into 2 parts.
> 
> This patch set is a preparation for the next one, which adds support for
> perf kvm stat support on s390.
> 
> Patch 1 removes direct dependence of perf kvm stat from x86.
> Patches 2-3 are refactoring.
> Patch 4 adds arch/s390/header.c to be used by perf kvm stat on s390.
> 
> Compared to the previous version, patches contain some minor style/typo fixes.
> 
> Link to the previous thread: https://lkml.org/lkml/2014/4/25/331
> (mirror: http://marc.info/?l=linux-kernel&m=139841718926897)
> 
> Please consider to merge.
> 
> Thanks.
> 
> Alexander Yarygin (4):
>   perf kvm: Introduce HAVE_KVM_STAT_SUPPORT flag
>   perf kvm: Simplify of exit reasons tables definitions
>   perf kvm: Refactoring of cpu_isa_config()
>   perf: Allow to use cpuinfo on s390
> 
>  tools/perf/arch/s390/Makefile      |    1 +
>  tools/perf/arch/s390/util/header.c |   28 ++++++++++++++
>  tools/perf/arch/x86/Makefile       |    1 +
>  tools/perf/builtin-kvm.c           |   72 +++++++++++++++++++-----------------
>  tools/perf/config/Makefile         |    4 ++
>  tools/perf/perf-sys.h              |    1 +
>  6 files changed, 73 insertions(+), 34 deletions(-)
>  create mode 100644 tools/perf/arch/s390/util/header.c
> 
> --
> 1.7.9.5
> 

CCing Paolo to allow him to comment.

FWIW, all patches
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Should be good for next merge window.



