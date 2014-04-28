Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaD1Lu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:50:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15519 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbaD1Lu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:50:26 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ab-535e4080eeb6
Message-id: <535E44B5.7030202@samsung.com>
Date: Mon, 28 Apr 2014 21:08:21 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com, chow.kim@samsung.com,
        yg1004.jang@samsung.com, vikas.sajjan@samsung.com,
        b.zolnierkie@samsung.com, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH v2 3/3] drivers: mfd: Add support for Exynos PMU driver
References: <1396427085-4696-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-1-git-send-email-pankaj.dubey@samsung.com>
 <1398431131-5946-4-git-send-email-pankaj.dubey@samsung.com>
 <20140428112153.GT21279@lee--X1>
In-reply-to: <20140428112153.GT21279@lee--X1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zA90Gh7hgg89LbCw2zljParFs0l02
	i94FV9ks7n89ymix6fE1VovLu+awWcw4v4/J4vZlXovT3awWF1d8YbJYP+M1i8XNZ9uZLHa0
	rGZx4PVoae5h87hzbQ+bx7yTgR6bl9R79G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8aEbUdZ
	CyZzV3x5sZ+lgfEzRxcjJ4eEgInE+ie/2SBsMYkL99YD2VwcQgLLGCXmfrjBDFP05slFJojE
	dEaJs29vsUI4rxkltrXdYgKp4hXQkrh7fRZjFyMHB4uAqsTT654gYTYBXYkn7+eCDRIVCJPY
	NL2PFaJcUOLH5HssIOUiAioS596Yg4xkFnjIJLF95wl2kBphAX+Jt9/3Qu16xiix9e8OdpAG
	TqChzS/sQGqYBcwkHrWsY4aw5SU2r3nLDFIvIdDKIXHsawNYgkVAQOLb5ENgyyQEZCU2HYB6
	TFLi4IobLBMYxWYhOWkWkrGzkIxdwMi8ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkaifs
	YLx3wPoQYzLQyonMUqLJ+cCozyuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRqMHQtzrFxxZ+1t8UnLJ2plh75WcjM5rFAX5vbTsb0vXzvpzjmm7
	ZW2MvtKzDubdZUFc5juP5TuqLei+brZJfevVFVNzns12j7dX4tBz8TsoWbHy1l3B75rSjcvf
	L6yIv245xXjONSGTinl1dnxb3wTU7/0V6/fz38cW5187HsgVtMzr+nPCUImlOCPRUIu5qDgR
	AHhLnKXwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd0Gh7hgg5Pt5hYbZ6xntVg26S6b
	Re+Cq2wW978eZbTY9Pgaq8XlXXPYLGac38dkcfsyr8XpblaLiyu+MFmsn/GaxeLms+1MFjta
	VrM48Hq0NPewedy5tofNY97JQI/NS+o9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hMJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGhG1HWQsmc1d8ebGfpYHxM0cXIyeHhICJxJsnF5kgbDGJC/fW
	s3UxcnEICUxnlDj79hYrhPOaUWJb2y2wKl4BLYm712cxdjFycLAIqEo8ve4JEmYT0JV48n4u
	M4gtKhAmsWl6HytEuaDEj8n3WEDKRQRUJM69MQcZySzwkEli+84T7CA1wgL+Em+/74Xa9YxR
	YuvfHewgDZxAQ5tf2IHUMAuYSTxqWccMYctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzglPBMegfjqgaLQ4wCHIxKPLwRc2KDhVgTy4orcw8xSnAw
	K4nwnreNCxbiTUmsrEotyo8vKs1JLT7EmAwMgInMUqLJ+cB0lVcSb2hsYmZkaWRmYWRibk6a
	sJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjCrnD+UekJkVM3n5uv9/D+koP7n6OlK1ft/P
	nz8tTx3Y1xZ7Rnke+2FJ11DDhcesM7UPP659fnjbzO8Wu9IDXi+fI3y4M7vj8wdzBaeFRs/1
	+U9u99vSYXSwIklogXZkgW3PxSN312Y6/OcXuKPqwXQxoq0/61PWs79Os43FJ/m0WS+azsL+
	01KJpTgj0VCLuag4EQBxc6HMTQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 08:21 PM, Lee Jones wrote:
> On Fri, 25 Apr 2014, Pankaj Dubey wrote:
>
>> This patch moves Exynos PMU driver implementation from
>> "arm/mach-exynos" to "drivers/mfd".
>> This driver is mainly used for setting misc bits of register from PMU IP
>> of Exynos SoC which will be required to configure before Suspend/Resume.
>> Currently all these settings are done in "arch/arm/mach-exynos/pmu.c" but
>> moving ahead for ARM64 based SoC support, there is a need of DT based
>> implementation of PMU driver.
>> This driver uses already existing DT binding information.
>>
>> CC: Sangbeom Kim <sbkim73@samsung.com>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> CC: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/Kconfig  |    2 +
>>   arch/arm/mach-exynos/Makefile |    2 -
>>   arch/arm/mach-exynos/pmu.c    |  521 -----------------------------------------
>>   drivers/mfd/Kconfig           |    9 +
>>   drivers/mfd/Makefile          |    1 +
>>   drivers/mfd/exynos-pmu.c      |  521 +++++++++++++++++++++++++++++++++++++++++
>>   6 files changed, 533 insertions(+), 523 deletions(-)
>>   delete mode 100644 arch/arm/mach-exynos/pmu.c
>>   create mode 100644 drivers/mfd/exynos-pmu.c
> Same with this patch, `git format-patch -M`.

OK, I will resubmit this series.



-- 
Best Regards,
Pankaj Dubey

