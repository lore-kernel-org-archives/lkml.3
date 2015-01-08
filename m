Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbbAHIAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:00:37 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33746 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbAHIAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:00:35 -0500
Date: Thu, 8 Jan 2015 09:00:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Taesoo kim <taesoo@gatech.edu>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20150108080026.GA18918@gmail.com>
References: <1420253737-2488-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420253737-2488-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 5b5e76218fbdbb71a01d5480f289ead624232876:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2015-01-01 22:24:36 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to e7024fc3783317608b8e07048116a72a7d1cd26d:
> 
>   perf diff: Fix to sort by baseline field by default (2015-01-02 23:27:18 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> - 'perf probe' should fall back to find probe point in symbols when failing
>   to do so in a debuginfo file (Masami Hiramatsu)
> 
> - Fix 'perf probe' crash in dwarf_getcfi_elf (Namhyung Kim)
> 
> - Fix shell completion with 'perf list' --raw-dump option (Taesoo Kim)
> 
> - Fix 'perf diff' to sort by baseline field by default (Namhyung Kim)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Masami Hiramatsu (1):
>       perf probe: Fix to fall back to find probe point in symbols
> 
> Namhyung Kim (2):
>       perf probe: Fix crash in dwarf_getcfi_elf
>       perf diff: Fix to sort by baseline field by default
> 
> Taesoo Kim (1):
>       perf list: Fix --raw-dump option
> 
>  tools/perf/builtin-diff.c      | 44 ++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/builtin-list.c      | 13 ++++++++++---
>  tools/perf/util/probe-event.c  |  6 ++++--
>  tools/perf/util/probe-finder.c | 18 ++++++++++++++++-
>  4 files changed, 75 insertions(+), 6 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
