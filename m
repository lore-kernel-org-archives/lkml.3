Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3HQNB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 09:01:29 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:43530 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3HQNB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 09:01:28 -0400
Message-ID: <520F7424.8030301@gmail.com>
Date: Sat, 17 Aug 2013 15:01:24 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130816204831.GX13964@titan.lakedaemon.net>
In-Reply-To: <20130816204831.GX13964@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 10:48 PM, Jason Cooper wrote:
> On Fri, Aug 16, 2013 at 09:41:38PM +0200, Sebastian Hesselbarth wrote:
>> This adds initial setup for the Marvell Armada 1500 SoCs. The code
>> is fairly straight-forward, but especially _timer_and_clk_init()
>> can be simplified by using default arch hooks. I will have some time
>> until mach-mvebu is prepared for other SoCs moving over, so I can
>> catch up with latest machine simplifications.
>>
>> I am not so sure about the .map_io but I didn't yet fully understand
>> the mapping requirement. Anyway, it is required for iomap and friends
>> to work and basically remaps physical register addressed onto the same
>> virtual addresses.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
[...]
>> +obj-$(CONFIG_MACH_ARMADA_1500)		+= armada-1500.o
>
> guess what?  :)
>
> I swear I had a more substantive comment when I started this.  But after
> a suitable application of gray matter, these nits were all that were
> left. :(

Jason,

thanks for teaching me the alphabet again :) Of course, all your 
comments will be fixed for a real patch set.

I hope Thomas and Gregory will have some time to comment on the
mach-mvebu integration soon which also affects Orion SoCs.

But its weekend, next merge window is far, above just fails to boot
into anything useful due to the lack of drivers - relax :)

Sebastian
