Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaGVCFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:05:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9682 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaGVCFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:05:01 -0400
X-AuditID: cbfee690-b7fb56d000003439-4f-53cdc6ca211c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code
 clean
Date: Tue, 22 Jul 2014 11:04:52 +0900
Message-id: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRPfUsbPBBi9WaVv8nXSM3eLu88OM
	Fte/PGe1mH/kHKvFg6ZVTBa9C66yWZxtesNusenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	rJ/xmsWB1+P3r0mMHptWdbJ5bF5S79G3ZRWjx+dNcgGsUVw2Kak5mWWpRfp2CVwZb05OZC84
	JVhx8/x5lgbGPr4uRk4OCQETiU2de9ggbDGJC/fWA9lcHEICSxklbt1qYYUp+vP5FwtEYhGj
	ROPXm+wQThOTxO2Jj1lAqtgEtCT2v7gBNkpEQETi3ukPjCBFzAJXmSS271jPDpIQFgiRuLnk
	MxOIzSKgKnHtw11mEJtXwEXi7b6vUOvkJD7seQS2QUJgHbtE9+ZfbBANAhLfJh8C2sYBlJCV
	2HSAGaJeUuLgihssExgFFzAyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIDPrT/55N2MF4
	74D1IcZkoHETmaVEk/OBUZNXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYwJk6Yua7WO/RF9XHD1aqUVl12UFBW/JB969mvHO+aVrCklFlP6Tkz+
	+qZZ/WBzJ6PhCvkjk7j+Xnc4Xr3VK9D6oKCa2eSU5XwZExZ8co37tFPyUrGtq+Teb9s1kksa
	+DPe6hduSF8p3i7mp5b8YJvS866P199YlLzv9xGdWrajUmdt9rdMf3clluKMREMt5qLiRAD8
	pe0pkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jAd1Tx84GG7z+p2Txd9Ixdou7zw8z
	Wlz/8pzVYv6Rc6wWD5pWMVn0LrjKZnG26Q27xabH11gtFrYtYbGYd+Qdi8XlXXPYLGac38dk
	sX7GaxYHXo/fvyYxemxa1cnmsXlJvUffllWMHp83yQWwRjUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzHhzciJ7wSnBipvnz7M0MPbxdTFyckgImEj8+fyLBcIWk7hwbz1b
	FyMXh5DAIkaJxq832SGcJiaJ2xMfg1WxCWhJ7H9xgw3EFhEQkbh3+gMjSBGzwFUmie071rOD
	JIQFQiRuLvnMBGKzCKhKXPtwlxnE5hVwkXi77ysrxDo5iQ97HrFPYORewMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4pp5J7WBc2WBxiFGAg1GJh3eC4tlgIdbEsuLK3EOMEhzMSiK8
	7XuAQrwpiZVVqUX58UWlOanFhxhNgbZPZJYSTc4HxnteSbyhsYmZkaWRuaGFkbG5kjjvgVbr
	QCGB9MSS1OzU1ILUIpg+Jg5OqQZGuRX+iaIp26a83sh4Rur/zsAXmj+OzJ2inSO64pKEXc7l
	hSedVmhIrKt/crzb6lbkgRj9h7MKEtc1cm946Hz5smHZg0lX1T/Onu22pWa6h5b/48kP7+dE
	3Pg07yMLl+HTVpnp8UkH17E+DLVhPleXVeH+aUbmkV89/4T1r1ZIsr7L+/fmVayzqRJLcUai
	oRZzUXEiAHYqpFy/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset support Exynos3250 ADC (Analog Digital Converter) because
Exynos3250 has additional special clock for ADC IP.

Changes from v7:
- Add acked message by Arnd Bergmann
- Use two compatible string for Exynos3250 ADC as following:
  : compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2;

Changes from v6:
- Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
- Use "sclk" clock name instead of "sclk_adc"
- Remove un-necessary macro for exyno-adc-data-v2 structure.
- Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
- Change the number of ADC channels (Exynos3250 has only two channels for ADC)

Changes from v5:
- Add acked message by Kukjin Kim
- Add reviewed messgae by Tomasz Figa
- Fix typo (for for -> for)

Changes from v4:
- Use 'exynos_adc_data' structure instead of 'exynos_adc_ops' structure
  and remove enum variable of ADC version
- Fix wrong name of special clock (sclk_tsadc -> sclk_adc)
- Add reviewed message by Naveen Krishna Chatradhi
- Add functions for ADC clock control

Changes from v3:
- Add new 'exynos_adc_ops' structure to improve readability according to
 Tomasz Figa comment[1]
 [1] https://lkml.org/lkml/2014/4/16/238
- Add new 'exynos3250-adc-v2' compatible string to support Exynos3250 ADC
- Fix wrong compaitlbe string of ADC in Exynos3250 dtsi file

Changes from v2:
- Check return value of clock function to deal with error exception
- Fix minor coding style to improve readability

Changes from v1:
- Add new "samsung,exynos-adc-v3" compatible to support Exynos3250 ADC
- Add a patch about DT binding documentation

Chanwoo Choi (4):
  iio: adc: exynos_adc: Add exynos_adc_data structure to improve
    readability
  iio: adc: exynos_adc: Control special clock of ADC to support
    Exynos3250 ADC
  iio: devicetree: Add DT binding documentation for Exynos3250 ADC
  ARM: dts: Fix wrong compatible string for Exynos3250 ADC

 .../devicetree/bindings/arm/samsung/exynos-adc.txt |  25 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   5 +-
 drivers/iio/adc/exynos_adc.c                       | 335 +++++++++++++++------
 3 files changed, 275 insertions(+), 90 deletions(-)

-- 
1.8.0

