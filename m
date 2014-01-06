Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaAFIrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:47:08 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65229 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaAFIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:47:04 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-83-52ca6d85b7f2
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 21/21] perf tools: Enable --children option by default
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
	<1387873347-28838-22-git-send-email-namhyung@kernel.org>
	<20140105180818.GN10018@krava.brq.redhat.com>
Date: Mon, 06 Jan 2014 17:47:01 +0900
In-Reply-To: <20140105180818.GN10018@krava.brq.redhat.com> (Jiri Olsa's
	message of "Sun, 5 Jan 2014 19:08:18 +0100")
Message-ID: <87ppo5cxa2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jan 2014 19:08:18 +0100, Jiri Olsa wrote:
> On Tue, Dec 24, 2013 at 05:22:27PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Now perf top and perf report will show children column by default if
>> it has callchain information.
>> 
>> Requested-by: Ingo Molnar <mingo@kernel.org>
>
> hum, so I could easily put 'children = false' to my .perfconfig
> to get the previous default behaviour back..
>
> but I thought the notion was not to disturb user with
> new features ...and I feel disturbed ;-)
>
> I probably missed some discussion about this

Well, Ingo always wants to enable this by default (like sysprof does)
and to see how many people complains. :)

  https://lkml.org/lkml/2013/10/31/97
  http://www.spinics.net/lists/kernel/msg1656502.html

Thanks,
Namhyung
