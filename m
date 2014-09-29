Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaI2ESJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:18:09 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38522 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaI2ESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:18:07 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mail@milianw.de,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf callchain: Move some parser functions to callchain.c
References: <1411434104-5307-4-git-send-email-namhyung@kernel.org>
	<tip-f7f084f4d3c29b0f9877a32fc6e2feacd47695b9@git.kernel.org>
	<CAFTL4hxeanhFqrcd1sqHHPqi1DmcTKLZwT9QCTksCSEQdaLWRQ@mail.gmail.com>
Date: Mon, 29 Sep 2014 13:18:05 +0900
In-Reply-To: <CAFTL4hxeanhFqrcd1sqHHPqi1DmcTKLZwT9QCTksCSEQdaLWRQ@mail.gmail.com>
	(Frederic Weisbecker's message of "Sat, 27 Sep 2014 16:29:13 +0200")
Message-ID: <878ul3hxfm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Sat, 27 Sep 2014 16:29:13 +0200, Frederic Weisbecker wrote:
> Hi Namhyung,
>
> 2014-09-27 9:26 GMT+02:00 tip-bot for Namhyung Kim <tipbot@zytor.com>:
>> Commit-ID:  f7f084f4d3c29b0f9877a32fc6e2feacd47695b9
>> Gitweb:     http://git.kernel.org/tip/f7f084f4d3c29b0f9877a32fc6e2feacd47695b9
>> Author:     Namhyung Kim <namhyung@kernel.org>
>> AuthorDate: Tue, 23 Sep 2014 10:01:42 +0900
>> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
>> CommitDate: Fri, 26 Sep 2014 12:41:57 -0300
>>
>> perf callchain: Move some parser functions to callchain.c
>
> Please Cc me on callchain stuff. I may not be very verbose but I still
> keep an eye on evolutions there.

Oops, my bad.  I'll CC you when I send callchain patches later.

Thanks,
Namhyung
