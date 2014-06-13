Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaFMOTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:19:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46145 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbaFMOTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:19:41 -0400
Message-ID: <539B0870.2020807@free-electrons.com>
Date: Fri, 13 Jun 2014 16:19:28 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: at91/dt: clock fixes
References: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13/06/2014 15:43, Alexandre Belloni wrote:
> Some clocks were not properly defined:
>  - ICPLL and OUT values for PLLA got mixed on sam9x5 and sam9n12
>  - mainck was not correctly defined on sam9261

On the whole series:

Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Thanks.

Boris
>
> Alexandre Belloni (3):
>   ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
>   ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
>   ARM: at91/dt: sam9261: correctly define mainck
>
>  arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++++--
>  arch/arm/boot/dts/at91sam9n12.dtsi |  4 ++--
>  arch/arm/boot/dts/at91sam9x5.dtsi  |  4 ++--
>  3 files changed, 12 insertions(+), 6 deletions(-)
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

