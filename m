Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaBIUCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:02:33 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751646AbaBIUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:02:32 -0500
Message-ID: <52F7DED2.1020509@nod.at>
Date: Sun, 09 Feb 2014 21:02:26 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Christian Daudt <bcm@fixthebug.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/28] Remove GENERIC_TIME
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-13-git-send-email-richard@nod.at> <1391972239.567717844@f148.i.mail.ru>
In-Reply-To: <1391972239.567717844@f148.i.mail.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2014 19:57, schrieb Alexander Shiyan:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>> arch/arm/mach-bcm/Kconfig | 1 -
>> 1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>> index b1aa6a9..8dd5fbf 100644
>> --- a/arch/arm/mach-bcm/Kconfig
>> +++ b/arch/arm/mach-bcm/Kconfig
>> @@ -19,7 +19,6 @@ config ARCH_BCM_MOBILE
>> select CPU_V7
>> select CLKSRC_OF
>> select GENERIC_CLOCKEVENTS
>> -	select GENERIC_TIME
>> select GPIO_BCM_KONA
>> select SPARSE_IRQ
>> select TICK_ONESHOT
>> -- 
>> 1.8.4.2
> 
> I sent a similar patch in November, maintainers nothing did with it.
> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/278293

Then it is time to push it. :D

Thanks,
//richard
