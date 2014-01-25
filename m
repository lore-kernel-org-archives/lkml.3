Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaAYHXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 02:23:44 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60703 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAYHXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 02:23:42 -0500
Date: Sat, 25 Jan 2014 08:23:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20140125072338.GA6754@gmail.com>
References: <1390505894-19733-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390505894-19733-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> Regards,
> 
> - Arnaldo
> 
> The following changes since commit bb236de5d9509c1c6ea5ce0680f000002e731ee2:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-01-23 17:43:35 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 4afc81cd1caa93daa50c1c29a3ab747c978abc13:
> 
>   perf symbols: Load map before using map->map_ip() (2014-01-23 15:48:12 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . Fix traceevent plugin path definitions (Josh Boyer)
> 
> . Load map before using map->map_ip() (Masami Hiramatsu)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Josh Boyer (1):
>       perf tools: Fix traceevent plugin path definitions
> 
> Masami Hiramatsu (1):
>       perf symbols: Load map before using map->map_ip()
> 
>  tools/lib/traceevent/Makefile | 2 +-
>  tools/perf/config/Makefile    | 2 +-
>  tools/perf/util/map.c         | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
