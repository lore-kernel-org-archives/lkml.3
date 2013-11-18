Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880Ab3KRFSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 00:18:45 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50393 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3KRFSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 00:18:38 -0500
X-AuditID: 9c93017e-b7b2fae000000ea2-a8-5289a32d9040
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCH 3/3] perf script: Print mmap[2] events also
References: <1384743642-15120-1-git-send-email-namhyung@kernel.org>
	<1384743642-15120-3-git-send-email-namhyung@kernel.org>
	<52899BFF.5080007@gmail.com>
Date: Mon, 18 Nov 2013 14:18:37 +0900
In-Reply-To: <52899BFF.5080007@gmail.com> (David Ahern's message of "Sun, 17
	Nov 2013 21:47:59 -0700")
Message-ID: <87fvquuw2a.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 17 Nov 2013 21:47:59 -0700, David Ahern wrote:
> On 11/17/13, 8:00 PM, Namhyung Kim wrote:
>> If --show-mmap option is given, also print internal MMAP and MMAP2
>> events.  It would be helpful for debugging.
>>
>> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Outside of the free following a strdup, the 3 patches looked good to
> me. Procrastination worked in my favor. Once these go in I'll do the
> move to perf-dump.
>
> For all 3:
> Reviewed-by: David Ahern <dsahern@gmail.com>

Thank you for quick review!

I'll fix the bug you mentioned and resend.

Thanks,
Namhyung
