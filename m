Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab3KYRUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:20:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab3KYRUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:20:02 -0500
Date: Mon, 25 Nov 2013 18:21:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] tracing: Teach FETCH_MTD_{symbol,deref} to handle
	per-cpu data
Message-ID: <20131125172106.GA14516@redhat.com>
References: <20131123201543.GA22148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123201543.GA22148@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Oleg Nesterov wrote:
>
> After I looked at Namhyung's patches I learned that trace_probes
> has a rich set of ->fetch methods.
>
> But perhaps it makes sense to add a bit more? The patch is simple
> and the idea looks natural. If this patch is accepted, I can try
> to add a bit more hacks to fetch the per-cpu data, but this needs
> a couple of simple preparations.

Before I redo/resend this patch, let me show the next changes which
allow to dump the per-cpu data.

Not for inclusion! I am not sure if this is really useful, I am not
sure about the syntax or implementation, etc. Just for discussion,
please comment.

Oleg.

