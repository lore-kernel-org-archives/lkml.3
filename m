Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3GSTaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:30:30 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41015 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3GSTa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:30:29 -0400
Message-ID: <51E993D5.2080409@gmail.com>
Date: Fri, 19 Jul 2013 15:30:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, dave@sr71.net,
        kosaki.motohiro@gmail.com, isimatu.yasuaki@jp.fujitsu.com,
        tangchen@cn.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH v2] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..408ef68 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1344,8 +1344,13 @@ config ARCH_SELECT_MEMORY_MODEL
>   	depends on ARCH_SPARSEMEM_ENABLE
>   
>   config ARCH_MEMORY_PROBE
> -	def_bool y
> +	bool "Enable sysfs memory/probe interface"
> +	default n
>   	depends on X86_64 && MEMORY_HOTPLUG
> +	help
> +	  This option enables a sysfs memory/probe interface for testing.
> +	  See Documentation/memory-hotplug.txt for more information.
> +	  If you are unsure how to answer this question, answer N.

makes sense.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




