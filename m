Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaCQKLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:11:21 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:39577 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932323AbaCQKLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:11:19 -0400
X-Yandex-Uniq: 8d8ea1a4-51b0-4ebf-a25e-7d734c5c5d28
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 17 Mar 2014 14:11:13 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf timechart record: fix off-by-one error in argv
Message-ID: <20140317101113.GB13376@stfomichev-desktop.yandex.net>
References: <1394985965-2332-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394985965-2332-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 12:06:05PM -0400, Ramkumar Ramachandra wrote:
> Since 367b315 (perf timechart: Add support for -P and -T in timechart
> recording, 2013-11-01), the 'perf timechart record' command stopped
> working:
> 
>   $ perf timechart record -- git status
>   Workload failed: No such file or directory
> 
> This happens because of an off-by-one error while preparing the argv for
> cmd_record(): it attempts to execute the command 'status' and complains
> that it doesn't exist. Fix this error.
> 
> Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Thanks. I probably never actually tested it with the command :-\

Acked-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
