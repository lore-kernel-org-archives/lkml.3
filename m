Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaE0BIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:08:31 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43960 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaE0BI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:08:28 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 10/14] perf tests: Spawn child for each test
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-11-git-send-email-jolsa@kernel.org>
Date: Tue, 27 May 2014 10:08:25 +0900
In-Reply-To: <1400174615-2121-11-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 15 May 2014 19:23:31 +0200")
Message-ID: <87lhtohvue.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 19:23:31 +0200, Jiri Olsa wrote:
> In upcoming tests we will setup process limits, which
> might affect other tests. Spawning child for each test
> to prevent this.

But you can restore original limits after the test using soft limits?
But I think it's better to run the tests in a child anyway. :)

Thanks,
Namhyung
