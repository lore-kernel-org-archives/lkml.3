Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3JGWdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3JGWdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:33:31 -0400
Date: Tue, 8 Oct 2013 00:33:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 49/50] tools/perf/build: Fix O=/some/dir perf.o type of
 targets
Message-ID: <20131007223323.GH2900@krava.redhat.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <1381147003-2574-50-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381147003-2574-50-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 01:56:42PM +0200, Ingo Molnar wrote:

SNIP

> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index eaa477f..86a4ba8 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -1,3 +1,5 @@
> +$(info Documentation/Makefile)
> +
>  include ../../scripts/Makefile.include
>  include ../config/utilities.mak

debug leftover?

jirka
