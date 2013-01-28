Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3A1KBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:01:34 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:63480 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3A1KBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:01:31 -0500
Date: Mon, 28 Jan 2013 11:01:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Make numa benchmark optional
Message-ID: <20130128100126.GA7168@gmail.com>
References: <1354913744-29902-2-git-send-email-mingo@kernel.org>
 <1359337882-21821-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359337882-21821-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Hurley <peter@hurleysoftware.com> wrote:

> Commit "perf: Add 'perf bench numa mem'..." added a NUMA performance
> benchmark to perf. Make this optional and test for required
> dependencies.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  tools/perf/Makefile                 | 16 ++++++++++++++--
>  tools/perf/builtin-bench.c          |  4 ++++
>  tools/perf/config/feature-tests.mak | 11 +++++++++++
>  3 files changed, 29 insertions(+), 2 deletions(-)

Thanks!

Acked-by: Ingo Molnar <mingo@kernel.org>

Arnaldo, can we merge tip:perf/bench into perf/core, or is there 
anything else to be done with that commit?

Thanks,

	Ingo
