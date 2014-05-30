Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaE3Fr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:47:58 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51098 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaE3Fr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:47:57 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC/PATCH 0/2] perf tools: Factor sort elide
References: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
Date: Fri, 30 May 2014 14:47:54 +0900
In-Reply-To: <1400858147-7155-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Fri, 23 May 2014 17:15:45 +0200")
Message-ID: <878upjg6lx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 17:15:45 +0200, Jiri Olsa wrote:
> hi,
> factoring the elide code to make perf_hpp__should_skip
> function cheap call/check again.

Both look good to me!

Acked-by: Namhyung Kim <namhyung@kernel.org>


>
> Also I was wondering.. do we want to get rid of sort_entry
> structs in favor of perf_hpp__* stuff? Any plans?

Probably.. but there's no plan for me currently. :)

Thanks,
Namhyung
