Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3A1Rho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:37:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54617 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab3A1Rhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:37:40 -0500
Date: Mon, 28 Jan 2013 18:37:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers v2
Message-ID: <20130128173736.GT30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-5-git-send-email-andi@firstfloor.org> <CABPqkBQ5cn4SQ8MH3vrPHcyy=pGbsVbxYPjETCCo=oRsx_nEdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ5cn4SQ8MH3vrPHcyy=pGbsVbxYPjETCCo=oRsx_nEdg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This silently drops intx=1 for unhalted_ref_cycles. This event
> only works on fixed counter. So I am wondering what I am measuring
> here. In general, I don't like when settings are silently dropped because
> the user will be misled into thinking the modifier was applied when in
> fact it was not.

Ok. I can look at it later, but I don't think it's a show stopper.

Error handling in general was never a strength of perf.

-Andi
