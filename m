Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaJ0BgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:36:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22245 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaJ0BgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:36:02 -0400
X-AuditID: cbfee68f-f791c6d000004834-20-544da180cbe6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com
Subject: [PATCHv2 0/2] Support new Exynos4415 SoC based on Cortex-A9 quad cores
Date: Mon, 27 Oct 2014 10:35:57 +0900
Message-id: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkRLdhoW+IwatVwhZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ks
	Tl3/DBSb/JLNYtWuP4wWe3dOZnQQ8Fgzbw2jx+9fkxg9ds66y+6xeUm9x5UTTawefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXH4ymH2guU8FZ8+7GZpYGzj6mLk5JAQMJFoe/OWDcIWk7hw
	bz2QzcUhJLCUUeLRoWesXYwcYEUn/lpCxBcxSvya9QCsQUigiUmi6Vk9iM0moCWx/8UNsLiI
	QLbElcb7zCANzAJrmSQmfHnCCpIQFvCXOLT3HguIzSKgKrG4cQc7iM0r4CKx52IHE8QVChLL
	ls9kBWmWELjELtH0+icjRIOAxLfJh1ggLpKV2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihO
	Si8y1itOzC0uzUvXS87P3cQIjJHT/57172C8e8D6EKMAB6MSD69FoW+IEGtiWXFl7iFGU6AN
	E5mlRJPzgZGYVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYO
	TqkGRl9jszDLxKn/Wq+IytzdNoFnT9DxZBbXiskHGO2nN31RFH/nefWBys4Fde+D714yf/tm
	xYqd/28vuugUdHZLcM2v6huf7I/vXcy4zk+rretR1PJvza/NH1uo6tqf+BZv0yKQUv7tFqOS
	cJ6KppTotcbEQ4cPz5FKiCnifTf7Xpqul3HKLSmb40osxRmJhlrMRcWJADoqyvKMAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAd2Ghb4hBi++cln8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMw1cOsxcs56n49GE3
	SwNjG1cXIweHhICJxIm/ll2MnECmmMSFe+vZuhi5OIQEFjFK/Jr1gA0kISTQxCTR9KwexGYT
	0JLY/+IGWFxEIFviSuN9ZpAGZoG1TBITvjxhBUkIC/hLHNp7jwXEZhFQlVjcuIMdxOYVcJHY
	c7GDCWKbgsSy5TNZJzByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHIHPpHcwrmqw
	OMQowMGoxMNrUegbIsSaWFZcmXuIUYKDWUmEVzQfKMSbklhZlVqUH19UmpNafIjRFGj7RGYp
	0eR8YHLIK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAmNZTxHsz
	borSo3/sQRYXlvhkSvtwLr6n6Xbi2zpr8deCnepfTcu+H4uYZvj+7E0hLs1J9xwZFhjdPDhn
	jjP/bac56Tcn1JjkC008u6yCP3x7MK8tT53DA5fm1/WVpo22mg+fCb91/3Bp/aLvZsv/HPI9
	Xmfmrzt3dwjXz/VzXwi8UZCque1ao8RSnJFoqMVcVJwIALPNhibWAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support new Exynos4415 Samsung SoC based on Cortex-A9 quad cores.
Exynos4415 is a System-On-Chip (SoC) that is based on 32-bit RISC processor
for Smartphone. It is desigend with the 28nm low-power high-K metal gate process
and provides the best performance features.

This patchset include some patches such as:
- Support booting of Exynos4415
- Supoort uart/mct/adc/gic/i2c/spi/power-domain/pmu/mshc/ehci/ohci/pwm/amba

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
  ARM: EXYNOS: Add EXYNOS4415 SoC ID
  ARM: dts: Add dts files for Exynos4415 SoC

 arch/arm/boot/dts/exynos4415-pinctrl.dtsi | 613 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4415.dtsi         | 627 ++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/Kconfig              |   5 +
 arch/arm/mach-exynos/exynos.c             |   2 +
 4 files changed, 1247 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos4415-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4415.dtsi

-- 
1.8.5.5

