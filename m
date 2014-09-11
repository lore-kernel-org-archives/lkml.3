Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaIKNWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:22:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63798 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040AbaIKNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:21:58 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Thu, 11 Sep 2014 09:27:45 -0400 (EDT)
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
In-Reply-To: <20140910143306.GD4783@worktop.ger.corp.intel.com>
Message-ID: <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu> <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu> <20140910143306.GD4783@worktop.ger.corp.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Peter Zijlstra wrote:

> > I've been trying for months now to make progress on these but this type of 
> > bug is really hard to debug.
> 
> Did we actually fix some at least? I had the idea we did get a few
> sorted. But yes, this is tedious and hard going :/

we did fix some of them.

Others it's a bit unclear.  Fixes went in that made my particular testcase 
stop triggering things, but more fuzzing would crash in similar ways.  So 
it's unclear if the actual problem was fixed or if the fix just shook 
things up enough to make the original bug (probably a race condition of 
some sort) harder to trigger.

Vince
