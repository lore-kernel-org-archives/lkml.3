Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3C1SUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:20:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3C1SUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:20:20 -0400
Message-ID: <515489E1.6070409@free-electrons.com>
Date: Thu, 28 Mar 2013 19:20:17 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function
 is specified
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <201303281525.42334.arnd@arndb.de> <20130328153617.GC3368@n2100.arm.linux.org.uk> <201303281549.49990.arnd@arndb.de>
In-Reply-To: <201303281549.49990.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/03/2013 16:49, Arnd Bergmann a écrit :
> On Thursday 28 March 2013, Russell King - ARM Linux wrote:
>> On Thu, Mar 28, 2013 at 03:25:42PM +0000, Arnd Bergmann wrote:
>>>       if (IS_DEFINED(CONFIG_OF) && !machine_desc->init_irq)
>>>               irqchip_init();
>>>       else
>>>               machine_desc->init_irq();
>>>
>>> to the same effect.
>>
>> Provided irqchip_init() keeps its prototype visible, then yes.
> 
> Yes, I checked that before my reply. We have a few function declarations
> that are unfortunately completely hidden when some config symbol is not
> defined, but this is not one of them.

I'll send a v2 with the suggested change.

Thanks!
Maxime


-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
