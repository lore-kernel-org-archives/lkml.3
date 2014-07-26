Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaGZOzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:55:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:59874 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaGZOzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:55:12 -0400
Date: Sat, 26 Jul 2014 11:55:06 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2] perf: fix arm64 build error
Message-ID: <20140726145506.GM7831@kernel.org>
References: <1406325766-8085-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406325766-8085-1-git-send-email-msalter@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 25, 2014 at 06:02:46PM -0400, Mark Salter escreveu:
> I'm seeing the following build error on arm64:
> 
>   In file included from util/event.c:3:0:
>   util/event.h:95:17: error: 'PERF_REGS_MAX' undeclared here (not in a function)
>     u64 cache_regs[PERF_REGS_MAX];
>                  ^
> 
> This patch adds a PERF_REGS_MAX definition for arm64.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Acked-by: Jean Pihet <jean.pihet@linaro.org>

Thanks, applied to my perf/core branch.

- Arnaldo
