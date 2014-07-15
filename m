Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbaGOTdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:33:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:48796 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264AbaGOTdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:33:35 -0400
Date: Tue, 15 Jul 2014 16:33:31 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/41] perf tools: Fix map groups of threads with unknown
 pids
Message-ID: <20140715193331.GD6312@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-3-git-send-email-adrian.hunter@intel.com>
 <20140714201829.GA9449@kernel.org>
 <53C5116D.1030905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5116D.1030905@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 15, 2014 at 02:33:01PM +0300, Adrian Hunter escreveu:
> On 07/14/2014 11:18 PM, Arnaldo Carvalho de Melo wrote:
> > Because there is nothing in this function (thread__join_map_groups),
> > checking if it is operating on a thread that has an unknown pid.

> > So, please consider merging this and its sole caller,
> > machine__update_thread_pid, so that the test is in the same function as
> > the assumption that it is operating on a thread with an unknown pid.

> You have it in your tree now.  Do you want another patch
> to do that?

Sorry, ended up push it together with the rest, fixed up now, removed it
and added some more from your kit, please work from there.

Let me know if you find any problem with the merge process so far.

Thanks,

- Arnaldo
