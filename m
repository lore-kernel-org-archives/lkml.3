Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3LJM0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:26:09 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:59244 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3LJM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:26:04 -0500
Date: Tue, 10 Dec 2013 13:26:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Arnaldo <acme@ghostprotocols.net>,
        patches@linaro.org, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 0/2] perf: config: add per-feature check flags
Message-ID: <20131210122600.GB30891@gmail.com>
References: <1386678244-13535-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386678244-13535-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@linaro.org> wrote:

> Add CFLAGS and LDFLAGS for each feature to be checked during the
> build. This allows to pass particular flags and parameters to the
> feature checks compilation.
> 
> Use the per-feature check flags for the unwinding feature in order
> to correctly compile the test-all, libunwind and libunwind-debug-frame
> feature checks.
> 
> This change set simplifies the flags passing mechanism between the
> Makefiles in config/Makefile and config/feature-checks; this
> could be farther optimized by moving the compilation flags to the
> per-feature check flags for all features to be checked.
> 
> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR
> set in 'make -C tools/perf'
> 
> 
> Jean Pihet (2):
>   perf: add per-feature check flags
>   perf: unwinding: use the per-feature check flags
> 
>  tools/perf/config/Makefile                | 52 ++++++++++++++++++-------------
>  tools/perf/config/feature-checks/Makefile |  8 ++---
>  2 files changed, 34 insertions(+), 26 deletions(-)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
