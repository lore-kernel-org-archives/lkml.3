Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3LZTyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:54:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53064 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3LZTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:54:04 -0500
Message-ID: <52BC8957.4000705@infradead.org>
Date: Thu, 26 Dec 2013 11:53:59 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        sjenning@linux.vnet.ibm.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: zswap: Add kernel parameters for zswap in kernel-parameters.txt
References: <1388061179-26624-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1388061179-26624-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/13 04:32, Masanari Iida wrote:
> This patch adds kernel parameters for zswap.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/kernel-parameters.txt | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 60a822b..209730af 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3549,6 +3549,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Format:
>  			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
>  
> +	zswap.compressor= [KNL]
> +			Specify compressor algorithm.
> +			By default, set to lzo.

what are the options for compressor algorithm?
and does it depend on any kernel (compressor) configs?


> +
> +	zswap.enabled=	[KNL]
> +			Format: <0|1>
> +			0: Disable zswap (default)
> +			1: Enable zswap
> +			See more information, Documentations/vm/zswap.txt
> +
> +	zswap.max_pool_percent=	[KNL]
> +			The maximum percentage of memory that the compressed
> +			pool can occupy. By default, set to 20.
>  ______________________________________________________________________
>  
>  TODO:
> 


-- 
~Randy
