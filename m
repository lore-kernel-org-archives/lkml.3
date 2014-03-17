Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaCQBor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:44:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57345 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaCQBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:44:44 -0400
X-AuditID: cbfee690-b7f266d00000287c-8a-5326538bd0c3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
 <53204328.7070607@samsung.com> <53211071.4040408@samsung.com>
 <532651E5.6040903@samsung.com>
In-reply-to: <532651E5.6040903@samsung.com>
Subject: RE: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring
 kernel of Exynos4x12
Date: Mon, 17 Mar 2014 10:44:36 +0900
Message-id: <006201cf4182$77b665f0$672331d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBnLjoYSL6/JtAE0ldF9u/TwtVzQEJ65JNAiCNaK8DPY6U0JpMiodQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+ZoW53sFqwwYVd3BbXvzxntZh/5Byr
	xblXKxktzja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ti8epgG4vF+hmvWRx4
	PNbMW8Po0dLcw+axcvkXNo/NS+o9+rasYvT4vEnOY+Pc0AD2KC6blNSczLLUIn27BK6MdQuW
	MRV0Clf8mWzdwPiTr4uRk0NCwERi79QzrBC2mMSFe+vZuhi5OIQEljFKdN+dyApT9GlSMyNE
	YhGjRM+7Z+wQzl9GiUc7FjOBVLEJaEgcfg+S4OQQEfCTWHtvEQtIEbPAAiaJf0uaWSE6ljJK
	zPv2hgWkilNAW+L5s6dgHcICCRKz5l9nBLFZBFQl+t63sIHYvAKWEi+3N7BC2IISPybfA+tl
	FtCS2LytiRXClpfYvOYtM8StChI7zr5mhLjCTWJ64w0miBoRiX0v3oH9ICEwl0NiY1MbM8Qy
	AYlvkw8BDeUASshKbDoANUdS4uCKGywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQi
	E73ixNzi0rx0veT83E2MkBQwYQfjvQPWhxiTgdZPZJYSTc4HppC8knhDYzMjC1MTU2Mjc0sz
	0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBUrN6scu5GfzB7336Os9rllWoB
	kQKVK2ZkdnGKNVU1/z32Iu6ywaFV2ulLp0xhWd1yfO627V85G8pFlrGqrVr11p1ZXW1KwN/w
	JTcPrd0idvCEm9eluK9+Nyozu5rmqB6czPGoqmHi6XuOk6+kzlD8Vsy4sKVbdULA9HSVvRon
	GZtSvjx6dMZPiaU4I9FQi7moOBEAGMiaWBcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd3uYLVgg8nz2Syuf3nOajH/yDlW
	i3OvVjJanG16w26x6fE1VovLu+awWcw4v4/J4vZlXoul1y8yWUyYvpbF4tXBNhaL9TNeszjw
	eKyZt4bRo6W5h81j5fIvbB6bl9R79G1ZxejxeZOcx8a5oQHsUQ2MNhmpiSmpRQqpecn5KZl5
	6bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAdyoplCXmlAKFAhKLi5X07TBNCA1x
	07WAaYzQ9Q0JgusxMkADCesYM9YtWMZU0Clc8WeydQPjT74uRk4OCQETiU+TmhkhbDGJC/fW
	s3UxcnEICSxilOh594wdwvnLKPFox2ImkCo2AQ2Jw+9BEpwcIgJ+EmvvLWIBKWIWWMAk8W9J
	MytEx1JGiXnf3rCAVHEKaEs8f/YUrENYIEFi1vzrYPtYBFQl+t63sIHYvAKWEi+3N7BC2IIS
	PybfA+tlFtCS2LytiRXClpfYvOYtM8StChI7zr5mhLjCTWJ64w0miBoRiX0v3jFOYBSahWTU
	LCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQnmmfQOxlUNFocYBTgY
	lXh4JyirBQuxJpYVV+YeYpTgYFYS4U0wBwrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjD5
	5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY+7Rcz3Zm3vn
	7uI74BZvbr86KDhy8+uzeke5vr04/V6iYeItM6ao+rBDZcKn5zzS+ml8XyH2yjzun1YfFa9r
	9/xf3Tb1+Kbz81/XFq026s++E1/3bRff3XOiHGbHGZfeXWnUrzGTMfTSr7UJGsdTO+29nqgu
	27L843X9vBe9p//rXZjx48jzaVxKLMUZiYZazEXFiQDy/JZBdAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi wrote:
> 
> Dear Kukjin,
> 
> Ping.
> 
> Please review this patchset.
> 
Looks good to me, will apply tonight.

Thanks,
Kukjin

> Best Regards,
> Chanwoo Choi
> 
> On 03/13/2014 10:57 AM, Chanwoo Choi wrote:
> > Dear Kukjin,
> >
> > On 03/12/2014 08:21 PM, Tomasz Figa wrote:
> >> Hi Chanwoo,
> >>
> >> On 12.03.2014 07:19, Chanwoo Choi wrote:
> >>> This patch add missing dt data of Exynos4x12 to bring up kernel
> feature and
> >>> code clean. This patchset is based on 'v3.15-next/dt-clk-exynos'
> branch.
> >>> - git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-
> samsung.git
> >>>
> >>> exynos4x12/exynos4412/exynos4212.dtsi
> >>> - Add ADC (Analog and Digital Converter) to get raw data
> >>> - Add PMU (Performance Monitoring Unit) for perf event
> >>> - Add gps_alive power domain to remove power leakage when gps-alive
> isn't used
> >>> - Remove duplicate dt data of interrput combiner controller
> >>>
> >>> exynos4412-trats.dts
> >>> - Add ADC dt data with ntc thermistor child to read temperature
> >>>
> >>> Changes from v1:
> >>> - Use clock macro name for Exynos4 instead of constant for ADC
> >>> - Remove unnecessary description about patch content
> >>> - Move gps-alive power domain's dt data from exynos4x12.dts to
> exynos4.dts
> >>> - Move thermistor dt node outside of ADC dt node and modify node name
> of thermistor
> >>>
> >>> Chanwoo Choi (5):
> >>>    ARM: dts: exynos4x12: Add ADC's dt data to read raw data
> >>>    ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce
> Monitoring Unit)
> >>>    ARM: dts: exynos4x12: Add GPS_ALIVE power domain
> >>>    ARM: dts: exynos: Move common dt data for interrupt combiner
> controller
> >>>    ARM: dts: exynos4412-trats2: Add ADC/themistor dt data to get
> temperature of SoC/battery
> >>>
> >>>   arch/arm/boot/dts/exynos4.dtsi          |  5 +++++
> >>>   arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
> >>>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
> >>>   arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
> >>>   arch/arm/boot/dts/exynos4x12.dtsi       | 26
> ++++++++++++++++++++++++++
> >>>   5 files changed, 60 insertions(+), 19 deletions(-)
> >>>
> >>
> >> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> >>
> >
> > Please review or comment this patchset.
> >
> > Best Regards,
> > Chanwoo Choi

