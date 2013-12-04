Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3LDNvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:51:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:46183 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755506Ab3LDNvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:51:53 -0500
Date: Wed, 4 Dec 2013 08:51:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/28] tools lib traceevent: Remove malloc_or_die from
 event-plugin.c
Message-ID: <20131204085150.3a70b770@gandalf.local.home>
In-Reply-To: <20131204132932.GE6359@ghostprotocols.net>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
	<1386076182-14484-23-git-send-email-jolsa@redhat.com>
	<20131203111601.540ed5f7@gandalf.local.home>
	<20131204092934.GB1219@krava.brq.redhat.com>
	<20131204132932.GE6359@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013 10:29:32 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:


> Yeah, I also have some reservations about adding more globals (the
> trace_event stuff just to associate a plugins list with pevent, probably
> pevent should have that list, haven't looked 100% at the code), but in
> general probably this patchset is OK, I think we should take it in and
> then address those other problems in a followup patchset, d'accord?

Yep, agreed. If we can associate it to the pevent descriptor then that
would be best.

Yes, take this in now, and we can address the other issues in a
followup. But these issues need to be addressed before we make the
libtraecevent library public.

-- Steve
