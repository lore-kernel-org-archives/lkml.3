Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbaDIBuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:50:00 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50876 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIBt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:49:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, tools, stat: Initialize statistics correctly
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
Date: Wed, 09 Apr 2014 10:49:56 +0900
In-Reply-To: <1395768699-16060-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Tue, 25 Mar 2014 10:31:38 -0700")
Message-ID: <8761mjuv97.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014 10:31:38 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> perf stat did initialize the stats structure used to compute
> stddev etc. incorrectly. It merely zeroes it. But one member
> (min) needs to be set to a non zero value. This causes min
> to be not computed at all. Call init_stats() correctly.
>
> It doesn't matter for stat currently because it doesn't use
> min, but it's still better to do it correctly.
>
> The other users of statistics are already correct.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
