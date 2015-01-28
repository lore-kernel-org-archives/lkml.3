Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbbA1VOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:14:48 -0500
Received: from mail.kernel.org ([198.145.29.136]:57900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbbA1UwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:13 -0500
Date: Wed, 28 Jan 2015 11:55:36 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Kan Liang <kan.liang@intel.com>,
        linuxppc-dev@lists.ozlabs.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Richard Fowles <rfowles@redhat.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 00/26] perf/core improvements and fixes
Message-ID: <20150128145536.GJ7220@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
 <20150128145015.GB6559@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128145015.GB6559@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 28, 2015 at 03:50:15PM +0100, Ingo Molnar escreveu:
> Pulled, thanks a lot Arnaldo!

Thanks!
 
> Note that there was some minimal interaction with Frederic's 
> pending perf/hw_breakpoint work, in tools/perf/Documentation/perf-record.txt.
> 
> I resolved the conflict and merged perf/hw_breakpoint into 
> perf/core as well, to avoid future complications. (Once I've 
> pushed it all out you guys might want to double check what I did 
> there though, just to make sure.)

As soon as 'git remote update tip' gets this stuff, I'll check it!

- Arnaldo
