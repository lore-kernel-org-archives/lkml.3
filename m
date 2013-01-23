Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3AWS5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:57:12 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:60902 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3AWS5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:57:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130123185010.GB30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
	<1358455012-12287-17-git-send-email-andi@firstfloor.org>
	<CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com>
	<CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
	<CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com>
	<20130123171351.GZ30577@one.firstfloor.org>
	<CABPqkBQvh5R32mxvLsaN2+YmBhxcoRmUYUZeQju4kBDnHB4s5A@mail.gmail.com>
	<20130123180231.GA30577@one.firstfloor.org>
	<CABPqkBRJnt9Pnu90NX20GdGuJAL_YDjkjJyva=UHMNQvJEK1fw@mail.gmail.com>
	<20130123185010.GB30577@one.firstfloor.org>
Date: Wed, 23 Jan 2013 19:57:00 +0100
Message-ID: <CABPqkBThGzeq_yrfbWWZfAU4RZCd=VHAeUYnyR+sF4Qcb4xO3Q@mail.gmail.com>
Subject: Re: [PATCH 16/29] perf, tools: Add support for weight v7
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 7:50 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> For PEBS-LL I do force the sort period to:
>> local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked
>>
>> But that's not enough,
>>
>> One solution could be to make period an explicit sort key. It
>> may then be dropped by some measurements, e.g., when weight is
>> is used.
>
> Makes sense. Agreed, it should probably be an explicit key.
>
And then we would probably not need that resort business.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
