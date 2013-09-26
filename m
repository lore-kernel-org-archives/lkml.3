Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3IZSWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:22:52 -0400
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:45214 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3IZSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:22:51 -0400
Message-ID: <52447B8C.4050501@openwrt.org>
Date: Thu, 26 Sep 2013 20:23:08 +0200
From: Gabor Juhos <juhosg@openwrt.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: fix compiler warning
References: <1380138601-29902-1-git-send-email-juhosg@openwrt.org> <20130926061805.GA18123@samfundet.no>
In-Reply-To: <20130926061805.GA18123@samfundet.no>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013.09.26. 8:18 keltezéssel, Hans-Christian Egtvedt írta:
> Around Wed 25 Sep 2013 21:50:01 +0200 or thereabout, Gabor Juhos wrote:
> 
> Tuning subject to
> 
> avr32: cast syscall_return to silence compiler warning

This is indeed better, thanks.

> 
>> The patch fixes the following compiler warning:
>>     CC      arch/avr32/kernel/process.o
>>   arch/avr32/kernel/process.c: In function 'copy_thread':
>>   arch/avr32/kernel/process.c:292: warning: assignment makes integer \
>>   from pointer without a cast
> 
> Thank you for fixing.
> 
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> 
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> 
>> ---
>> Note: the patch is against v3.12-rc2.
> 
> Added to my for-linus branch.

Thanks you!

-Gabor
