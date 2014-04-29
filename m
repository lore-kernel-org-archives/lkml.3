Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbaD2Afp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:35:45 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:47123 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562AbaD2Ad4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:33:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: Use LDFLAGS instead of ALL_LDFLAGS
References: <1398675770-3109-1-git-send-email-jolsa@kernel.org>
Date: Tue, 29 Apr 2014 09:33:54 +0900
In-Reply-To: <1398675770-3109-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Mon, 28 Apr 2014 11:02:50 +0200")
Message-ID: <87lhupotxp.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 28 Apr 2014 11:02:50 +0200, Jiri Olsa wrote:
> We no longer use ALL_LDFLAGS, Replacing with LDFLAGS.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
