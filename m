Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3EFCEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 22:04:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64547 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab3EFCD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 22:03:58 -0400
X-AuditID: 9c930179-b7bb6ae000001131-b4-51870f8a522c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/26] perf tools: Move arch check into config/Makefile
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
	<1366796273-4780-4-git-send-email-jolsa@redhat.com>
	<87vc7b7yyf.fsf@sejong.aot.lge.com>
	<20130426113709.GC1054@krava.brq.redhat.com>
	<20130426161809.GE1054@krava.brq.redhat.com>
Date: Mon, 06 May 2013 11:03:54 +0900
In-Reply-To: <20130426161809.GE1054@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 26 Apr 2013 18:18:09 +0200")
Message-ID: <87a9o89851.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 18:18:09 +0200, Jiri Olsa wrote:
> Namhyung,
> if you'd like to check, all changes addressing your comments are in here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> perf/core_make
>
> I'll wait a bit for other comments and resend the patchset later

Sorry, I didn't have a time to check it.

I'll probably have some time later this week so will review it then.

Thanks,
Namhyung
