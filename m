Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3KHIkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:40:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3KHIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:40:30 -0500
Date: Fri, 8 Nov 2013 09:40:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
Message-ID: <20131108084001.GG19203@twins.programming.kicks-ass.net>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
 <1383313899-15987-7-git-send-email-adrian.hunter@intel.com>
 <20131104152942.GA4004@krava.brq.redhat.com>
 <5278AC36.1020702@intel.com>
 <20131105094220.GA1071@krava.brq.redhat.com>
 <5278EE0A.1080108@intel.com>
 <20131105133024.GE1071@krava.brq.redhat.com>
 <20131105142545.GD22912@ghostprotocols.net>
 <20131105173152.GB7329@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105173152.GB7329@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:31:52PM -0300, Arnaldo Carvalho de Melo wrote:
> PeterZ,
> 
> 	Can I have your Acked-by for this one? I guess now the goal is
> achieved, no?

So this option allows -t/-p/-u to create one buffer per cpu and attach
all the various thread/process/user tasks' their counters to that one
buffer?

As opposed to the current state where each such counter would have its
own buffer.

If this is what the patch does, then yes, although I would prefer a
slightly clearer Changelog.

Acked-by: Peter Zijlstra <peterz@infradead.org>
