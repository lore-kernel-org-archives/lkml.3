Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3AWSuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:50:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50328 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3AWSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:50:14 -0500
Date: Wed, 23 Jan 2013 19:50:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 16/29] perf, tools: Add support for weight v7
Message-ID: <20130123185010.GB30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org> <1358455012-12287-17-git-send-email-andi@firstfloor.org> <CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com> <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com> <CABPqkBSBWsx50Pupc5nh6yqvkgLBa4BSCQN==6=SPp1Z_iQUYA@mail.gmail.com> <20130123171351.GZ30577@one.firstfloor.org> <CABPqkBQvh5R32mxvLsaN2+YmBhxcoRmUYUZeQju4kBDnHB4s5A@mail.gmail.com> <20130123180231.GA30577@one.firstfloor.org> <CABPqkBRJnt9Pnu90NX20GdGuJAL_YDjkjJyva=UHMNQvJEK1fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRJnt9Pnu90NX20GdGuJAL_YDjkjJyva=UHMNQvJEK1fw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For PEBS-LL I do force the sort period to:
> local_weight,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked
> 
> But that's not enough,
> 
> One solution could be to make period an explicit sort key. It
> may then be dropped by some measurements, e.g., when weight is
> is used.

Makes sense. Agreed, it should probably be an explicit key.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
