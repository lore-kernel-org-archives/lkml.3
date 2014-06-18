Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbaFRIkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:40:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50552 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaFRIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:40:07 -0400
X-AuditID: cbfee690-b7fb56d000003439-8e-53a150638be9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: t.figa@samsung.com, kgene.kim@samsung.com, thomas.ab@samsung.com,
        viresh.kumar@linaro.org, mturquette@linaro.org, shawn.guo@linaro.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 0/3] cpufreq: Use cpufreq-cpu0 driver for Exynos3250
Date: Wed, 18 Jun 2014 17:39:59 +0900
Message-id: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkQDc5YGGwwe3zRhbXvzxntehdcJXN
	4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZPJ1wkc3i6bolzBbrZ7xmsehYxmix8auHA4/H
	nWt72Dw2L6n36NuyitHj8ya5AJYoLpuU1JzMstQifbsErow7J5ULLrBXzLpzl6mBcT1bFyMn
	h4SAicT0adNZIWwxiQv3QOJcHEICSxklHl3/xA5TdGvdBhaIxHRGiTlHvjBCOE1MEn0H3jOD
	VLEJaEnsf3EDbKyIQA+jxNIOe5AiZoGdjBLzr7aBFQkLuEnc7vkAZrMIqEqc+TQDrIFXwEXi
	04KHUDfJSXzY84gdpFlCYDK7xMVXn1khGgQkvk0+BHQHB1BCVmLTAWaIekmJgytusExgFFzA
	yLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzC0T/97NmEH470D1ocYk4HGTWSWEk3OB8ZG
	Xkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwKjzV
	+PnnwQWbefcjOniPO76sVanIbLjBx6TeFrNn896zH36YflvSmc6R9Xgzs4AGB2PmnEKG24xq
	qTe1rSS7X/QxKLTWpVjx5/IcN5h3JzCV6dByp22ezVMKv0T8bs47/L3gR17wTO2cieWM//Pm
	+XQVTzf9d4RfJ7whJtdsWU7Ul86+nkolluKMREMt5qLiRAAtbVgmgwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQd3kgIXBBnfbdCyuf3nOatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyeDrhIpvF03VLmC3Wz3jNYtGxjNFi41cPBx6P
	O9f2sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz7pxULrjAXjHrzl2mBsb1bF2MnBwSAiYSt9ZtYIGwxSQu3AOJc3EICUxnlJhz5AsjhNPE
	JNF34D0zSBWbgJbE/hc3wLpFBHoYJZZ22IMUMQvsZJSYf7UNrEhYwE3ids8HMJtFQFXizKcZ
	YA28Ai4SnxY8hFotJ/FhzyP2CYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER84z
	6R2MqxosDjEKcDAq8fBy5C4IFmJNLCuuzD3EKMHBrCTCO8VzYbAQb0piZVVqUX58UWlOavEh
	xmSg7ROZpUST84FRnVcSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwc
	nFINjGHPDyioPfm3OVROiVs7cX6+/JYzm/LdeK79C9NbzaMjqZup8GfTMb/c6IOSbxsj44L8
	3s919LCy0WXMaQ4uSFRIcXtey/HgzI1Ytvzew9lBOpyyWzo5koW7N3konpBXPHhvZ4nhqiPv
	2M/+vL8pLC7riqbYjd5ldalZvUX/jj3uzUuOFr6txFKckWioxVxUnAgAro4rCOACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use cpufreq-cpu0 driver to support Exynos3250 cpufreq. So, this
patchset is based on following patchset[1] by Thomas Abraham.
 [1] http://www.spinics.net/lists/arm-kernel/msg339392.html

Changes from v1:
- Rebased on new patchset[1] by Thomas Abraham
- Modify clk-cpu.c to support Exynos3250
- Drop documentation patch on previous patchset[2]
 [2] http://www.spinics.net/lists/cpufreq/msg10265.html
- Add only operating-points for Exynos3250 without armclk-divider-table

Chanwoo Choi (3):
  clk: samsung: cpu: Add support for cpu clocks of Exynos3250
  clk: samsung: exynos3250: Use cpu-clock provider type to support cpufreq
  ARM: dts: Exynos: Add cpu clock table for Exynos3250

 arch/arm/boot/dts/exynos3250.dtsi    | 15 +++++++++++++++
 drivers/clk/samsung/clk-cpu.c        | 31 +++++++++++++++++++++++++++++++
 drivers/clk/samsung/clk-exynos3250.c | 14 ++++++++++----
 3 files changed, 56 insertions(+), 4 deletions(-)

-- 
1.8.0

