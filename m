Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3KZR60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:58:26 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63407 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3KZR6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:58:23 -0500
Date: Tue, 26 Nov 2013 18:58:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo <acme@ghostprotocols.net>, patches@linaro.org
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
Message-ID: <20131126175819.GB9958@gmail.com>
References: <1385045539-24537-1-git-send-email-jean.pihet@linaro.org>
 <1385045539-24537-3-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385045539-24537-3-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Pihet <jean.pihet@linaro.org> wrote:

> Use the per-feature check flags for the unwinding feature in order
> to correctly compile the libunwind and libunwind-debug-frame feature
> checks.
> 
> Tested on ARMv7 and ARMv8 with 'make DEBUG=1 LIBUNWIND_DIR=/usr/local
> -C tools/perf'
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> ---
>  tools/perf/config/Makefile                | 38 +++++++++++++++++--------------
>  tools/perf/config/feature-checks/Makefile |  6 ++---
>  2 files changed, 24 insertions(+), 20 deletions(-)

Does the x86 build work fine as well, as before? If yes then:

Acked-by: Ingo Molnar <mingo@kernel.org>
 
Thanks,

	Ingo
