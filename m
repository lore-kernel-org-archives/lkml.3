Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258Ab3CGF3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 00:29:45 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3CGF3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 00:29:44 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-b2-513825c57b53
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, tools: Fix compilation without newt support
References: <1362611957-4358-1-git-send-email-andi@firstfloor.org>
	<1362611957-4358-2-git-send-email-andi@firstfloor.org>
Date: Thu, 07 Mar 2013 14:29:41 +0900
In-Reply-To: <1362611957-4358-2-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Wed, 6 Mar 2013 15:19:17 -0800")
Message-ID: <87obevrd4q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Mar 2013 15:19:17 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Fix
>
> builtin-annotate.c: In function ‘hists__find_annotations’:
> builtin-annotate.c:161:4: error: duplicate case value
> builtin-annotate.c:154:4: error: previously used here
>
> and
>
> builtin-report.c:479:15: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
> builtin-report.c:479:15: note: each undeclared identifier is reported only once for each function it appears in
> builtin-report.c: In function ‘cmd_report’:
> builtin-report.c:823:13: error: ‘K_SWITCH_INPUT_DATA’ undeclared (first use in this function)
>
> by changing the values of the fallback K_LEFT, K_RIGHT and adding a
> dummy K_SWITCH_INPUT_DATA too

The fixes are already in the acme/perf/core.

Thanks,
Namhyung
