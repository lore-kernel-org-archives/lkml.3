Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaENFuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:50:52 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50776 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaENFuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:50:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>,
        fweisbec@gmail.com
Subject: Re: [PATCH 9/9] perf, tools, record: Always allow to overide default period v2
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
	<1399935074-25167-10-git-send-email-andi@firstfloor.org>
Date: Wed, 14 May 2014 14:50:47 +0900
In-Reply-To: <1399935074-25167-10-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 12 May 2014 15:51:14 -0700")
Message-ID: <87r43wlxhk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 15:51:14 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Fix the logic to allow overriding event default periods with -c or -F
> on the command line.  I'm not sure I understand this if() fully, but
> this change makes all cases I tested work (tracepoint with default, default,
> ,-c, -F)
>
> This fixed specifying -c / -F with json event list events,
> which have a default period. It should do the same
> for trace point events.

Hmm.. doesn't that require both -c and -F are given at the same time?

Anyway, there was a similar discussion, but I suggested an other way.
Please see the line below.

https://lkml.org/lkml/2014/2/4/807

Thanks,
Namhyung
