Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaJ1LBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:01:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25964 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ1LBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:01:50 -0400
X-AuditID: cbfee68d-f79296d000004278-89-544f779c13aa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 0/2] ARM: EXYNOS: Support new Exynos4415 SoC based on
 Cortex-A9 quad cores
Date: Tue, 28 Oct 2014 20:01:44 +0900
Message-id: <1414494106-16584-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkRHdOuX+IwfIGRYu/k46xW1z/8pzV
	Ytff+4wWk+5PYLHY0XCE1aJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWaw9cpfdYun1i0wW
	p65/BopNfslmsWrXH0aLvTsnMzoIeKyZt4bR4/evSYweO2fdZffYvKTe48qJJlaPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgymj7sY+x4BtvxbxbdQ2MW7i7GDk4JARMJPZeNOxi5AQyxSQu
	3FvP1sXIxSEksJRRYtvxn+wQCROJGR9PMEEkpjNK/L25mRUkISTQxCRxZ6cViM0moCWx/8UN
	NhBbREBSoqnhDzOIzSzQyCzR0C4MYgsLxEnsWLUSLM4ioCpxcPo3RpAjeAVcJQ6eDIfYpSCx
	bPlMVpBdEgLn2CVOr9/CClEvIPFt8iEWiKNlJTYdYIaol5Q4uOIGywRGwQWMDKsYRVMLkguK
	k9KLDPWKE3OLS/PS9ZLzczcxAqPj9L9nvTsYbx+wPsQowMGoxMNr8NAvRIg1say4MvcQoynQ
	honMUqLJ+cAYzCuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgXGlceXxLybTzJ0dJNtvKW1seseVWbI6d05f0sd3Tttao4zVztX7irjfsiv8MeHRu4KA
	RSErTinVm7y3zdkkoKXXGDOn3uVmqZ5so2TTZS4lPt/ij6fzamfd187Y5VGd+vKNeCm/0fW9
	y5nPFwb2JO8Ma5vZcPb0sndxi37svhPHlCG6+eUBfiWW4oxEQy3mouJEAKC7kqeJAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jQd055f4hBnM2iFv8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMth/7GAu+8VbMu1XX
	wLiFu4uRk0NCwERixscTTBC2mMSFe+vZuhi5OIQEpjNK/L25mRUkISTQxCRxZ6cViM0moCWx
	/8UNNhBbREBSoqnhDzOIzSzQyCzR0C4MYgsLxEnsWLUSLM4ioCpxcPo3xi5GDg5eAVeJgyfD
	IXYpSCxbPpN1AiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0fdMegfjqgaLQ4wC
	HIxKPLyGD/1ChFgTy4orcw8xSnAwK4nwRsT4hwjxpiRWVqUW5ccXleakFh9iNAVaPpFZSjQ5
	H5gY8kriDY1NzIwsjcwNLYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MK778JRn2dwH
	UYeSPirHT6yLYW7cLW4xMTmnLmP5i/Bs5UIek7Ud6kZuDJWhKu+iTt8PdZh33Ofjsev8Gyr9
	TTb5nuYteVcmoHVqtgTrMv+513f+qZbvXOr1wPjiLaHmcp1w804LzfLldQKa8w5VdC34uNM/
	TiT18kX1uEvxa2Y8v9JzW3dWjhJLcUaioRZzUXEiAL+3MxHUAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos4415 Samsung SoC based on Cortex-A9 quad cores.
Exynos4415 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate
process and provides the best performance features.

This patchset include some patches such as:
- Support booting of Exynos4415
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/ehci/ohci/pwm/amba

Changes from v3:
- Remove un-used gpio from exynos4415-pinctrl.dtsi
- Fix wrong value of CPU nodes
- Remove fixed-rate-clocks because it has not dependency on SoC

Changes from v2:
- Modify the name of first patch

Changes from v1:
- Remove legacy helper function to identify SoC
- Separate out the clock patches[2] from Exynos4415 patchset[1] and sent it [2]
- Separate out the pinctrl patch[3] from Exynos4415 patchset[1] and sent it [3]
 [1] [PATCH 0/5] Support new Exynos4415 SoC based on Cortex-A9 quad cores
 : https://lkml.org/lkml/2014/10/19/253
 [2] [PATCHv3 1/2] clk: samsung: exynos4415: Add clocks using common clock framework
 : https://lkml.org/lkml/2014/10/26/159
 [3] [PATCHv2] pinctrl: exynos: Add support for Exynos4415
 : https://lkml.org/lkml/2014/10/26/160

Chanwoo Choi (2):
  ARM: EXYNOS: Add EXYNOS4415 SoC
  ARM: dts: Add dts files for Exynos4415 SoC

 arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 573 ++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4415.dtsi         | 604 ++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/Kconfig              |   5 +
 arch/arm/mach-exynos/exynos.c             |   2 +
 4 files changed, 1184 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi

-- 
1.8.5.5

