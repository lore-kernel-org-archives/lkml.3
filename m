Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3F0KsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:48:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0KsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:48:19 -0400
Date: Thu, 27 Jun 2013 12:47:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
Message-ID: <20130627104750.GB27378@dyad.programming.kicks-ass.net>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
 <20130627093609.GO28407@twins.programming.kicks-ass.net>
 <20130627103931.GA5534@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627103931.GA5534@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:39:31PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Jun 27, 2013 at 01:25:20PM +0900, Namhyung Kim wrote:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > The commit bf3da4014a0c ("perf record: Remove -f/--force option") got
> > > rid of -f option from perf record.  But this option was used
> > > internally by various sub-commands so they wouldn't work anymore.
> > > Also update the example document not to use -f option.
> > 
> > Oh man.. we got rid of -f? Do we now default to over-write existing data
> > file?
> 
> I thought -f was the implied default for ages?

OK.. I've been dutifully typing it all this while :-)
