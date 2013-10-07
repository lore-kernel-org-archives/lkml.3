Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3JGQmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:42:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41734 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab3JGQmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:42:19 -0400
Date: Mon, 7 Oct 2013 18:42:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v1 0/2] perf,x86: add Intel RAPL PMU support
Message-ID: <20131007164213.GB12771@pd.tnic>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
 <20131007161928.GC5517@pd.tnic>
 <CABPqkBShrCr0ycApxLFFhUCeu5=mFMw=w9HNPKd1FV7DNTN6Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBShrCr0ycApxLFFhUCeu5=mFMw=w9HNPKd1FV7DNTN6Hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 06:24:18PM +0200, Stephane Eranian wrote:
> We could but that means we would need to special case the events in perf.
> I was trying to avoid that.

Maybe we could use some sort of a post-processing hook on those events'
output which is defined only for that type of events...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
