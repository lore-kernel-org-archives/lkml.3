Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3L2AzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 19:55:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3L2AzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 19:55:02 -0500
Message-ID: <52BF72E1.9030207@infradead.org>
Date: Sat, 28 Dec 2013 16:54:57 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Hayato Suzuki <hytszk@gmail.com>, trivial@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [trivial] treewide:Fix typo Kconfig
References: <1388276129-2132-1-git-send-email-hytszk@gmail.com>
In-Reply-To: <1388276129-2132-1-git-send-email-hytszk@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/13 16:15, Hayato Suzuki wrote:
> Correct spelling typo in Kconfig.
> 
> Signed-off-by: Hayato Suzuki <hytszk@gmail.com>
> ---
>  arch/powerpc/platforms/40x/Kconfig | 2 +-
>  arch/x86/crypto/aesni-intel_avx.S  | 8 ++++----
>  crypto/Kconfig                     | 2 +-
>  init/Kconfig                       | 2 +-
>  sound/oss/Kconfig                  | 2 +-
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index 6e287f1..e5fbb2c 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -82,7 +82,7 @@ config OBS600
>  	select 405EX
>  	select PPC40x_SIMPLE
>  	help
> -	  This option enables support for PlatHome OpenBlockS 600 server

google tells me that Plat'Home is correct.

> +	  This option enables support for Platform OpenBlockS 600 server
>  
>  
>  config PPC40x_SIMPLE
> diff --git a/arch/x86/crypto/aesni-intel_avx.S b/arch/x86/crypto/aesni-intel_avx.S
> index 522ab68..3f202c2 100644
> --- a/arch/x86/crypto/aesni-intel_avx.S
> +++ b/arch/x86/crypto/aesni-intel_avx.S
> @@ -1282,7 +1282,7 @@ _zero_cipher_left\@:
>  
>          je      _multiple_of_16_bytes\@
>  
> -        # handle the last <16 Byte block seperately
> +        # handle the last <16 Byte block separately
>  
>  
>          vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
> @@ -1308,7 +1308,7 @@ _only_less_than_16\@:
>  
>          je      _multiple_of_16_bytes\@
>  
> -        # handle the last <16 Byte block seperately
> +        # handle the last <16 Byte block separately
>  
>  
>          vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
> @@ -2559,7 +2559,7 @@ _zero_cipher_left\@:
>  
>          je      _multiple_of_16_bytes\@
>  
> -        # handle the last <16 Byte block seperately
> +        # handle the last <16 Byte block separately
>  
>  
>          vpaddd   ONE(%rip), %xmm9, %xmm9             # INCR CNT to get Yn
> @@ -2585,7 +2585,7 @@ _only_less_than_16\@:
>  
>          je      _multiple_of_16_bytes\@
>  
> -        # handle the last <16 Byte block seperately
> +        # handle the last <16 Byte block separately
>  
>  
>          vpaddd  ONE(%rip), %xmm9, %xmm9              # INCR CNT to get Yn
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 7bcb70d..ceb085e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1120,7 +1120,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
>  	  Keys are allowed to be from 0 to 256 bits in length, in steps
>  	  of 8 bits.
>  
> -	  This module provides Serpent cipher algorithm that processes eigth
> +	  This module provides Serpent cipher algorithm that processes eight
>  	  blocks parallel using SSE2 instruction set.
>  
>  	  See also:
> diff --git a/init/Kconfig b/init/Kconfig
> index 8d402e3..46b5089 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -523,7 +523,7 @@ config CONTEXT_TRACKING_FORCE
>  	  dynticks working.
>  
>  	  This option stands for testing when an arch implements the
> -	  context tracking backend but doesn't yet fullfill all the
> +	  context tracking backend but doesn't yet fulfill all the
>  	  requirements to make the full dynticks feature working.
>  	  Without the full dynticks, there is no way to test the support
>  	  for context tracking and the subsystems that rely on it: RCU
> diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
> index 1a96402..fbf07e9 100644
> --- a/sound/oss/Kconfig
> +++ b/sound/oss/Kconfig
> @@ -318,7 +318,7 @@ config SOUND_MSS
>  	  made by Microsoft or Aztech SG 16 Pro (or NX16 Pro).  Also you may
>  	  say Y in case your card is NOT among these:
>  
> -	  ATI Stereo F/X, AdLib, Audio Excell DSP16, Cardinal DSP16,
> +	  ATI Stereo F/X, AdLib, Audio Excel DSP16, Cardinal DSP16,

It can be difficult to tell with product names.  Are you sure about
this one?
I can't find anything definitive about it.

>  	  Ensoniq SoundScape (and compatibles made by Reveal and Spea),
>  	  Gravis Ultrasound, Gravis Ultrasound ACE, Gravis Ultrasound Max,
>  	  Gravis Ultrasound with 16 bit option, Logitech Sound Man 16,
> 


-- 
~Randy
