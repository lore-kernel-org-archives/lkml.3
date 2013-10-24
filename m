Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3JXOvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3JXOvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:51:06 -0400
Date: Thu, 24 Oct 2013 16:50:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Arnaldo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 2/2] ARM64: perf: wire up perf_regs and unwind support
Message-ID: <20131024145025.GA1493@krava.redhat.com>
References: <1382108078-8807-1-git-send-email-jean.pihet@linaro.org>
 <1382108078-8807-3-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382108078-8807-3-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:54:38PM +0200, Jean Pihet wrote:

SNIP

> +	return -EINVAL;
> +}
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 75b93d7..15a69a5 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -29,11 +29,17 @@ ifeq ($(ARCH),x86_64)
>    NO_PERF_REGS := 0
>    LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
>  endif
> +
>  ifeq ($(ARCH),arm)
>    NO_PERF_REGS := 0
>    LIBUNWIND_LIBS = -lunwind -lunwind-arm
>  endif

I dont see above 'ifeq' in acme's or in tip tree, so hunk
below fails to apply.. what tree was this based on?

otherwise the change looks good to me

jirka
