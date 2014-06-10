Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFJMdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:33:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:24883 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaFJMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:33:09 -0400
Message-ID: <5396FB0A.6070808@atmel.com>
Date: Tue, 10 Jun 2014 14:33:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: at91/sama5_defconfig: enable sound support
References: <1402047426-4058-1-git-send-email-voice.shen@atmel.com> <1402047426-4058-2-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1402047426-4058-2-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 11:37, Bo Shen :
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Added to at91-3.17-defconfig. Thanks.

> ---
>  arch/arm/configs/sama5_defconfig | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index dc3881e..c8613f0 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -144,6 +144,11 @@ CONFIG_BACKLIGHT_LCD_SUPPORT=y
>  CONFIG_BACKLIGHT_CLASS_DEVICE=y
>  # CONFIG_BACKLIGHT_GENERIC is not set
>  CONFIG_FRAMEBUFFER_CONSOLE=y
> +CONFIG_SOUND=y
> +CONFIG_SND=y
> +CONFIG_SND_SOC=y
> +CONFIG_SND_ATMEL_SOC=y
> +CONFIG_SND_ATMEL_SOC_WM8904=y
>  # CONFIG_HID_GENERIC is not set
>  CONFIG_USB=y
>  CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 


-- 
Nicolas Ferre
