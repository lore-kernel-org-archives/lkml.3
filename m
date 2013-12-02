Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3LBHlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:41:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59964 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBHlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:41:45 -0500
X-AuditID: 9c930197-b7caaae000001cef-2e-529c39b6fe69
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf sched: Add documentation for timehist options
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
	<1385943795-11761-3-git-send-email-dsahern@gmail.com>
Date: Mon, 02 Dec 2013 16:41:42 +0900
In-Reply-To: <1385943795-11761-3-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sun, 1 Dec 2013 17:23:15 -0700")
Message-ID: <8761r7pumh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun,  1 Dec 2013 17:23:15 -0700, David Ahern wrote:
> Add entry to perf-sched documentation for timehist command and its
> options.

[SNIP]
> +--max-stack::
> +    Set the stack depth limit when showing the callchains. Default: 127

Isn't it 5 instead of 127?

Thanks,
Namhyung
