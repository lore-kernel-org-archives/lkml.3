Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab3KKUyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:54:41 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60962 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3KKUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:54:33 -0500
Date: Mon, 11 Nov 2013 16:02:47 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: David Ahern <dsahern@gmail.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Bill Gray <bgray@redhat.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>, vincent.weaver@maine.edu
Subject: Re: [PATCH 03/10] perf record: Synthesize non-exec MMAP records when
 --data used
In-Reply-To: <52814060.9000104@gmail.com>
Message-ID: <alpine.DEB.2.10.1311111557060.26131@vincent-weaver-1.um.maine.edu>
References: <1384201353-23863-1-git-send-email-acme@infradead.org> <1384201353-23863-4-git-send-email-acme@infradead.org> <52814060.9000104@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013, David Ahern wrote:

> [Added Vince]
> 
> On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> > When perf_event_attr.mmap_data is set the kernel will generate
> > PERF_RECORD_MMAP events when non-exec (data, SysV mem) mmaps are
> > created, so we need to synthesize from /proc/pid/maps for existing
> > threads
> 
> Seems like that should be documented in the man pages:
> 
> [dsa@MacBook perf]$ egrep -r mmap_data Documentation/
> [dsa@MacBook perf]$
> 
> Vince: where are you keeping the man page you are putting together?

It's in the official linux manpage git tree (perf_event_open.2) and
has been included in the last few manpage releases.  

There is a blurb on PERF_RECORD_MMAP, though it definitely could use a 
bit more elaboration.

Vince
