Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbaDGMsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:48:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35861 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaDGMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:48:15 -0400
Message-ID: <53429E8C.3000403@linaro.org>
Date: Mon, 07 Apr 2014 13:48:12 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: patches@linaro.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v3] arm: Fix DEBUG_LL for multi-platform kernels (without
 PL01X)
References: <1396622847-12718-1-git-send-email-daniel.thompson@linaro.org> <1396626102-13991-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1396626102-13991-1-git-send-email-daniel.thompson@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 16:41, Daniel Thompson wrote:
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 0531da8..7e19c94 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -989,12 +989,7 @@ config DEBUG_LL_INCLUDE
>  
>  # Compatibility options for PL01x
>  config DEBUG_UART_PL01X
> -	def_bool ARCH_EP93XX || \
> -		ARCH_INTEGRATOR || \
> -		ARCH_SPEAR3XX || \
> -		ARCH_SPEAR6XX || \
> -		ARCH_SPEAR13XX || \
> -		ARCH_VERSATILE
> +	bool

NACK!

Sorry. I've got my posting-a-patch and my testing in the wrong order!

This patch regresses the build for (at least) the versatile. Expect v4
in due course (after I have improved my build automation).


Daniel.

