Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3JJFoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:44:24 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65398 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3JJFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:44:23 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-9c-52563eb5ec13
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 03/52] tools/perf/build: Add 'autodep' functionality, generate feature test dependencies automatically
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-4-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 14:44:21 +0900
In-Reply-To: <1381227082-22039-4-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:33 +0200")
Message-ID: <87li21k7d6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:10:33 +0200, Ingo Molnar wrote:
> +-include *.d */*.d

Hmm.. this */*.d part is really needed?

> +
>  ###############################
>  
>  clean:
> -	rm -f $(FILES)
> +	rm -f $(FILES) *.d

If so, at least it'd be deleted from here IMHO.

Thanks,
Namhyung
