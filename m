Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaFSFS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:18:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49436 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaFSFS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:18:28 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] perf tools tui: Display columns headers
References: <1402851203-3083-1-git-send-email-jolsa@kernel.org>
Date: Thu, 19 Jun 2014 14:18:25 +0900
In-Reply-To: <1402851203-3083-1-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Sun, 15 Jun 2014 18:53:19 +0200")
Message-ID: <87bntp8oke.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sun, 15 Jun 2014 18:53:19 +0200, Jiri Olsa wrote:
> hi,
> adding the way to display columns headers in perf TUI on
> 'H' press.

I think it'd be better if it displays the header by default.

Anyway, I see an issue..  the column headers disappeared after resize or
a popup menu.

Thanks,
Namhyung
