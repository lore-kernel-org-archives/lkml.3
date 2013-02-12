Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3BLIcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:32:53 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50706 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3BLIcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:32:52 -0500
Message-ID: <5119FE2A.5040108@atmel.com>
Date: Tue, 12 Feb 2013 09:32:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Robert Nelson <Robert.Nelson@digikey.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [GIT PULL] at91: fixes for 3.9-rc1
References: <5110DCDE.1080403@atmel.com>
In-Reply-To: <5110DCDE.1080403@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 11:20 AM, Nicolas Ferre :
> Arnd, Olof,
> 
> As I realized reading Linus' email that it was not possible to queue more
> fixes for 3.8, I took my time to send this tiny pull request. But now that
> the merge window is approaching, I prefer not to wait for more material.
> So, here is a "fixes" pull-request embedding a single patch. I have placed this
> one on top of material that you already have from me in your "fixes" and
> "for-next" branches.

Olof,

Ping?

As the other AT91 related branches have been pulled in, I suspect this
little pull-request had been forgotten.

Best regards,


> The following changes since commit 7d4cfece23f535b60496d88a717a3d7bfca50187:
> 
>   ARM: at91/at91sam9x5.dtsi: fix usart3 TXD (2013-01-30 10:09:17 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to c3f0f282d950a1e87496a2633ed9e924e275ff8c:
> 
>   ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes (2013-02-05 10:55:11 +0100)
> 
> ----------------------------------------------------------------
> Correction of 9x5 and 9n12 USART nodes
> 
> ----------------------------------------------------------------
> Nicolas Ferre (1):
>       ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes
> 
>  arch/arm/boot/dts/at91sam9n12.dtsi | 8 --------
>  arch/arm/boot/dts/at91sam9x5.dtsi  | 6 ------
>  2 files changed, 14 deletions(-)
> 
> 
> Thanks, bye,
> 


-- 
Nicolas Ferre
