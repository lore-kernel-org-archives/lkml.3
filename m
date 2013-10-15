Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3JOHhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:37:12 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51587 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3JOHhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:37:10 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/1] 'perf bench' improvements
Date: Tue, 15 Oct 2013 09:37:00 +0200
Message-Id: <1381822621-27959-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a refresh of the perf bench improvement + cleanup patch I posted a couple
of weeks ago. It can also be found in tip:tmp.perf.

Thanks,

    Ingo

==============>
Ingo Molnar (1):
  tools/perf/bench: Change the procps visible command-name of invididual
    benchmark tests plus cleanups

 tools/perf/builtin-bench.c | 239 +++++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 122 insertions(+), 117 deletions(-)

-- 
1.8.3.1

