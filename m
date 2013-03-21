Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3CUFfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:35:12 -0400
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:12845 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295Ab3CUFfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:35:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBALKbSlGVhxBY/2dsb2JhbAANNogfvRuBboMYAQEBBCMVQAEQCw4KAgIFFgsCAgkDAgECAUUGDQEFAgEBtyxxkjWBI41tB4ItgRMDqn4
X-IronPort-AV: E=Sophos;i="4.84,883,1355068800"; 
   d="scan'208";a="85736872"
Message-ID: <514A9BC7.2010201@uclinux.org>
Date: Thu, 21 Mar 2013 15:33:59 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: clean up unused "config ROMVECSIZE"
References: <1363775886.1390.90.camel@x61.thuisdomein>
In-Reply-To: <1363775886.1390.90.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 20/03/13 20:38, Paul Bolle wrote:
> Kconfig symbol ROMVECSIZE is unused since commit
> f84f52a5c15db7d14a534815f27253b001735183 ("m68knommu: clean up linker
> script"). Let's clean up its Kconfig entry too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, I'll add it to the m68knommu git tree.

Regards
Greg


> ---
> Untested.
>
>   arch/m68k/Kconfig.machine | 9 ---------
>   1 file changed, 9 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
> index 7240584..28ec0c0 100644
> --- a/arch/m68k/Kconfig.machine
> +++ b/arch/m68k/Kconfig.machine
> @@ -539,15 +539,6 @@ config ROMVEC
>   	  68000 type variants the vectors are at the base of the boot device
>   	  on system startup.
>
> -config ROMVECSIZE
> -	hex "Size of ROM vector region (in bytes)"
> -	default "0x400"
> -	depends on ROM
> -	help
> -	  Define the size of the vector region in ROM. For most 68000
> -	  variants this would be 0x400 bytes in size. Set to 0 if you do
> -	  not want a vector region at the start of the ROM.
> -
>   config ROMSTART
>   	hex "Address of the base of system image in ROM"
>   	default "0x400"
>

