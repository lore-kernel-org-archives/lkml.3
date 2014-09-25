Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaIYO3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:29:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:47893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:29:37 -0400
Date: Thu, 25 Sep 2014 16:29:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH v7 0/6] perf: add ability to sample interrupted machine
 state
Message-ID: <20140925142929.GD4140@worktop.programming.kicks-ass.net>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
 <20140925092629.GC4140@worktop.programming.kicks-ass.net>
 <CABPqkBTwjkRbc8BBYWOkGAOsSsiVwsrSENqybSb260vsW9hcJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTwjkRbc8BBYWOkGAOsSsiVwsrSENqybSb260vsW9hcJg@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:32:39PM +0200, Stephane Eranian wrote:
> Peter,
> 
> On Thu, Sep 25, 2014 at 11:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >
> > These do indeed appear to compile just fine, thanks!
> >
> I posted v7 with the x86_32 fixes and the eflags changes.
> Is that what you compiled?

Yep, I grabbed the latest. I've not yet tried the x86_32 compile, but I
did check the 'offending' patch and it has the #ifdef guard in place so
I'll assume it works for now.
