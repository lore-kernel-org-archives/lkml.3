Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaAFSgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:36:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35043 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235AbaAFSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:36:17 -0500
Date: Mon, 6 Jan 2014 18:36:05 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 2/3] ARM64: perf: wire up perf_regs and unwind support
Message-ID: <20140106183605.GH1096@mudshark.cambridge.arm.com>
References: <1388420732-13961-1-git-send-email-jean.pihet@linaro.org>
 <1388420732-13961-3-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388420732-13961-3-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 04:25:31PM +0000, Jean Pihet wrote:
> From: Jean Pihet <jean.pihet@newoldbits.com>
> 
> This patch hooks in the perf_regs and libunwind code for ARM64.
> The tools/perf/arch/arm64 is created; it contains the arch specific
> code for DWARF unwinding.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  tools/perf/arch/arm64/Makefile            |  7 +++
>  tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/dwarf-regs.c   | 80 ++++++++++++++++++++++++++++
>  tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
>  tools/perf/config/Makefile                |  8 ++-
>  5 files changed, 264 insertions(+), 1 deletion(-)
>  create mode 100644 tools/perf/arch/arm64/Makefile
>  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>  create mode 100644 tools/perf/arch/arm64/util/unwind.c

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
