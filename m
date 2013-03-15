Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3COKQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:16:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:33391 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3COKQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:16:22 -0400
Message-ID: <5142F4F1.60006@atmel.com>
Date: Fri, 15 Mar 2013 11:16:17 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Johan Hovold <jhovold@gmail.com>, Olof Johansson <olof@lixom.net>,
        <FlorianSchandinat@gmx.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jacmet@sunsite.dk>
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is removal
References: <cover.1360340791.git.nicolas.ferre@atmel.com> <5139B169.7050807@atmel.com> <51405126.3090009@atmel.com> <201303142303.42283.arnd@arndb.de>
In-Reply-To: <201303142303.42283.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 12:03 AM, Arnd Bergmann :
> On Wednesday 13 March 2013, Nicolas Ferre wrote:
>> In case we end-up with an agreement on the path those fixes should
>> follow, here is the location of my updated material rebased on top of 3.9-rc2:
>>
>> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
>>
>>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git at91-3.9-fixesLCD
>>
>> for you to fetch changes up to bbd44f6bd9d1aa735b180b29b5719d63a8e87b55:
>>
>>   ARM: at91/avr32/atmel_lcdfb: add platform device-id table (2013-03-13 11:05:12 +0100)
>>
>> ----------------------------------------------------------------
>> Johan Hovold (5):
>>       atmel_lcdfb: fix 16-bpp modes on older SOCs
>>       ARM: at91: fix LCD-wiring mode
>>       ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
>>       atmel_lcdfb: move lcdcon2 register access to compute_hozval
>>       ARM: at91/avr32/atmel_lcdfb: add platform device-id table
>>
> 
> I have merged the first two patches into the fixes branch now, from up to commit
> 67cf9c0a. Please resubmit the remaining ones on top of this commit for 3.10, either
> through arm-soc or through the framebuffer tree.

Thanks a lot.
I have just sent the pull-request for remaining material. Tell me if it
is what you've expected.

Best regards,
-- 
Nicolas Ferre
