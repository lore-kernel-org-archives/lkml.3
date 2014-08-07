Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbaHGIYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:24:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39567 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaHGIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:24:41 -0400
X-AuditID: cbfee690-b7f526d000003627-46-53e337c60829
Message-id: <53E337C5.3020802@samsung.com>
Date: Thu, 07 Aug 2014 17:24:37 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Seungwon Jeon <tgih.jun@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCH v3 0/4] Add eMMC and SD card support for rk3288-evb
References: <1407344984-14176-1-git-send-email-dianders@chromium.org>
In-reply-to: <1407344984-14176-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWyRsSkRPeY+eNgg5U90hbL/n9nsvg76Ri7
	xYTL2xkt5h85x2pxdtlBNov+NwtZLf4/es1qce7VSkaLbdN/sllsenyN1eLyrjlsFkf+9zNa
	3L7Ma7H0+kUmiwnT17JYtO49wm7x5MxMRosP9y8yWxxfG+4g7LFm3hpGj5bmHjaP378mMXrM
	brjI4nG5r5fJY+XyL2wem1Z1snncubaHzWPzknqPG68WMnn8nbWfxaNvyypGj+3X5jF7fN4k
	F8AXxWWTkpqTWZZapG+XwJXR+CajoJ2vonHTAcYGxv9cXYycHBICJhKTt31jhrDFJC7cW8/W
	xcjFISSwlFHi57Jb7DBFixc+h0pMZ5R4/vIvK4TzmlFi6/MusCpeAS2JN2e2soLYLAKqEgsP
	XmYBsdkEdCS2fzvOBGKLCoRJHGqbxwRRLyjxY/I9FpBBIgK7GCWuHpnCDuIwC8xjlvi2rA/o
	KA4OYQF3iQkbwkEahARcJb7tXgF2K6eAm8SUF0/ABjEDLdjfOo0NwpaX2LzmLTPIHAmBNxwS
	R5c/gbpIQOLb5EMsIDMlBGQlNh2A+llS4uCKGywTGMVmIblpFpKxs5CMXcDIvIpRNLUguaA4
	Kb3IRK84Mbe4NC9dLzk/dxMjMImc/vdswg7GewesDzEmA62cyCwlmpwPTEJ5JfGGxmZGFqYm
	psZG5pZmpAkrifOqPUoKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIoHe+5YnJxo4rk/r/
	fps4vdftU9Tuq9zbfu15xjln+TvJvvdXugNljA/LVD6ImPN/+zIz3xiFAAPtYNbEN5HrM1M2
	y6z8WP/+9YZsIX7RKRHq1xRUzLx37c6dtHKdZu6GFysi7nY45v/jfC4wOzrmn0OTxly/EiFH
	lsJE/aNbnOIKfi76K/BGiaU4I9FQi7moOBEAQzKnjzgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQd1j5o+DDb42CVks+/+dyeLvpGPs
	FhMub2e0mH/kHKvF2WUH2Sz63yxktfj/6DWrxblXKxkttk3/yWax6fE1VovLu+awWRz5389o
	cfsyr8XS6xeZLCZMX8ti0br3CLvFkzMzGS0+3L/IbHF8bbiDsMeaeWsYPVqae9g8fv+axOgx
	u+Eii8flvl4mj5XLv7B5bFrVyeZx59oeNo/NS+o9brxayOTxd9Z+Fo++LasYPbZfm8fs8XmT
	XABfVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	t0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjMY3GQXtfBWNmw4wNjD+
	5+pi5OSQEDCRWLzwORuELSZx4d56IJuLQ0hgOqPE85d/WSGc14wSW593sYNU8QpoSbw5s5UV
	xGYRUJVYePAyC4jNJqAjsf3bcSYQW1QgTOJQ2zwmiHpBiR+T77GADBIR2MUocfXIFHYQh1lg
	HrPEt2V9zF2MHBzCAu4SEzaEgzQICbhKfNu9ghnE5hRwk5jy4gnYIGagBftbp7FB2PISm9e8
	ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4RT2T2sG4ssHi
	EKMAB6MSD69F06NgIdbEsuLK3EOMEhzMSiK8r/geBwvxpiRWVqUW5ccXleakFh9iNAUGwURm
	KdHkfGD6zCuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwKgkHyJk
	oHFgspRZcJDqtXv7NxfbBqYf3ZdoUdn8T9FRz3A9y36N+q3hNhVOf9q+7n29nedg9qnzJfN/
	bHq48kv/lrjND39MLdIO9n0lw7OgsKi72/HQlbpTst5f/2btN8lYaOJ5ss7DZqFtE9/0eyrB
	CZufSTXVtU3877RuVkrx8lMXKp9UsCixFGckGmoxFxUnAgBBE3lqZwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Doug.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 08/07/2014 02:09 AM, Doug Anderson wrote:
> This series adds basic eMMC and SD card support for the rk3288-evb
> board based on Addy's posted dw_mmc patch from:
>   https://patchwork.kernel.org/patch/4653631/
> 
> The series is a little tricky because:
> * Jaehoon has some outstanding patches to remove the slot node.  Since
>   those haven't landed yet, I've posted my original patch with the
>   slot node and then some future patches that can land with Jaehoon's
>   patches.
> 
> So just to be explicit:
> - Patch #1 and #2 can land after Addy's patch lands.
> - Patch #3 and #4 can land after Jaehoon's patch lands, though there's
>   no huge hurry since Jaehoon's patch supports the old mode (it just
>   prints a warning).
> 
> Note that we don't have regulators specified yet (no regulator driver
> for rk808-based board).  We also don't yet support UHS modes or MMC
> DDR50 (which require regulator support plus dw_mmc driver support for
> tuning).  Those features can come later.
> 
> Changes in v3:
> - Removed DDR50 mode since it needs tuning, which isn't there yet.
> 
> Changes in v2:
> - New patchwork link for Addy's patch
> - Squashed in the DDR50 mode since Addy spun his patch.
> - Refer to the new title of Jaehoon's patch
> 
> Doug Anderson (4):
>   ARM: dts: Add emmc and sdmmc to the rk3288 device tree
>   ARM: dts: Enable emmc and sdmmc on the rk3288-evb boards
>   ARM: dts: Take the mmc slot node out of rk3288-evb
>   ARM: dts: mmc slot node gone on rk3288 => no more address / size cells
> 
>  arch/arm/boot/dts/rk3288-evb.dtsi | 24 ++++++++++++++++++++++++
>  arch/arm/boot/dts/rk3288.dtsi     | 18 ++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 

