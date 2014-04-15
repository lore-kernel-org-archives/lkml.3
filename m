Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaDOGur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:50:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64439 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaDOGup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:50:45 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-bd-534cd6c35aad
Message-id: <534CD6C7.7070606@samsung.com>
Date: Tue, 15 Apr 2014 15:50:47 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkRPfwNZ9gg7ZZyhYbZ6xntZj68Amb
	xesXhhZnm96wW9z/epTR4tuVDiaLy7vmsFmsPXKX3eJ24wo2i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aT6S/ZCq6qVJx+3cTYwNgu28XI
	ySEhYCIxfdN3FghbTOLCvfVsXYxcHEICSxkljt4+xApTNPHUS2aIxHRGiek7P7JDOK8ZJfbc
	nArWziugJfF/xg92EJtFQBVo7H1GEJsNKL7/xQ02EFtUIExi5fQrUPWCEj8m3wOzRQQMJQ7u
	3s4EMpRZ4D2TxNbZM5lAEsICzhIrzn0Fs4UE3CVefLoNtoBTwEPiVvcxZhCbWUBHYn/rNDYI
	W15i85q3YKdKCLxllzi6YwojxEUCEt8mHwLaxgGUkJXYdIAZ4jVJiYMrbrBMYBSbheSmWUjG
	zkIydgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwOg8/e9Z7w7G2wesDzEmA62cyCwl
	mpwPjO68knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amDUuNyQuSu/IC7w5mKdVC72G6XRWw/vPh+240WzY3nTlbk+i0U1tlnESiy34Ynmbe4p2Dlp
	pQiLqVUh49HOV5qvpxX5PE4oefFL2PhIl5/NNuWQj6lZNYm7luUpBarxu3a676oMmyOYYKvT
	0Xp6203p+05nMpLZi2P6hCyN5s0+1hkisFSbVYmlOCPRUIu5qDgRAEd3O2DkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd3D13yCDd5elLTYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Ba3G1ewWZzuZnXg8tg56y67x6ZVnWwe
	d67tYfOYdzLQo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBmPJn+kq3gqkrF6ddNjA2M7bJdjJwcEgImEhNPvWSGsMUkLtxbz9bFyMUhJDCdUWL6zo/s
	EM5rRok9N6eygFTxCmhJ/J/xgx3EZhFQlZi+6T4jiM0GFN//4gYbiC0qECaxcvoVqHpBiR+T
	74HZIgKGEgd3b2cCGcos8J5JYuvsmUwgCWEBZ4kV576C2UIC7hIvPt0GW8Ap4CFxq/sY2HnM
	AjoS+1unsUHY8hKb17xlnsAoMAvJjllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIzj2n0nvYFzVYHGIUYCDUYmHd8I772Ah1sSy4srcQ4wSHMxKIryvk32ChXhTEiurUovy
	44tKc1KLDzEmA4NgIrOUaHI+MC3llcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1
	tSC1CGYLEwenVANj5vWCF+VCRd6Lj4XV71Cdcmr1kSnWoQ+WFIh+alJX3Rd6f5VQyJ2q00FX
	4lWa5csCZ8zYxbT7pW2QscecjW57GkJKlu6Uyv7BZ8wRWpzCayrk1WjSffrg7ytW+S/KFkjl
	tbV1G4pwf9iWfHWbZKKGdujOSydnHHjAyeJz741QkWi2Qeikb1+VWIozEg21mIuKEwENtD8v
	QQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I tested this patchset about mfd/extcon/regulator on 3.15-rc1.

How about applying this patchset on some git repository?
I need the opinion of mfd/regulator maintainers
because this patchset include mfd/extcon/regulator patches.

But, following new patches hasn't acked. The two patches must need ack message.
[PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
[PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines

Best Regards,
Chanwoo Choi

On 04/14/2014 06:17 PM, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> This is first part of fifth version of patchset adding support for
> MAX77836 device to the max14577 driver.
> 
> I decided to split the patchset into smaller parts. I hope this would
> help in getting necessary review/acks from maintainers.
> 
> The first part introduces changes in max14577 driver and adds support
> for MAX77836 in MFD, extcon and regulator drivers. Most of these
> patches already have required acks from maintainers.
> Full v4 patchset can be found here:
> http://thread.gmane.org/gmane.linux.kernel/1654267
> 
> 
> Changes since v4
> ================
> 1. Updated Kconfig entries mentioning MAX77836.
> 2. Removed rename-like patches:
>    [PATCH v4 02/16] mfd: max14577: Rename and add MAX14577 symbols
>    [PATCH v4 03/16] mfd: max14577: Rename state container to maxim_core
> 3. Added new patches (not yet reviewed):
>    [PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
>    [PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines
> 4. Rebased on 3.15-rc1.
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
> 
> Best regards,
> Krzysztof Kozlowski
> 
> 
> Chanwoo Choi (1):
>   extcon: max14577: Change extcon name instead of static name according
>     to device type
> 
> Krzysztof Kozlowski (8):
>   mfd: max14577: Add muic prefix to regmap config
>   mfd: max14577: Add detection of device type
>   extcon: max14577: Add max14577 prefix to muic_irqs
>   extcon: max14577: Choose muic_irqs according to device type
>   mfd: max14577: Add MAX14577 prefix to IRQ defines
>   mfd: max77836: Add MAX77836 support to max14577 driver
>   extcon: max14577: Add support for MAX77836
>   regulator: max14577: Add support for MAX77836 regulators
> 
>  drivers/extcon/Kconfig               |   4 +-
>  drivers/extcon/extcon-max14577.c     | 174 +++++++++++++------
>  drivers/mfd/Kconfig                  |   6 +-
>  drivers/mfd/max14577.c               | 315 ++++++++++++++++++++++++++++++-----
>  drivers/regulator/Kconfig            |   7 +-
>  drivers/regulator/max14577.c         | 277 ++++++++++++++++++++++++++----
>  include/linux/mfd/max14577-private.h | 222 ++++++++++++++++++------
>  include/linux/mfd/max14577.h         |  19 ++-
>  8 files changed, 836 insertions(+), 188 deletions(-)
> 

