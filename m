Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaAMI5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:57:06 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53680 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaAMI5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:57:04 -0500
X-AuditID: 9c930197-b7c20ae000001031-fc-52d3aa5e8828
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Add --initial-delay support to perf record v3
References: <1389476307-2124-1-git-send-email-andi@firstfloor.org>
Date: Mon, 13 Jan 2014 17:57:02 +0900
In-Reply-To: <1389476307-2124-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Sat, 11 Jan 2014 13:38:27 -0800")
Message-ID: <87k3e4b6ox.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, 11 Jan 2014 13:38:27 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> perf stat has a --delay option to delay measuring the workload.
> This is useful to skip measuring the startup phase of the program, which
> is often very different from the main workload.
>
> The same is useful for perf record when sampling.
>
> --no-delay was already taken, so add a --initial-delay
> to perf record too.
> -D was already taken for record, so there is only a long option.
>
> v2: Don't disable group members (Namhyung Kim)
> v3: port to latest perf/core
>     rename to --initial-delay to avoid conflict with --no-delay

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
