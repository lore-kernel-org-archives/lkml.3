Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab3IJJCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:02:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44047 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3IJJCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:02:03 -0400
X-AuditID: 9c930197-b7bc2ae0000060ef-cc-522ee0099b05
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 1/3] perf callchain: Convert children list to rbtree
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
	<1378801458-2515-2-git-send-email-namhyung@kernel.org>
Date: Tue, 10 Sep 2013 18:02:01 +0900
In-Reply-To: <1378801458-2515-2-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 10 Sep 2013 17:24:16 +0900")
Message-ID: <8738pdrqwm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013 17:24:16 +0900, Namhyung Kim wrote:
>  
> -	/* matches not, relay on the parent */
> +	/* matches not, relay no the parent */

Argh.. please ignore this hunk.

Thanks,
Namhyung

