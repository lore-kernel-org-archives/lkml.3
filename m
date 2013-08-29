Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3H2BKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:10:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38347 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3H2BKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:10:11 -0400
Message-ID: <521E9F42.6090604@atmel.com>
Date: Thu, 29 Aug 2013 09:09:22 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        <arm@kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc update for 3.12 #1
References: <1377532543-349-1-git-send-email-nicolas.ferre@atmel.com> <20130828235855.GM8607@quad.lixom.net>
In-Reply-To: <20130828235855.GM8607@quad.lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 08/29/2013 07:58 AM, Olof Johansson wrote:
> On Mon, Aug 26, 2013 at 05:55:43PM +0200, Nicolas Ferre wrote:
>> Arnd, Olof, Kevin,
>>
>> Here is AT91 SoC updates for 3.12 kernel. It is the first pull-request for
>> this topic and it is based on 3.11-rc5 like your next/soc branch.
>>
>> Thanks, best regards,
>>
>> The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:
>>
>>    Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)
>>
>> are available in the git repository at:
>>
>>    git://github.com/at91linux/linux-at91.git tags/at91-soc
>>
>> for you to fetch changes up to 99eb3b40ec42e7fce1fc58429bf9b26c17973c12:
>>
>>    ARM: at91: at91_dt_defconfig: enable rm9200 support (2013-08-26 09:58:29 +0200)
>>
>> ----------------------------------------------------------------
>> AT91 SoC update for 3.12 take 1
>> - enable kernel uncompress information output for
>>    SoC where it was missing: at91sam9n12 and sama5d3
>> - addition of at91rm9200 to the generic at91_dt_defconfig
>>
>> ----------------------------------------------------------------
>> Jean-Christophe PLAGNIOL-VILLARD (1):
>>        ARM: at91: at91_dt_defconfig: enable rm9200 support
>>
>> voice (4):
>>        ARM: at91: sama5d3: add definition for usart base address
>>        ARM: at91: include sama5d3.h into hardware.h
>>        ARM: at91: sama5: enable kernel uncompress info output
>>        ARM: at91: sam9n12: enable kernel uncompress info output
>
> That doesn't look right. Author should probably be "Bo Shen
> <voice.shen@atmel.com>" instead. Can you fixup and respin, please?

I don't know why on the patchwork it show my name as voice.
So, if get patch from patchwork and apply it will show my name as voice.
So, would it be possible to show the name as Bo Shen on patchwork?

>
> -Olof
>

Best Regards,
Bo Shen

