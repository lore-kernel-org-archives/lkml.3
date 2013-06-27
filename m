Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3F0Kjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:39:45 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:51948 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3F0Kjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:39:44 -0400
Date: Thu, 27 Jun 2013 12:39:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
Message-ID: <20130627103931.GA5534@gmail.com>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
 <20130627093609.GO28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627093609.GO28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 27, 2013 at 01:25:20PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > The commit bf3da4014a0c ("perf record: Remove -f/--force option") got
> > rid of -f option from perf record.  But this option was used
> > internally by various sub-commands so they wouldn't work anymore.
> > Also update the example document not to use -f option.
> 
> Oh man.. we got rid of -f? Do we now default to over-write existing data
> file?

I thought -f was the implied default for ages?

Thanks,

	Ingo
