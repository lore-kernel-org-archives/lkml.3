Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3J1H7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:59:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54566 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3J1H7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:59:18 -0400
X-AuditID: 9c93016f-b7cb6ae000000e4c-36-526e19546243
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/4] perf tools: Split -g and --call-graph for record command
References: <20131026120336.GA24439@gmail.com>
	<1382797536-32303-1-git-send-email-jolsa@redhat.com>
	<1382797536-32303-2-git-send-email-jolsa@redhat.com>
Date: Mon, 28 Oct 2013 16:59:16 +0900
In-Reply-To: <1382797536-32303-2-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 26 Oct 2013 16:25:33 +0200")
Message-ID: <87k3gx967f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 26 Oct 2013 16:25:33 +0200, Jiri Olsa wrote:
> Splitting -g and --call-graph for record command, so we could
> use '-g' with no option.
>
> The '-g' option now takes NO argument and enables the configured
> unwind method, which is currently the frame pointers method.
>
> It will be possible to configure unwind method via config
> file in upcoming patches.
>
> All current '-g' arguments is overtaken by --call-graph option.

  $ perf record --call-graph none -- true
  callchain: Unknown -g option value: none

It should be

  callchain: Unknown --call-graph option value: none


Thanks,
Namhyung
