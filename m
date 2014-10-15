Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaJOCWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:22:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17070 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaJOCWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:22:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-f79296d000004278-6f-543dda4ea4a2
Content-transfer-encoding: 8BIT
Message-id: <543DDA4D.2060103@samsung.com>
Date: Wed, 15 Oct 2014 11:22:05 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Anton Vorontsov <anton@enomsg.org>,
        Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@ucw.cz>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/8] power_supply: Add API for safe access of
 get_property-like function attrs
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkUNfvlm2IQctWIYuDWzUtNs5Yz2ox
	6cl7ZouJKyczW7x+YWhxtukNu8X9r0cZLab8Wc5ksenxNVaLy7vmsFl87j3CaPFk4Rkmi7VH
	7rJb3G5cwWZx99RRNovT3awWp3eXOAh6TOj/xOixc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4Ee
	m5fUe+z83sDu0bdlFaPHitXf2T0+b5IL4I7isklJzcksSy3St0vgytjxfjpTwUrhiqnzFrA2
	MPbxdzFyckgImEh8n7eZDcIWk7hwbz2QzcUhJLCUUWLn9mssMEXrln+FSixilDj/aS4zSIJX
	QFDix+R7QEUcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mlHi5/VGFoh6LYl3lx6AbWMRUJX42tcJ
	ZrMJyEm8bfrGCGKLCoRJXJ1wHKxeRMBQ4uDu7Uwgg5gF/rJILDm9CSwhLJAi8bblGNgRQgLu
	Eu0nb4MN4hTwkFi56AjU1Qc4JG41xUMsE5D4NvkQ2KESArISmw4wQ5RIShxccYNlAqPYLCTv
	zEJ4ZxaSdxYwMq9iFE0tSC4oTkovMtQrTswtLs1L10vOz93ECEwDp/89693BePuA9SFGAQ5G
	JR5ejgO2IUKsiWXFlbmHGE2BjpjILCWanA9MNnkl8YbGZkYWpiamxkbmlmZK4ryKUj+DhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTCe0nrgsvjau683b+66djcgu3fbor8b8jf4bIm8oX4o
	SEKvkffTlJvHBQr3uwS5z2W6mWa8vX7bvM/X62b/8my7F9LzsHTPrRg2RbaZGv9cbS7YbHzF
	Y/lk9ZE/Z842TBBgqola+5zbZ5Zr+cpEpVVKemqbGmd87P7GnvvdRnvXNhPGjElvcv5+VmIp
	zkg01GIuKk4EAFP0IAD+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV2/W7YhBrP+cFgc3KppsXHGelaL
	SU/eM1tMXDmZ2eL1C0OLs01v2C3ufz3KaDHlz3Imi02Pr7FaXN41h83ic+8RRosnC88wWaw9
	cpfd4nbjCjaLu6eOslmc7ma1OL27xEHQY0L/J0aPnbPusntsXqHlsWlVJ5vHnWt72DzmnQz0
	2Lyk3mPn9wZ2j74tqxg9Vqz+zu7xeZNcAHdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZ
	gaGuoaWFuZJCXmJuqq2Si0+ArltmDtBDSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4Lg
	eowM0EDCGsaMHe+nMxWsFK6YOm8BawNjH38XIyeHhICJxLrlX9kgbDGJC/fWA9lcHEICixgl
	zn+aywyS4BUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/ZpT4eb2RBaJeS+LdpQdg
	Q1kEVCW+9nWC2WwCchJvm74xgtiiAmESVyccB6sXETCUOLh7OxPIIGaBvywSS05vAksIC6RI
	vG05BnaEkIC7RPvJ22CDOAU8JFYuOsIygVFgFpL7ZiHcNwvJfQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBKeZZ9I7GFc1WBxiFOBgVOLh5ThgGyLEmlhWXJl7iFGCg1lJhDftKFCI
	NyWxsiq1KD++qDQntfgQoynQdxOZpUST84EpMK8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6
	YklqdmpqQWoRTB8TB6dUA6OBELOiFvvGTJkHQp8+2uzR+TPv+L/FTr+TrqzOvsv0/VVJzhT3
	xdyugqISwVOnBXtP5Hu37vo7WYd/jqcOXrj/rHDaN99a690OgsqHpzMurwzYwPaAKWRz9KUn
	R7zXnLVxfcUjLWVp2BywbUKUWv4K+cKtm9OvW11TW3wuLHdCX9+8cwcVZ01SYinOSDTUYi4q
	TgQAgY5PO0kDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2014년 10월 14일 21:20, Krzysztof Kozlowski wrote:

> Hi,
> 
> 
> After fixing issue with referencing old power supply after driver
> unbind in charger manager [1] I noticed that the race condition in such
> case may still exist. It would be harder to trigger but still possible.
> 
> The race is between using a reference to power supply (obtained
> with power_supply_get_by_name()) and removing the driver.
> 
> This patchset aims to fix the race by introducing wrappers for
> accessing the power supply function attributes.
> 
> Patch 1 introduces new API. Other patches replace direct calls in
> drivers.
> 
> Rebased on next-20141007.
> Tested on Trats2 board (max77693 + charger manager).
> 
> 
> Kindly asking for reviewing/testing the drivers, although the changes
> are straightforward.
> 


Looks good to me, but need someone to comment on this.

Acked-by : Jonghwa Lee <jonghwa3.lee@samusng.com>

Thanks,
Jonghwa

> 
> Best regards,
> Krzysztof
> 
> 
> [1] https://lkml.org/lkml/2014/10/13/272
> 
> 
> 
> Krzysztof Kozlowski (8):
>   power_supply: Add API for safe access of power supply function attrs
>   power_supply: sysfs: Use power_supply_*() API for accessing function
>     attrs
>   power: 88pm860x_charger: Use power_supply_*() API for accessing
>     function attrs
>   power: ab8500: Use power_supply_*() API for accessing function attrs
>   mfd: ab8500: Use power_supply_*() API for accessing function attrs
>   power: apm_power: Use power_supply_*() API for accessing function
>     attrs
>   power: bq2415x_charger: Use power_supply_*() API for accessing
>     function attrs
>   power: charger-manager: Use power_supply_*() API for accessing
>     function attrs
> 
>  drivers/mfd/ab8500-sysctrl.c       |  7 +++--
>  drivers/power/88pm860x_charger.c   | 13 +++++----
>  drivers/power/ab8500_btemp.c       |  2 +-
>  drivers/power/ab8500_charger.c     |  2 +-
>  drivers/power/ab8500_fg.c          |  2 +-
>  drivers/power/abx500_chargalg.c    |  4 +--
>  drivers/power/apm_power.c          |  4 +--
>  drivers/power/bq2415x_charger.c    |  3 +-
>  drivers/power/charger-manager.c    | 37 +++++++++++++------------
>  drivers/power/power_supply_core.c  | 57 ++++++++++++++++++++++++++++++++++++--
>  drivers/power/power_supply_sysfs.c |  6 ++--
>  include/linux/power_supply.h       | 16 +++++++++++
>  12 files changed, 115 insertions(+), 38 deletions(-)
> 


