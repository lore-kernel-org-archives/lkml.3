Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaDULCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:02:24 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64175 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaDULCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:02:22 -0400
Message-ID: <5354FAD8.6090402@linaro.org>
Date: Mon, 21 Apr 2014 19:02:48 +0800
From: "kefeng.wang" <kefeng.wang@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Robert Richter <rric@kernel.org>
CC: Kefeng Wang <kefeng.wang@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>, oprofile-list@lists.sf.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: oprofile: add ARMv7 cortex-a15 support
References: <1398075064-4906-1-git-send-email-kefeng.wang@linaro.org>
In-Reply-To: <1398075064-4906-1-git-send-email-kefeng.wang@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore, we have operf tool, this is unnecessary.

On 2014-4-21 18:11, Kefeng Wang wrote:
> ARMv7 cortex-a15 supports Performance Monitor Units, and
> it could be used by oprofile, add perf_pmu_name pair.
> 
> Simply tested on hisilicon hip04 soc.
> 
> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
> ---
>  arch/arm/oprofile/common.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 99c63d4b..9ede34b 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -39,6 +39,7 @@ static struct op_perf_name {
>  	{ "v6mpcore",		"arm/mpcore"	},
>  	{ "ARMv7 Cortex-A8",	"arm/armv7"	},
>  	{ "ARMv7 Cortex-A9",	"arm/armv7-ca9"	},
> +	{ "ARMv7 Cortex-A15",	"arm/armv7-ca15"},
>  };
>  
>  char *op_name_from_perf_id(void)
> 

