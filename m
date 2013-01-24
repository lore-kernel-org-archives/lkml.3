Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3AXIqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 03:46:39 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:17243 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3AXIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 03:46:32 -0500
Message-ID: <5100F4ED.9000004@atmel.com>
Date: Thu, 24 Jan 2013 09:46:37 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <richard.genoud@gmail.com>, <linux-arm@overkiz.com>,
        <manabian@gmail.com>, <dgilbert@interlog.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH 7/9] ARM: at91/at91_dt_defconfig: remove memory specification
 to cmdline
References: <cover.1358934163.git.nicolas.ferre@atmel.com> <2e06e92c758b768baaacc061aafa7f710b74ea02.1358934163.git.nicolas.ferre@atmel.com> <20130123102057.GJ7360@game.jcrosoft.org>
In-Reply-To: <20130123102057.GJ7360@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 11:20 AM, Jean-Christophe PLAGNIOL-VILLARD :
> On 10:48 Wed 23 Jan     , Nicolas Ferre wrote:
>> No need for this cmdline option as we are using DT.
>> Moreover this defconfig is targeted to multiple SoC/boards: this option
>> was nonsense.
> just keep the console the rest is a nonsense too
> 
> as on 9g45 the initrd will be at 0x7xxxxxxx

Understood, but I prefer to keep a "root" option at least, so I keep it
like this.

> the console too but as the patch serie to support via DT is not yet mainline
> we can keep it

Ok for this.

> 
> Best Regards,
> J.
>>
>> Reported-by: Josh Wu <josh.wu@atmel.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  arch/arm/configs/at91_dt_defconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
>> index b175577..a353ff6 100644
>> --- a/arch/arm/configs/at91_dt_defconfig
>> +++ b/arch/arm/configs/at91_dt_defconfig
>> @@ -31,7 +31,7 @@ CONFIG_ZBOOT_ROM_TEXT=0x0
>>  CONFIG_ZBOOT_ROM_BSS=0x0
>>  CONFIG_ARM_APPENDED_DTB=y
>>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>> -CONFIG_CMDLINE="mem=128M console=ttyS0,115200 initrd=0x21100000,25165824 root=/dev/ram0 rw"
>> +CONFIG_CMDLINE="console=ttyS0,115200 initrd=0x21100000,25165824 root=/dev/ram0 rw"
>>  CONFIG_KEXEC=y
>>  CONFIG_AUTO_ZRELADDR=y
>>  # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
>> -- 
>> 1.8.0
>>
> 
> 


-- 
Nicolas Ferre
