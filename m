Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaLDSaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:30:04 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37812 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753841AbaLDSaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:30:02 -0500
Date: Thu, 4 Dec 2014 18:29:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, tixy@linaro.org, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
Message-ID: <20141204182946.GO11285@n2100.arm.linux.org.uk>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 01:36:00PM +0800, Wang Nan wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 89c4b5c..8281cea 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>  	select HAVE_MEMBLOCK
>  	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
>  	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
> +	select HAVE_OPTPROBES if (!THUMB2_KERNEL)

Please don't add extra parens where they're not required.

> +#define MAX_COPIED_INSN	(DIV_ROUND_UP(RELATIVEJUMP_SIZE, sizeof(kprobe_opcode_t)))

ditto.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
