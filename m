Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3EUJGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:06:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:43233 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3EUJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:05:59 -0400
Message-ID: <519B38F8.1040601@atmel.com>
Date: Tue, 21 May 2013 11:06:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <linux@maxim.org.za>
Subject: Re: [PATCH] Change internal SRAM memory type to "MT_MEMORY_SO"
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/2013 03:05, Wenyou Yang :
> Hi Russell,

Wenyou, In fact this patch is targeted for myself and not Russell. It 
will join mainline using arm-soc git tree which is managed by Arnd and Olof.

> This patch is to change the internal SRAM memory type to "MT_MEMORY_SO", the right type.
>
> It tested on sama5d3xek boards.
>
> It based on v3.10-rc1.
>
> Best Regards,
> Wenyou Yang
>
> Wenyou Yang (1):
>    ARM: at91: Fix: Change internal SRAM memory type to "MT_MEMORY_SO"
>
>   arch/arm/mach-at91/setup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Bye,
-- 
Nicolas Ferre
