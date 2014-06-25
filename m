Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaFYKh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:37:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:28461 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFYKhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:37:24 -0400
Message-ID: <53AAA660.1030001@atmel.com>
Date: Wed, 25 Jun 2014 12:37:20 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: at91/dt: clock fixes
References: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2014 15:43, Alexandre Belloni :
> Some clocks were not properly defined:
>  - ICPLL and OUT values for PLLA got mixed on sam9x5 and sam9n12
>  - mainck was not correctly defined on sam9261
> 
> Alexandre Belloni (3):
>   ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
>   ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
>   ARM: at91/dt: sam9261: correctly define mainck

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

and added to the at91-3.16-fixes branch.

Thanks,

>  arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++++--
>  arch/arm/boot/dts/at91sam9n12.dtsi |  4 ++--
>  arch/arm/boot/dts/at91sam9x5.dtsi  |  4 ++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 


-- 
Nicolas Ferre
