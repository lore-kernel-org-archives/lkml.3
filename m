Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3KTKne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:43:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:39313 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTKnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:43:32 -0500
Message-ID: <528C924E.50206@atmel.com>
Date: Wed, 20 Nov 2013 11:43:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>
Subject: Re: [PATCH RESEND 0/7] crypto: at91/atmel: add Device Tree support
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2013 16:08, Nicolas Ferre :
> This series adds Device Tree support to the Atmel crypto drivers
> (AES/[T]DES/SHA). The Device Tree entries are very simple and only
> declare the reg/irq values and the link to DMA.

Herbert,

ping?

Could I have your "Acked-by" for taking these patches through the 
arm-soc git tree, or do you want that we split this series so that you 
can take the driver part of it?

Best regards,


> Some trivial patches are preceding this move to Device Tree to clean
> things up beforehand.
>
> The series has already been sent but a little bit scattered. So I collect
> everything, this time.
>
> Nicolas Ferre (7):
>    ARM: at91/dt/trivial: use macro for AES irq type
>    ARM: at91/dt/trivial: before sama5d3, Atmel MPU were using at91 prefix
>    ARM: at91/dt/sama5d3: add DMA information to SHA/AES/TDES nodes
>    crypto: atmel-aes - add support for Device Tree
>    crypto: atmel-tdes - add support for Device Tree
>    crypto: atmel-sha - add support for Device Tree
>    crypto: atmel-sha - add sha information to the log
>
>   .../devicetree/bindings/crypto/atmel-crypto.txt    |  68 ++++++++++
>   arch/arm/boot/dts/sama5d3.dtsi                     |  16 ++-
>   drivers/crypto/atmel-aes.c                         | 143 ++++++++++++++-------
>   drivers/crypto/atmel-sha.c                         | 103 +++++++++++----
>   drivers/crypto/atmel-tdes.c                        | 143 ++++++++++++++-------
>   5 files changed, 346 insertions(+), 127 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt
>


-- 
Nicolas Ferre
