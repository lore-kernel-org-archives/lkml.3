Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaJ0Xnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:43:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24750 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaJ0Xnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:43:52 -0400
X-AuditID: cbfee68f-f791c6d000004834-5f-544ed8b5b10e
Message-id: <544ED8B5.3090607@samsung.com>
Date: Tue, 28 Oct 2014 08:43:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: kgene.kim@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, mark.rutland@arm.com, arnd@arndb.de,
        olof@lixom.net, tomasz.figa@gmail.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 0/3] ARM: dts: Add new board dts file for
 Exynos3250-based Rinato board
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkQHfrDb8Qg0tbTSz+TjrGbnH9y3NW
	iz8TWtksJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyWHr9IpPFqeufgdzJ
	L9ksVu36w+jA57Fm3hpGj9+/JjF67Jx1l91j85J6jysnmlg9+rasYvT4vEkugD2KyyYlNSez
	LLVI3y6BK+Pjo/1sBfv5K9q3HGBuYNzM08XIySEhYCLx/vJeRghbTOLCvfVsXYxcHEICSxkl
	Fq9fBpTgACv62h0GEZ/OKHFhSQ8zhPOaUeL1ui1sIN28AloSl7qngtksAqoSU29NBLPZgOL7
	X9wAs0UFwiRWTr/CAlEvKPFj8j0wW0RAUqKp4Q/YUGaBe0wSK/9+YQZJCAvESyz7BjFISMBF
	YvvXfUwgNqeAq8TydxvB4swCOhL7W6dB2fISm9e8BRskIdDJIbFr9Q9miIsEJL5NPsQC8Y6s
	xKYDzBAvS0ocXHGDZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl5+du
	YgTG8+l/z/p3MN49YH2IUYCDUYmH16LQN0SINbGsuDL3EKMp0BUTmaVEk/OBSSOvJN7Q2MzI
	wtTE1NjI3NJMSZx3odTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MDrnzU5bZqDs1Ol7r
	yfsVe8fs3Kx5s6PseLpTqg2vl14O3fz+3L9MI6b8N8djbVdwHxBUCttTlHx3ruFUcQb2pWZy
	5gY7KvmOZZ6Y7pQ97dse5/Zkke0tM8u7BfzlvdhMrv6NfN6c+cn1e3Xp8eLtb3lO5NvvslVw
	/esrbXrzcquDRckdc3UlluKMREMt5qLiRADD2JBk4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd2tN/xCDF6e07b4O+kYu8X1L89Z
	Lf5MaGWzmHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/JYun1i0wWp65/BnIn
	v2SzWLXrD6MDn8eaeWsYPX7/msTosXPWXXaPzUvqPa6caGL16NuyitHj8ya5APaoBkabjNTE
	lNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCTlRTKEnNKgUIB
	icXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZHx/tZyvYz1/RvuUAcwPjZp4uRg4OCQET
	ia/dYV2MnECmmMSFe+vZuhi5OIQEpjNKXFjSwwzhvGaUeL1uCxtIFa+AlsSl7qlgNouAqsTU
	WxPBbDag+P4XN8BsUYEwiZXTr7BA1AtK/Jh8D8wWEZCUaGr4AzaUWeAek8TKv1+YQRLCAvES
	y75BDBIScJHY/nUfE4jNKeAqsfzdRrA4s4COxP7WaVC2vMTmNW+ZJzAKzEKyYxaSsllIyhYw
	Mq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Wz6R3MK5qsDjEKMDBqMTDa1HoGyLEmlhW
	XJl7iFGCg1lJhNdrh1+IEG9KYmVValF+fFFpTmrxIUZTYBBMZJYSTc4HJrK8knhDYxMzI0sj
	c0MLI2NzJXHeg63WgUIC6YklqdmpqQWpRTB9TBycUg2MSU+nrTzA3G+isyYjLNVkY53/fp53
	3Fevr3wtNulLgmWQr/qVYunN0RdiX5/iu/rt2r0f95fELLn5MHq7/7ncRuUGw9Mf3qRN1D/N
	uYrhykclznNCK32Vz5fb9hTeC8qVFdgje/Hw6TjJlbMO/vijOcNMO96wMs31CvPdB9a3a4+d
	ObkkQNaxTomlOCPRUIu5qDgRACGO7rEsAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin,

Did you please pick up this patchset on 3.19 queue?

Best Regards,
Chanwoo Choi

On 10/24/2014 10:12 PM, Chanwoo Choi wrote:
> This patchset adds new board dts file for Samsung Rinato board (Gear 2) which
> is based on Exynos3250 SoC and adds sleep mode pin configuration using pinctrl
> subsystem to reduce leakage power-consumption in sleep state.
> 
> This patchset is based on linux-samsung.git (for-next branch).
> 
> Changes from v3:
> - Fix wrong email address
> - Remove 'vemmc_reg' fixed regulator and then use 'ldo12_reg' for mshc_0 
> 
> Changes from v2:
> - Separate patch3 from patchset[1] and then this patchset includes patch3.
>   After applied patch3, the power-consumption of Rinato board is 0.6mA in suspend state.
>   [1] [PATCHv5 0/3] regulator: of: Add support for parsing regulator suspend state
>   : https://lkml.org/lkml/2014/10/10/161
> - Change PDN (Power-down mode) state for GPE0-3 (BT_UART_RTS) because Rinato
>   board uses UART1 for bluetooth device. BT_UART_RTS pin should be disabled in
>   suspend state by setting high state of GPE0-3
> - Turn on always the regulator state of VAP_VMIPI_1.0V because if VAP_VMIPI_1.0V
>   is off state or would be not controlled by DRM driver, happen imprecise external abort.
> 
> Changes from v1:
> - Remove useless brace
> - Remove unneeded 'regulators' keyword
> - Consolidate memory information in one entry
> 
> Chanwoo Choi (3):
>   ARM: dts: Add board dts file for Exynos3250-based Rinato board
>   ARM: dts: Add sleep mode pin configuration for exynos3250-rinato
>   ARM: dts: Add sleep mode of regulator for exynos3250-rinato board
> 
>  arch/arm/boot/dts/Makefile                |   3 +-
>  arch/arm/boot/dts/exynos3250-pinctrl.dtsi |  16 +
>  arch/arm/boot/dts/exynos3250-rinato.dts   | 686 ++++++++++++++++++++++++++++++
>  3 files changed, 704 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts
> 

