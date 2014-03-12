Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaCLLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:21:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54279 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaCLLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:21:29 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-08-53204337c0ad
Message-id: <53204328.7070607@samsung.com>
Date: Wed, 12 Mar 2014 12:21:12 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Subject: Re: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring
 kernel of Exynos4x12
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xy7rmzgrBBl+Pcllc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWrw62sTjw
	eKyZt4bRo6W5h81j5fIvbB6bl9R79G1ZxejxeZOcx8a5oQHsUVw2Kak5mWWpRfp2CVwZt3+u
	Yio4z1dx89xypgbG59xdjJwcEgImEicP7GaGsMUkLtxbz9bFyMUhJLCUUaL10GxGCOczo0T/
	3+UsIFW8AloSZw41MIHYLAKqErNmzwGLswmoSXxueMQGYosKREj8nbeeEaJeUOLH5HtgNSIC
	9hJ7HmwAG8osMI9JYsrkm6wgCWGBBIkFMxaAnSEk4CJx/ONRoAYODk4BV4kN85JBwswC1hIr
	J21jhLDlJTavecs8gVFgFpIVs5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZG
	SJx83cG49JjVIUYBDkYlHt6ZSvLBQqyJZcWVuYcYJTiYlUR4d9kqBAvxpiRWVqUW5ccXleak
	Fh9iZOLglGpgZNunHLM6f8b7kvzjOS1H3u4KYqjg0ZtebxEomH47XFt+7pTpxec+X50lv7Ov
	qfhcUVsfd6pRyvTWqL7I0qgwuXfiXgophydkzV+wRal9X1fT5KrHEzIap//d++tkS52+y/2G
	Kaq3Jge+d9M4Pv2Z9wc9ofSL78Jv2ZYbzlwmc4L3pLdS4/MnSizFGYmGWsxFxYkAwS2PpnEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 12.03.2014 07:19, Chanwoo Choi wrote:
> This patch add missing dt data of Exynos4x12 to bring up kernel feature and
> code clean. This patchset is based on 'v3.15-next/dt-clk-exynos' branch.
> - git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
>
> exynos4x12/exynos4412/exynos4212.dtsi
> - Add ADC (Analog and Digital Converter) to get raw data
> - Add PMU (Performance Monitoring Unit) for perf event
> - Add gps_alive power domain to remove power leakage when gps-alive isn't used
> - Remove duplicate dt data of interrput combiner controller
>
> exynos4412-trats.dts
> - Add ADC dt data with ntc thermistor child to read temperature
>
> Changes from v1:
> - Use clock macro name for Exynos4 instead of constant for ADC
> - Remove unnecessary description about patch content
> - Move gps-alive power domain's dt data from exynos4x12.dts to exynos4.dts
> - Move thermistor dt node outside of ADC dt node and modify node name of thermistor
>
> Chanwoo Choi (5):
>    ARM: dts: exynos4x12: Add ADC's dt data to read raw data
>    ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce Monitoring Unit)
>    ARM: dts: exynos4x12: Add GPS_ALIVE power domain
>    ARM: dts: exynos: Move common dt data for interrupt combiner controller
>    ARM: dts: exynos4412-trats2: Add ADC/themistor dt data to get temperature of SoC/battery
>
>   arch/arm/boot/dts/exynos4.dtsi          |  5 +++++
>   arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
>   arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
>   arch/arm/boot/dts/exynos4x12.dtsi       | 26 ++++++++++++++++++++++++++
>   5 files changed, 60 insertions(+), 19 deletions(-)
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
