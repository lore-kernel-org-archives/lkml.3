Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaCCJRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:17:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaCCJQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:16:58 -0500
Date: Mon, 3 Mar 2014 10:16:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140303091637.GO27965@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
 <20140228092341.12a40f7c@gandalf.local.home>
 <alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
 <1c583986-74f8-4829-883b-390dc49ddabb@email.android.com>
 <20140228154026.GH9987@twins.programming.kicks-ass.net>
 <5310B60F.30806@zytor.com>
 <20140228112946.1f194397@gandalf.local.home>
 <20140228205638.GD14089@laptop.programming.kicks-ass.net>
 <20140228160638.3b045dbc@gandalf.local.home>
 <20140301091650.GD5885@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140301091650.GD5885@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 10:16:50AM +0100, Ingo Molnar wrote:
> We read CR2 in the page fault hot path, so it's on the top of CPU 
> architects' minds and it's reasonably optimized. A couple of cycles 
> IIRC, but would be nice to hear actual numbers.

Well, going with what Linus found; it looks like they made page faults
more expensive on Haswell as compared to previous generations. So its
not _that_ high on their list :/
