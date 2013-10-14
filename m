Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750794Ab3JNEuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 00:50:14 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58572 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3JNEuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 00:50:13 -0400
X-AuditID: 9c93017d-b7b79ae000001729-ff-525b7802f720
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v5)
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<20131013123444.GB1044@krava.brq.redhat.com>
Date: Mon, 14 Oct 2013 13:50:09 +0900
In-Reply-To: <20131013123444.GB1044@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 13 Oct 2013 14:34:44 +0200")
Message-ID: <87k3hgbgn2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Oct 2013 14:34:44 +0200, Jiri Olsa wrote:
> I put perf archive and data output in here if you're interested:
> http://people.redhat.com/jolsa/cc/

I can't download the data output (but the archive is fine).

  $ curl http://people.redhat.com/jolsa/cc/perf.data
  <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
  <html><head>
  <title>403 Forbidden</title>
  </head><body>
  <h1>Forbidden</h1>
  <p>You don't have permission to access /jolsa/cc/perf.data
  on this server.</p>
  <hr>
  <address>Apache Server at people.redhat.com Port 80</address>
  </body></html>


Thanks,
Namhyung
