Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaIZPIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaIZPIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:08:36 -0400
Date: Fri, 26 Sep 2014 17:04:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jacob Shin <jacob.w.shin@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/4] perf: Support AMD range breakpoints v2
Message-ID: <20140926150415.GA30019@redhat.com>
References: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Frederic Weisbecker wrote:
>
> Jacob Shin (4):
>       perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
>       perf tools: allow user to specify hardware breakpoint bp_len
>       perf tools: add hardware breakpoint bp_len test cases
>       perf/x86: Remove get_hbp_len and replace with bp_len

Looks like, this is the same/unchanged patchset.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

