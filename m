Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3DVHYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:24:05 -0400
Received: from mail.neotion.com ([91.121.222.125]:50799 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab3DVHYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:24:04 -0400
Message-ID: <5174E58E.8090307@neotion.com>
Date: Mon, 22 Apr 2013 09:23:58 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] Add boot_enable attribute to eMMC device for boot
 mode operation selection
References: <51713B86.2090001@neotion.com> <CAKYAXd_xa--1QpFCdz3Kj0mKF3cvtxFn-xL3QGWZyXPO4Y79ng@mail.gmail.com>
In-Reply-To: <CAKYAXd_xa--1QpFCdz3Kj0mKF3cvtxFn-xL3QGWZyXPO4Y79ng@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:55 AM, Namjae Jeon wrote:
> 2013/4/19, Neil Armstrong <narmstrong@neotion.com>:
>> Since eMMC 4.3 a special boot mode operation was introduced to retrieve
>> data from the eMMC device with a very simple procedure. Since the Linux
>> kernel exports these device boot partitions, it may be useful to select
>> the boot partition from the user space.
>>
>> The patch has been tested on a Toshiba eMMC conforming with eMMC 4.5
>> specifications.
> Hi Neil.
> We can be enable boot partition using mmc-utils.
> See this address.
> https://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/commit/?id=7bd1320b2cb38f040ab5cf017d17e283496690bf
> 
> So, I don't think this patch is useful.
> If you consider to be disable boot partition, you can try to update
> mmc-utils base on the address I shared.
> 
> Thanks.
>>
>> Neil Armstrong (3):
>>   Add BOOT_PARTITION_ENABLE definition to MMC EXT_CSD PART_CONFIG
>>   Add boot_enable sysfs attribute to select MMC boot operation
>>     partition
>>   Add Documentation for MMC boot_enable attribute
>>
>>  Documentation/mmc/mmc-dev-parts.txt |    6 +++
>>  drivers/mmc/card/block.c            |   72
>> ++++++++++++++++++++++++++++++++++-
>>  include/linux/mmc/mmc.h             |    1 +
>>  3 files changed, 78 insertions(+), 1 deletions(-)
>>
>>
>>
> 

Hi,
Thanks for the reply, I was not aware of the mmc-utils tools. I think
the tool and the MMC_IOC_CMD interface should be documented in the kernel.

Please ignore my patch.

Regards,
Neil
