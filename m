Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbaJ3LsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:48:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52554 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972AbaJ3LsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:48:24 -0400
Message-ID: <54522584.2030102@cogentembedded.com>
Date: Thu, 30 Oct 2014 14:48:20 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        tglx@linutronix.de, jason@lakedaemon.net, ralf@linux-mips.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 09/15] irqchip: Remove ARM dependency for bcm7120-l2
 and brcmstb-l2
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-10-git-send-email-cernekee@gmail.com> <54521CA6.1000802@cogentembedded.com> <3334166.jta5WKHbUO@wuerfel>
In-Reply-To: <3334166.jta5WKHbUO@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/30/2014 2:24 PM, Arnd Bergmann wrote:

>>> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
>>> index b21f12f..09c79d1 100644
>>> --- a/drivers/irqchip/Kconfig
>>> +++ b/drivers/irqchip/Kconfig
>>> @@ -50,7 +50,6 @@ config ATMEL_AIC5_IRQ
>>>
>>>    config BRCMSTB_L2_IRQ
>>>        bool
>>> -     depends on ARM

>>      How about the following?

>>          depends on ARM || MIPS || COMPILE_TEST

> Makes no sense when the driver isn't user-selectable.

    Ah, I was just blind. :-/

> 	Arnd

WBR, Sergei

