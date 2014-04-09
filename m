Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaDIAb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:31:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38027 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaDIAbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:31:55 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com
Subject: Re: [PATCH 0/4 v2] perf: Make some functions generic
References: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 09:31:53 +0900
In-Reply-To: <1396896924-129847-1-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 7 Apr 2014 14:55:20 -0400")
Message-ID: <87mwfvuyva.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Apr 2014 14:55:20 -0400, Don Zickus wrote:
> This patch just converts some private functions into global ones
> that can be used by other tools like the c2c tool I am trying to merge.

For the series,

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

>
> Don Zickus (4):
>   perf: Allow ability to map cpus to nodes easily
>   perf: Use cpu/possible instead of cpu/kernel_max
>   perf, kmem: Utilize the new generic cpunode_map
>   perf, callchain: Add generic report parse callchain callback function
>
>  tools/perf/builtin-kmem.c   |  78 +----------------------
>  tools/perf/builtin-report.c |  81 +-----------------------
>  tools/perf/util/callchain.c |  82 ++++++++++++++++++++++++
>  tools/perf/util/callchain.h |   1 +
>  tools/perf/util/cpumap.c    | 149 ++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/cpumap.h    |  35 +++++++++++
>  6 files changed, 273 insertions(+), 153 deletions(-)
