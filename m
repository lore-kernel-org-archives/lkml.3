Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaEPJxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbaEPJxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:53:03 -0400
Date: Fri, 16 May 2014 11:52:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org
Subject: Re: mplement lbr-as-callgraph v6
Message-ID: <20140516095218.GA19475@krava.brq.redhat.com>
References: <1399936829-28194-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399936829-28194-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:20:20PM -0700, Andi Kleen wrote:
> [Even more review feedback and some bugs addressed.]
> [Only port to changes in perf/core. No other changes.]
> 
> This patchkit implements lbr-as-callgraphs in per freport,
> as an alternative way to present LBR information.
> 
> Current perf report does a histogram over the branch edges,
> which is useful to look at basic blocks, but doesn't tell
> you anything about the larger control flow behaviour.
> 
> This patchkit adds a new option --branch-history that
> adds the branch paths to the callgraph history instead.
> 
> This allows to reason about individual branch paths leading
> to specific samples.
> 
> Also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph4
> 
> v2:
> - rebased on perf/core
> - fix various issues
> - rename the option to --branch-history
> - various fixes to display the information more concise
> v3:
> - White space changes
> - Consolidate some patches
> - Update some descriptions
> v4:
> - Fix various display problems
> - Unknown srcline is now printed as symbol+offset
> - Refactor some code to address review feedback
> - Merge with latest tip
> - Fix missing srcline display in stdio hist output.
> v5:
> - Rename functions
> - Fix gtk build problem
> - Fix crash without -g
> - Improve error messages
> - Improve srcline display in various ways
> v6:
> - Port to latest perf/core

which one? can't apply this on latest tip's perf/core 

you branch perf/lbr-callgraph4 is based on:

commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5
Merge: 0afd2d5 a51e87c
Author: Ingo Molnar <mingo@kernel.org>
Date:   Wed Mar 19 08:05:47 2014 +0100


jirka
