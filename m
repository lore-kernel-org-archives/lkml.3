Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab3K1IpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:45:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51022 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3K1IpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:45:05 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-6c-5297028fc365
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/8] perf tool: export setup_list
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
	<1384806771-2945-6-git-send-email-dsahern@gmail.com>
Date: Thu, 28 Nov 2013 17:45:03 +0900
In-Reply-To: <1384806771-2945-6-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 18 Nov 2013 13:32:48 -0700")
Message-ID: <87wqjsq5io.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 13:32:48 -0700, David Ahern wrote:
> Used in next patch (perf sched timehist command)

Why not moving it to util/strlist.c and rename to strlist__setup()?

Thanks,
Namhyung
