Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaK0BMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:12:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59466 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaK0BMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:12:07 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: probe + report for following branch history. was Re: [PATCH 1/2] perf hists browser: Print overhead percent value for first-level callchain
References: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
	<20141124145227.GE18625@kernel.org>
Date: Thu, 27 Nov 2014 10:12:04 +0900
In-Reply-To: <20141124145227.GE18625@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Mon, 24 Nov 2014 11:52:27 -0300")
Message-ID: <87h9xlo3a3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 24 Nov 2014 11:52:27 -0300, Arnaldo Carvalho de Melo wrote:
> But the absolute line numbers on 'perf probe -L' and the offsets from function
> start in 'report' look like low hanging fruits and a way to integrate further
> 'perf probe' with 'perf report', because both will look at the right file, keyed
> by the build-id, etc.

Okay, will do later :)

Thanks,
Namhyung
