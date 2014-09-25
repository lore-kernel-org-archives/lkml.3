Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaIYH46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaIYH45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:56:57 -0400
Date: Thu, 25 Sep 2014 09:55:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jacob Shin <jacob.w.shin@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/4] perf: Support AMD range breakpoints v2
Message-ID: <20140925075516.GA14265@krava.brq.redhat.com>
References: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:45:47PM +0200, Frederic Weisbecker wrote:
> I'm following up on this patchset.
> If that's ok for you I may do a pull request in a few days. I'll just
> need to make sure it doesn't break anything on the tooling side which I
> can't test right now due to some obscure build errors.
> 
> Ah it would be nice if someone who knows well perf test and bison sides
> can check those particular bits.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	perf/core
> 
> HEAD: 6dba1406bb46939ef42501450d6bfbd4e154280c
> 
> Thanks,
> 	Frederic
> ---
> 
> Jacob Shin (4):
>       perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
>       perf tools: allow user to specify hardware breakpoint bp_len
>       perf tools: add hardware breakpoint bp_len test cases
>       perf/x86: Remove get_hbp_len and replace with bp_len

the tools changes looks ok:

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka
