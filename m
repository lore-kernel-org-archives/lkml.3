Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3HPWdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:33:47 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55907 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3HPWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:33:45 -0400
Message-ID: <520E8384.2010209@gmail.com>
Date: Fri, 16 Aug 2013 21:54:44 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 4/5] ARM: mvebu: add Armada 1500 and Sony NSZ-GS7 device
 tree files
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130816195046.GU13964@titan.lakedaemon.net>
In-Reply-To: <20130816195046.GU13964@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 09:50 PM, Jason Cooper wrote:
> On Fri, Aug 16, 2013 at 09:41:37PM +0200, Sebastian Hesselbarth wrote:
>> This adds very basic device tree files for the Marvell Armada 1500 SoC
>> and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has nodes for
>> cpus, some clocks, l2 cache controller, local timer, apb timers, uart,
>> and interrupt controllers.
[...]
>> ---
>>   arch/arm/boot/dts/Makefile                     |    3 +-
>>   arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts |   29 +++
>>   arch/arm/boot/dts/armada-1500.dtsi             |  225 ++++++++++++++++++++++++
>>   3 files changed, 256 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
>>   create mode 100644 arch/arm/boot/dts/armada-1500.dtsi
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 641b3c9..3186904 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -103,7 +103,8 @@ dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>>   	armada-370-rd.dtb \
>>   	armada-xp-db.dtb \
>>   	armada-xp-gp.dtb \
>> -	armada-xp-openblocks-ax3-4.dtb
>> +	armada-xp-openblocks-ax3-4.dtb \
>> +	armada-1500-sony-nsz-gs7.dtb
>
> alphabetical.

Dammit, true! ;)

> And now I need to pick up a googleTV...

Jep, go shopping :)

Unfortunately, I (again) put too many people in Cc and all 5 patches
are stuck waiting for moderator approval. With 5 DT maintainers it isn't
easy to get those though to MLs.

Sebastian

