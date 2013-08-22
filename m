Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3HVKO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:14:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:58835 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3HVKO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:14:28 -0400
Message-ID: <5215E499.3060403@atmel.com>
Date: Thu, 22 Aug 2013 12:14:49 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] arm: atmel: enable kernel uncompress info output
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 09:16, Bo Shen :
> this patch set enable kernel uncompress info output
>    - sama5d3
>    - at91sam9n12

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Whole series integrated in at91-3.12-soc branch.

Thanks, bye,

>
> without this patch set, it won't show following information
> ---8>---
> Uncompressing Linux... done, booting the kernel.
> ---<8---
>
>
> Bo Shen (4):
>    arm: atmel: sama5: add definition for usart base address
>    arm: atmel: include sama5d3.h into hardware.h
>    arm: atmel: sama5: enable kernel uncompress info output
>    arm: atmel: sam9n12: enable kernel uncompress info output
>
>   arch/arm/mach-at91/include/mach/hardware.h   |    1 +
>   arch/arm/mach-at91/include/mach/sama5d3.h    |    8 ++++++++
>   arch/arm/mach-at91/include/mach/uncompress.h |   13 +++++++++++++
>   3 files changed, 22 insertions(+)
>


-- 
Nicolas Ferre
