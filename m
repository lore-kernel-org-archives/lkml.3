Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3FYLFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:05:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45966 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab3FYLFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130625103440.GR11232@pengutronix.de>
References: <1371073835-10639-1-git-send-email-u.kleine-koenig@pengutronix.de> <20130625103440.GR11232@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jun 2013 12:04:44 +0100
X-Google-Sender-Auth: 052cxl7LhXLxLbg1psANWXh33_I
Message-ID: <CACxGe6vBCKCnXRtvT9N6cRPa7uHTJDMw7k-46eCj7fFPko+Raw@mail.gmail.com>
Subject: Re: [PATCH v4] irqchip: Add support for ARMv7-M's NVIC
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 11:34 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello Thomas, hello Grant,
>
> On Wed, Jun 12, 2013 at 11:50:35PM +0200, Uwe Kleine-König wrote:
>> This interrupt controller is found on Cortex-M3 and Cortex-M4 machines.
>>
>> Support for this controller appeared in Catalin's Cortex tree based on
>> 2.6.33 but was nearly completely rewritten.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> ---
>>
>> Notes:
>>     Changes since v3, sent with
>>     Message-Id: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de>:
>>
>>      - use generic chip
>>      - rename nvic_do_IRQ to nvic_handle_irq
>>
>>     This depends on the stuff currently in tip/irq/for-arm
> I see that tip/irq/for-arm went into next via Grant's irqdomain tree. I
> assume that means the changes go in for 3.11?

Yes, the plan is to put that branch into v3.11. I don't know if Thomas
plans to send a separate pull request for the irq/for-arm branch, or
if he is going to let it go as part of my pull request. I'll work it
out with him when the merge window opens. It would probably be best
for your patch to be applied on the irq/for-arm branch and pushed
separately from my irqdomain branch since I don't maintain any of the
irqchip drivers.

g.
