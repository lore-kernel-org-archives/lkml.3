Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaI0O3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 10:29:16 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:40067 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaI0O3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 10:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <tip-f7f084f4d3c29b0f9877a32fc6e2feacd47695b9@git.kernel.org>
References: <1411434104-5307-4-git-send-email-namhyung@kernel.org>
	<tip-f7f084f4d3c29b0f9877a32fc6e2feacd47695b9@git.kernel.org>
Date: Sat, 27 Sep 2014 16:29:13 +0200
Message-ID: <CAFTL4hxeanhFqrcd1sqHHPqi1DmcTKLZwT9QCTksCSEQdaLWRQ@mail.gmail.com>
Subject: Re: [tip:perf/core] perf callchain: Move some parser functions to callchain.c
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mail@milianw.de,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

2014-09-27 9:26 GMT+02:00 tip-bot for Namhyung Kim <tipbot@zytor.com>:
> Commit-ID:  f7f084f4d3c29b0f9877a32fc6e2feacd47695b9
> Gitweb:     http://git.kernel.org/tip/f7f084f4d3c29b0f9877a32fc6e2feacd47695b9
> Author:     Namhyung Kim <namhyung@kernel.org>
> AuthorDate: Tue, 23 Sep 2014 10:01:42 +0900
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Fri, 26 Sep 2014 12:41:57 -0300
>
> perf callchain: Move some parser functions to callchain.c

Please Cc me on callchain stuff. I may not be very verbose but I still
keep an eye on evolutions there.

Thanks.
