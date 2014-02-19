Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaBSGM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:12:26 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:49701 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaBSGMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:12:21 -0500
MIME-Version: 1.0
In-Reply-To: <52F7DED2.1020509@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-13-git-send-email-richard@nod.at>
	<1391972239.567717844@f148.i.mail.ru>
	<52F7DED2.1020509@nod.at>
Date: Tue, 18 Feb 2014 22:12:20 -0800
Message-ID: <CAEPRUYprJH5AG-P=c+Oj4NEqiv=DBgTy9cX0NNOcez+vY9VxeQ@mail.gmail.com>
Subject: Re: [PATCH 12/28] Remove GENERIC_TIME
From: Christian Daudt <bcm@fixthebug.org>
To: Richard Weinberger <richard@nod.at>
Cc: Alexander Shiyan <shc_work@mail.ru>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 12:02 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 09.02.2014 19:57, schrieb Alexander Shiyan:
>>> The symbol is an orphan, get rid of it.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>> arch/arm/mach-bcm/Kconfig | 1 -
>>> 1 file changed, 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
>>> index b1aa6a9..8dd5fbf 100644
>>> --- a/arch/arm/mach-bcm/Kconfig
>>> +++ b/arch/arm/mach-bcm/Kconfig
>>> @@ -19,7 +19,6 @@ config ARCH_BCM_MOBILE
>>> select CPU_V7
>>> select CLKSRC_OF
>>> select GENERIC_CLOCKEVENTS
>>> -    select GENERIC_TIME
>>> select GPIO_BCM_KONA
>>> select SPARSE_IRQ
>>> select TICK_ONESHOT
>>> --
>>> 1.8.4.2
>>

Applied to armsoc/for-3.15/soc
Also added signed-off-by for Alexander Shyian and Paul Bolle.

 Thanks,
   csd
