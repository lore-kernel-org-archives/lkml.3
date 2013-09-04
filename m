Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab3IDIhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:37:14 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47852 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934343Ab3IDIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:37:06 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-22-5226f1315e5d
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 03/24] perf tools: Unify page_size usage
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
	<1378032529-18498-4-git-send-email-jolsa@redhat.com>
Date: Wed, 04 Sep 2013 17:37:05 +0900
In-Reply-To: <1378032529-18498-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sun, 1 Sep 2013 12:48:28 +0200")
Message-ID: <87k3ixrnim.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Sep 2013 12:48:28 +0200, Jiri Olsa wrote:
> Making page_size global from the util object.
> Removing the not needed one.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
