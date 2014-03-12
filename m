Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbaCLGTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:19:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58115 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaCLGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:21 -0400
X-AuditID: cbfee68f-b7f156d00000276c-b5-531ffc6791d5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/5] ARM: dts: exynos: Add missing dt data to bring kernel of
 Exynos4x12
Date: Wed, 12 Mar 2014 15:19:11 +0900
Message-id: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSopv+Rz7Y4P0FTYvrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi1cE2Fov1
	M16zOPB6rJm3htGjpbmHzWPl8i9sHpuX1Hv0bVnF6PF5k5zHxrmhAexRXDYpqTmZZalF+nYJ
	XBmvp81gKZjMW3Fm3RqWBsYnXF2MnBwSAiYS1/Z1skPYYhIX7q1n62Lk4hASWMoocbP5OStM
	0arV/cwQiemMEhf/fmKHcBqZJC4fuAdWxSagJbH/xQ02EFtEQFdiysw7YHFmgWNMEiemOoDY
	wgIxEj9+PwRbxyKgKnFyySQwm1fAReL+4zZmiG1yEh/2PAJbICGwjV1i5+ulTBANAhLfJh9i
	6WLkAErISmw6AFUvKXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIExsDp
	f8/6dzDePWB9iDEZaNxEZinR5HxgDOWVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBsajEpumvTQv9Qr4r1j1T9brSQpHwt+IozFXNmgeC1XpDiqq
	u91zL/XWqtdsn8wvKLbu0/Dn6j2x911e/fxdR69JRtXMtPdyORH6OFq+RuTdtddRjwQ/iDx8
	cmPvl4tmRitWl7864TGrU6jjltrOqR86M/cJ7gnl3uq61/aArzKLeuD0yfGydQVKLMUZiYZa
	zEXFiQBhL+JYlwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jQd30P/LBBqemK1lc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWrw62sVis
	n/GaxYHXY828NYweLc09bB4rl39h89i8pN6jb8sqRo/Pm+Q8Ns4NDWCPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8XraDJaCybwVZ9atYWlgfMLVxcjJISFgIrFqdT8z
	hC0mceHeerYuRi4OIYHpjBIX/35ih3AamSQuH7jHClLFJqAlsf/FDTYQW0RAV2LKzDtgcWaB
	Y0wSJ6Y6gNjCAjESP34/ZAexWQRUJU4umQRm8wq4SNx/3Aa1TU7iw55H7BMYuRcwMqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECI6wZ1I7GFc2WBxiFOBgVOLhXaApHyzEmlhWXJl7iFGC
	g1lJhPcjSIg3JbGyKrUoP76oNCe1+BBjMtD2icxSosn5wOjPK4k3NDYxM7I0Mje0MDI2J01Y
	SZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGKbG1D7I8chkNGjm37HVlLZ6ywdCH/Z9Al8yB
	z7/m/Lmjtm5CsFLh3B5d14UaJ7dubFvS/sZyWpFu/RqLp0eNxKtn5qnxPzZ59SHb75jE43uu
	6i8v/HhmdMG3rUL/WCCb14XrCcUeJYKmNa8sN65LTZzZHxP8JXia2yS5f/UsqSLxxg+Xxmor
	sRRnJBpqMRcVJwIANGh2YfQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add missing dt data of Exynos4x12 to bring up kernel feature and
code clean. This patchset is based on 'v3.15-next/dt-clk-exynos' branch.
- git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git

exynos4x12/exynos4412/exynos4212.dtsi
- Add ADC (Analog and Digital Converter) to get raw data
- Add PMU (Performance Monitoring Unit) for perf event
- Add gps_alive power domain to remove power leakage when gps-alive isn't used
- Remove duplicate dt data of interrput combiner controller

exynos4412-trats.dts
- Add ADC dt data with ntc thermistor child to read temperature

Changes from v1:
- Use clock macro name for Exynos4 instead of constant for ADC
- Remove unnecessary description about patch content
- Move gps-alive power domain's dt data from exynos4x12.dts to exynos4.dts
- Move thermistor dt node outside of ADC dt node and modify node name of thermistor

Chanwoo Choi (5):
  ARM: dts: exynos4x12: Add ADC's dt data to read raw data
  ARM: dts: exynos4x12: Add PMU dt data to support PMU(Perforamnce Monitoring Unit)
  ARM: dts: exynos4x12: Add GPS_ALIVE power domain
  ARM: dts: exynos: Move common dt data for interrupt combiner controller
  ARM: dts: exynos4412-trats2: Add ADC/themistor dt data to get temperature of SoC/battery

 arch/arm/boot/dts/exynos4.dtsi          |  5 +++++
 arch/arm/boot/dts/exynos4212.dtsi       | 13 ++++---------
 arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
 arch/arm/boot/dts/exynos4412.dtsi       | 14 ++++----------
 arch/arm/boot/dts/exynos4x12.dtsi       | 26 ++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 19 deletions(-)

-- 
1.8.0

