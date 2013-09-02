Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3IBIjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab3IBIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:39:42 -0400
Date: Mon, 2 Sep 2013 10:39:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 00/24] perf tools: Add traceevent plugins support
Message-ID: <20130902083922.GB1067@krava.brq.redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 12:48:25PM +0200, Jiri Olsa wrote:
> hi,
> backporting traceevent plugin support from trace-cmd.

It's reachable here:

git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/core_plugins

jirka
