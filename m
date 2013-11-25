Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3KYT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:28:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3KYT2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:28:20 -0500
Date: Mon, 25 Nov 2013 20:29:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing: Add $cpu and $current probe-vars
Message-ID: <20131125192926.GA9737@redhat.com>
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
> Hello,
>
> After I looked at Namhyung's patches I learned that trace_probes
> has a rich set of ->fetch methods.
>
> But perhaps it makes sense to add a bit more? The patch is simple
> and the idea looks natural. If this patch is accepted, I can try
> to add a bit more hacks to fetch the per-cpu data, but this needs
> a couple of simple preparations.

OK, please see v2.

As Masami and Namhyung suggested it uses '$' prefix instead of '%%'.

Oleg.

