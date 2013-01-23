Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3AWQ4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:56:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50201 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab3AWQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:56:44 -0500
Date: Wed, 23 Jan 2013 17:56:38 +0100
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
Message-ID: <20130123165638.GY30577@one.firstfloor.org>
References: <1358455012-12287-1-git-send-email-andi@firstfloor.org> <1358455012-12287-17-git-send-email-andi@firstfloor.org> <CABPqkBQNXUfC9VwyZAA-OyhKJ6JL8Sr__Rq=sZPAzSL6cP+E6Q@mail.gmail.com> <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT+wKBKVt30OJ4mhMGGq1711r51tdWsxyyHAmEy3rYfyw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, figured this out. I needed to use local_weight and not weight for
> the PEBS-LL case.

There are use cases for both. For TSX (global_)weight is more useful,
so i made it the default.

> Works fine now. So I can use your patch unaltered.

I still cannot sort by the weights, that needs to be solved
at some point. But I think it can be done independently
from merging this code. It's already useful even without sorting.

-Andi
