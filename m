Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934656AbaDJE27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:28:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32961 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaDJE25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 00:28:57 -0400
X-AuditID: cbfee68f-b7f156d00000276c-bd-53461e0852e6
Message-id: <53461E09.7090408@samsung.com>
Date: Thu, 10 Apr 2014 13:28:57 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 00/16] mfd: max14577: Add support for MAX77836
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkQJdDzi3Y4OtyAYuNM9azWkx9+ITN
	YtKT98wWE1dOZrZ4/cLQ4mzTG3aL+1+PMlpsenyN1eLyrjlsFmuP3GW3ON3NarF+xmsWBx6P
	nbPusntsXqHlsWlVJ5vHnWt72DzmnQz02Lyk3qNvyypGj8+b5AI4orhsUlJzMstSi/TtErgy
	Tu/qZi14p1nROu8TawPjDYUuRk4OCQETidatD5kgbDGJC/fWs3UxcnEICSxllHi6eR4LTNGf
	Tw2sEIlFjBLf7r1lgnBeM0o03uwBcjg4eAW0JH6trANpYBFQlZg66T7YVDag8P4XN9hAbFGB
	MImV06+ADeUVEJT4MfkemC0iYChxcPd2sJnMAkeYJa4dmscOkhAWcJWY1H0WbJCQgLvEt3nX
	wRo4BTwk7rY8YAWxmQV0JPa3TmODsOUlNq95ywxxdSeHxLe1ZRAHCUh8m3yIBeROCQFZiU0H
	oEokJQ6uuMEygVFsFpKTZiGZOgvJ1AWMzKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAqP3
	9L9n/TsY7x6wPsSYDLRyIrOUaHI+MPrzSuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjISmj7ZnnrK6Ihjjt27DEiE+eLeWrj8uj7qe37swSZTfa
	Uv9GX3aXQQzHha9p/7u8+p5UfpmiIafx73e99AKbnT9Vd3DdmRvW4uKx7fukFZ9EqpMFVeR5
	Ih872TOqzXqcWDdFQjtDiI3DMC5sqYBSo2wna8XSiIjYj3PYdFnijTNFJX/Gv1NiKc5INNRi
	LipOBADxaokw9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV0OObdgg6Vf2Sw2zljPajH14RM2
	i0lP3jNbTFw5mdni9QtDi7NNb9gt7n89ymix6fE1VovLu+awWaw9cpfd4nQ3q8X6Ga9ZHHg8
	ds66y+6xeYWWx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgvgiGpgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlVJoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjDmHF6VzdrwTvNitZ5n1gbGG8odDFyckgImEj8+dTACmGL
	SVy4t56ti5GLQ0hgEaPEt3tvmSCc14wSjTd7gBwODl4BLYlfK+tAGlgEVCWmTrrPBGKzAYX3
	v7jBBmKLCoRJrJx+hQXE5hUQlPgx+R6YLSJgKHFw93awmcwCR5glrh2axw6SEBZwlZjUfRZs
	kJCAu8S3edfBGjgFPCTutjwAu45ZQEdif+s0NghbXmLzmrfMExgFZiHZMQtJ2SwkZQsYmVcx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeHZ9I7GFc1WBxiFOBgVOLhPbDMNViINbGsuDL3
	EKMEB7OSCK+CkFuwEG9KYmVValF+fFFpTmrxIcZkYBBMZJYSTc4HJq68knhDYxMzI0sjc0ML
	I2Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCcZ68yX/HH6lObnUx2p8b2L3ed8CUx
	QCf4odLKi44hirq/j7yx29KodHiC5/H7H3RSzp4/ozn5RL/114Vtrz2PMZ2PbE08eMZkbs+h
	B2857+Vt6eDUFHg65+XbX3obfO45yc9M2mP1c7O49jmn+Q71Pq5hHcrx1+K8NUMyd6wW+JOs
	wlfW8jZLiaU4I9FQi7moOBEAcY2qAFIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Did you finish this patchset for applying git repository?
I can't find this patchset on mainline kernel.

If this patchset isn't applied on mainline, I'd like you to finish this patch
because I want to maintain up to date patch for max77836/max14577 on mainline.

Thanks,
Chanwoo Choi

On 02/24/2014 07:10 PM, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> This is fourth version of patchset adding support for MAX77836 device
> to the max14577 driver.
> 
> Lee Jones suggested that after obtaining acks from all maintainers he can
> merged these patches to his tree. These patches touch different subsystems
> (charger/power, regulator, extcon and mfd) so this would be probably the best
> way to merge everything. I would be glad if I could get missing acks
> (or comments).
> 
> 
> Changes since v3
> ================
> 1. Applied minor fixes (pointed by Lee Jones).
> 2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
> 3. Patch 14/charger: Minor change in parsing EOC value from DTS.
> 4. Rebased on next-20140224.
> 
> Changes since v2
> ================
> 1. Added ACK-s.
> 2. Applied minor checkpatch fixes (pointed by Lee Jones).
> 3. Rebased on next-20140217.
> 
> Changes since v1
> ================
> 1. Added ACK-s, reviews and tested-by tags.
> 2. Removed applied patches (they were merged to the linux-next tree).
> 3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
>    and 8/15 (add max77836 support to max14577).
> 4. Rebased on next tree.
> 5. Added patch 13 and 14 (pointed by Jenny Tc):
>    - regulator/mfd: max14577: Export symbols for calculating charger current
>    - charger: max14577: Configure battery-dependent settings from DTS
> 6. Updated bindings documentation with new charger bindings.
> Previous thread:
>  - [PATCH 00/18] mfd: max14577: Add support for MAX77836
>    http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674
> 
> 
> Description
> ===========
> The MAX77836 is almost the same as MAX14577. Basically it is an extended
> version of MAX14577. The chipsets have same MUIC component so the extcon,
> charger and regulators require only little adjustments. More changes were
> needed in the charger (because it uses lower charging current) and regulator
> drivers (because mentioned different charing current and additional
> regulators). The MAX77836 has also PMIC and Fuel Gauge (which is the same
> as MAX17040/17048 Fuel Gauge).
> 
> The MAX77836 uses three I2C slave addresses and has additional interrupts
> (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> just like MAX77686 and MAX77693.
> 
> The patchset is organized in following way:
> 1. Patches from 1 to 7 prepare the driver for supporting MAX77836. They
>    mostly rename symbols and add additional logic related to different
>    device types.
> 2. Patches from 8 to 12 add support for MAX77836.
> 3. Patches 13 and 14 remove hard-coded charger configuration with DTS. They
>    were added after review on mailing lists.
> 4. Patch 15 adds bindings documentation, which was not merged previously.
> 5. Patch 16 adds SUSPEND mode to the regulator driver.
> 
> 
> The patchset is based on linux-next tree and depends on patches from previous
> release which are already merged into next.
> Testing was done on 3.10.
> 
> 
> TODO: Merge max14577, max77686 and max77693 into one common driver. They are
> very similar.
> 
> 
> Best regards,
> Krzysztof Kozlowski
> 
> 
> Chanwoo Choi (1):
>   extcon: max14577: Change extcon name instead of static name according
>     to device type
> 
> Krzysztof Kozlowski (15):
>   mfd: max14577: Rename and add MAX14577 symbols to prepare for
>     max77836
>   mfd: max14577: Rename state container to maxim_core
>   mfd: max14577: Add "muic" suffix to regmap and irq_chip
>   mfd: max14577: Add detection of device type
>   extcon: max14577: Add max14577 prefix to muic_irqs
>   extcon: max14577: Choose muic_irqs according to device type
>   mfd: max77836: Add max77836 support to max14577 driver
>   extcon: max14577: Add support for max77836
>   regulator: max14577: Add support for max77836 regulators
>   charger: max14577: Add support for MAX77836 charger
>   power: max17040: Add ID for max77836 Fuel Gauge block
>   regulator/mfd: max14577: Export symbols for calculating charger
>     current
>   charger: max14577: Configure battery-dependent settings from DTS
>   mfd: max14577: Add device tree bindings document
>   regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> 
>  Documentation/devicetree/bindings/mfd/max14577.txt |  149 +++++
>  drivers/extcon/extcon-max14577.c                   |  274 +++++----
>  drivers/mfd/max14577.c                             |  475 +++++++++++++---
>  drivers/power/max14577_charger.c                   |  361 +++++++++---
>  drivers/power/max17040_battery.c                   |    1 +
>  drivers/regulator/max14577.c                       |  334 ++++++++---
>  include/linux/mfd/max14577-private.h               |  586 ++++++++++++--------
>  include/linux/mfd/max14577.h                       |   50 +-
>  8 files changed, 1697 insertions(+), 533 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> 

