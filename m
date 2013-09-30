Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3I3Hsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:48:32 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:64427 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3I3Hsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:48:31 -0400
X-AuditID: 9c93017d-b7c2dae000000ea6-7a-52492ccd8285
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, jolsa@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, namhyung.kim@lge.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Fix sorting for 64bit entries
References: <1380325164-4478-1-git-send-email-andi@firstfloor.org>
Date: Mon, 30 Sep 2013 16:48:25 +0900
In-Reply-To: <1380325164-4478-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 27 Sep 2013 16:39:24 -0700")
Message-ID: <87pprqoily.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 27 Sep 2013 16:39:24 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Some of the node comparisons in hist.c dropped the upper
> 32bit by using an int variable to store the compare
> result. This broke various 64bit fields, causing
> incorrect collapsing (found for the TSX transaction field)
>
> Just use int64_t always.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
