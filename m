Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3JNXhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:37:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35073 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab3JNXhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:37:02 -0400
Message-ID: <525C8018.3070805@gmail.com>
Date: Tue, 15 Oct 2013 10:36:56 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: ep93xx: remove deprecated IRQF_DISABLED
References: <1381547439-4888-1-git-send-email-michael.opdenacker@free-electrons.com> <DC148C5AA1CEBA4E87973D432B1C2D8817DAB036@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817DAB036@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/13 02:47, Hartley Sweeten wrote:
> On Friday, October 11, 2013 8:11 PM, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>  arch/arm/mach-ep93xx/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
>> index 3f12b88..fcc965f 100644
>> --- a/arch/arm/mach-ep93xx/core.c
>> +++ b/arch/arm/mach-ep93xx/core.c
>> @@ -136,7 +136,7 @@ static irqreturn_t ep93xx_timer_interrupt(int irq, void *dev_id)
>>  
>>  static struct irqaction ep93xx_timer_irq = {
>>  	.name		= "ep93xx timer",
>> -	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
>> +	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
>>  	.handler	= ep93xx_timer_interrupt,
>>  };
>>  
> 
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied to ep93xx-fixes.

Thanks,
~Ryan


