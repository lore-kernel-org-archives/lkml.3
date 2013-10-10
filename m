Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3JJGUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:20:31 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55587 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3JJGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:20:30 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-c4-5256472da4cb
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 44/52] tools/perf/build: Clean up various testcases
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-45-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:20:29 +0900
In-Reply-To: <1381227082-22039-45-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:11:14 +0200")
Message-ID: <87ob6xir4i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:11:14 +0200, Ingo Molnar wrote:
> --- a/tools/perf/config/feature-checks/test-gtk2.c
> +++ b/tools/perf/config/feature-checks/test-gtk2.c
> @@ -4,7 +4,7 @@
>  
>  int main(int argc, char *argv[])
>  {
> -        gtk_init(&argc, &argv);
> +	gtk_init(&argc, &argv);
>  
>          return 0;
>  }

Whitespace damaged.

Thanks,
Namhyung
