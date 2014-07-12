Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaGLXa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaGLXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:30:27 -0400
Date: Sun, 13 Jul 2014 01:28:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv6] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140712232821.GC29028@krava.redhat.com>
References: <20140106144347.GA13500@ghostprotocols.net>
 <20140106142220.GB1183@krava.brq.redhat.com>
 <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
 <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
 <20140115185026.GA14248@ghostprotocols.net>
 <1390771203-28415-1-git-send-email-ydroneaud@opteya.com>
 <1394527147-7010-1-git-send-email-ydroneaud@opteya.com>
 <1401706594-4995-1-git-send-email-ydroneaud@opteya.com>
 <20140602192320.GD7861@krava.brq.redhat.com>
 <1404160127-7475-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404160127-7475-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 10:28:47PM +0200, Yann Droneaud wrote:
> In commit a21b0b354d4a ('perf: Introduce a flag to enable
> close-on-exec in perf_event_open()'), flag PERF_FLAG_FD_CLOEXEC
> was added to perf_event_open(2) syscall to allows userspace
> to atomically enable close-on-exec behavor when creating
> the file descriptor.
> 
> This patch makes perf tools use the new flag if supported
> by the kernel, so that the event file descriptors got
> automatically closed if perf tool exec a sub-command.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
> 
> Hi,
> 
> I've addressed the issues reported by Jiri Olsa,
> please have a look at the update patch.

hi,
I'll queue this one

thanks,
jirka
