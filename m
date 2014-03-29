Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaC2KLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 06:11:11 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55752 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaC2KLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 06:11:08 -0400
Message-ID: <53369C37.4030104@gmail.com>
Date: Sat, 29 Mar 2014 11:11:03 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 05/10] ARM: at91: make use of the new AIC driver
 for dt enabled boards
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>	<1396029548-10928-6-git-send-email-b.brezillon.dev@gmail.com> <20140329100756.272c978d@skate>
In-Reply-To: <20140329100756.272c978d@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

Le 29/03/2014 10:07, Thomas Petazzoni a écrit :
> Dear Boris BREZILLON,
>
> On Fri, 28 Mar 2014 18:59:03 +0100, Boris BREZILLON wrote:
>
>> +config ATMEL_AIC_IRQ
>> +	bool
>> +	default USE_OF
>> +	select GENERIC_IRQ_CHIP
>> +	select IRQ_DOMAIN
>> +	select MULTI_IRQ_HANDLER
> This option should probably go in drivers/irqchip/Kconfig, no?

Absolutely, I'll move this section into drivers/irqchip/Kconfig.

Best Regards,

Boris
>
> Thomas

