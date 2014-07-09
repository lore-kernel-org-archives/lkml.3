Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaGIQrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:47:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45853 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbaGIQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:47:13 -0400
Message-ID: <53BD720F.8010902@gmail.com>
Date: Wed, 09 Jul 2014 10:47:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] perf kvm: add stat support for s390
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed Arnaldo's address so this patch set gets on his radar.


On 7/3/14, 8:29 AM, Alexander Yarygin wrote:
> Currently, a lot of code in buildin-kvm.c are x86 specific.
> In accordance with the proposal of David Ahern, we moved the code under
> #ifdefs from buildin-kvm.c into tools/perf/arch/*/kvm-stat.c. Architecture
> specific constants were added in arch/*/include/uapi/perf-kvm.h. Also,
> generic perf kvm stat structures were moved into the new file util/kvm-stat.h.
>
> So, patches 1-3 reduce architecture dependency of buildin-kvm.c.
> Patch 4 implements s390 specific functions. Since some events on s390
> can have tree-like structure, the patch also adds functions to handle
> these events in generic code.
>
> The patch set based on linux-3.16-rc1 including patches in
> "perf kvm: refactoring and small changes".
>
> Link to the "perf kvm: refactoring and small changes" patch series:
> https://lkml.org/lkml/2014/7/3/461
> Link to the previous thread: https://lkml.org/lkml/2014/4/25/331



