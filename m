Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaJ1ATW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:19:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47852 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaJ1ATU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:19:20 -0400
X-AuditID: cbfee691-f79b86d000004a5a-d6-544ee1068dd4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
 <544ED8B5.3090607@samsung.com>
In-reply-to: <544ED8B5.3090607@samsung.com>
Subject: RE: [PATCHv4 0/3] ARM: dts: Add new board dts file for
 Exynos3250-based Rinato board
Date: Tue, 28 Oct 2014 09:19:14 +0900
Message-id: <01b401cff244$d0052610$700f7230$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQC2G7MyHpA3aF0xEvQrAvxmbhybHQJ8B5m1nmRxYuA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY122h34hBrcWKVv8nXSM3eL6l+es
	Fn8mtLJZTLo/gcXi9QtDi7NNb9gtNj2+xmpxedccNosZ5/cxWSy9fpHJ4tT1z0Du5JdsFqt2
	/WF04PVYM28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8AexWWTkpqTWZZapG+X
	wJXxZNN99oIvghWPNqxmaWDs5uti5OSQEDCR2HR6AQuELSZx4d56ti5GLg4hgWWMEl93bwJy
	OMCKWhYIQcQXMUo0nt7CDtIgJPCXUeJ9vxuIzSagIXH4/TOwuIiAlsTEzplMIA3MAjuYJH6d
	3cwC0ZAq8eXNdyYQm1NAW6Lj6BWwBmGBeIlnWxexgdgsAqoScxb8AbN5BSwl7p5dzghhC0r8
	mHwPbA4z0IL1O48zQdjyEpvXvGWG+EBBYsfZ14wQR1hJzJwFMZ9ZQERi34t3jCAHSQgs5JDY
	2tLIArFMQOLb5EMsEF/KSmw6ADVHUuLgihssExglZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJBUMHEH4/0D1ocYBTgYlXh4LQp9Q4RYE8uKK3MPMZoCXTSR
	WUo0OR+YcPJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amBsu30gOVqYUUNywvZDi40v8M3ec4D/Q2tcdrmy+7OQpRz3Z+gmqefHWVU8uKS8XnBKCOfu
	5RMNg4wDSu42hc4SUmp8++ZZpHlKa3iqV2Wtl9zKPqPXXYn9LpclXt6IqrO1vr7c7U35m6B+
	yaPflPPi0z12JmQKPdRwCa7fk//2x5KvDB5fbJVYijMSDbWYi4oTAW/5cdoAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAV22h34hBp865Sz+TjrGbnH9y3NW
	iz8TWtksJt2fwGLx+oWhxdmmN+wWmx5fY7W4vGsOm8WM8/uYLJZev8hkcer6ZyB38ks2i1W7
	/jA68HqsmbeG0eP3r0mMHjtn3WX32Lyk3uPKiSZWj74tqxg9Pm+SC2CPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WTTffaCL4IVjzasZmlg7ObrYuTgkBAwkWhZINTF
	yAlkiklcuLeerYuRi0NIYBGjROPpLewgCSGBv4wS7/vdQGw2AQ2Jw++fgcVFBLQkJnbOZAJp
	YBbYwSTx6+xmFoiGVIkvb74zgdicAtoSHUevgDUIC8RLPNu6iA3EZhFQlZiz4A+YzStgKXH3
	7HJGCFtQ4sfke2BzmIEWrN95nAnClpfYvOYtM8SlChI7zr5mhDjCSmLmLIj5zAIiEvtevGOc
	wCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxghPNM+kdjKsa
	LA4xCnAwKvHwWhT6hgixJpYVV+YeYpTgYFYS4fXa4RcixJuSWFmVWpQfX1Sak1p8iNEU6NOJ
	zFKiyfnAJJhXEm9obGJmZGlkZmFkYm6uJM57sNU6UEggPbEkNTs1tSC1CKaPiYNTqoHRP+Os
	ziTGBpeN9/bd4dKOryn/XLf97ov89usCVw/Yf1us3tdv8mubx/Y23l/FU2cVrtuWbNO3Mq82
	b1OWyN0N8RdUOWZfDN93+/kv0RItLtOTzv6/jsdFB6nPuajckRejVv/Ml8khzM9w+YETmTdK
	m+7ffL732Yc385R3dE/Uy2g9wRtUkftViaU4I9FQi7moOBEARyPpIUoDAAA=
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
Hi,

> Did you please pick up this patchset on 3.19 queue?
> 
I'll apply this series once my previous pull-request which has been sent out
last week is merged into arm-soc tree.

If any comments on this series, I'll let you know.

Thanks,
Kukjin


> Best Regards,
> Chanwoo Choi
> 
> On 10/24/2014 10:12 PM, Chanwoo Choi wrote:
> > This patchset adds new board dts file for Samsung Rinato board (Gear 2) which
> > is based on Exynos3250 SoC and adds sleep mode pin configuration using pinctrl
> > subsystem to reduce leakage power-consumption in sleep state.
> >
> > This patchset is based on linux-samsung.git (for-next branch).
> >
> > Changes from v3:
> > - Fix wrong email address
> > - Remove 'vemmc_reg' fixed regulator and then use 'ldo12_reg' for mshc_0
> >
> > Changes from v2:
> > - Separate patch3 from patchset[1] and then this patchset includes patch3.
> >   After applied patch3, the power-consumption of Rinato board is 0.6mA in suspend state.
> >   [1] [PATCHv5 0/3] regulator: of: Add support for parsing regulator suspend state
> >   : https://lkml.org/lkml/2014/10/10/161
> > - Change PDN (Power-down mode) state for GPE0-3 (BT_UART_RTS) because Rinato
> >   board uses UART1 for bluetooth device. BT_UART_RTS pin should be disabled in
> >   suspend state by setting high state of GPE0-3
> > - Turn on always the regulator state of VAP_VMIPI_1.0V because if VAP_VMIPI_1.0V
> >   is off state or would be not controlled by DRM driver, happen imprecise external abort.
> >
> > Changes from v1:
> > - Remove useless brace
> > - Remove unneeded 'regulators' keyword
> > - Consolidate memory information in one entry
> >
> > Chanwoo Choi (3):
> >   ARM: dts: Add board dts file for Exynos3250-based Rinato board
> >   ARM: dts: Add sleep mode pin configuration for exynos3250-rinato
> >   ARM: dts: Add sleep mode of regulator for exynos3250-rinato board
> >
> >  arch/arm/boot/dts/Makefile                |   3 +-
> >  arch/arm/boot/dts/exynos3250-pinctrl.dtsi |  16 +
> >  arch/arm/boot/dts/exynos3250-rinato.dts   | 686 ++++++++++++++++++++++++++++++
> >  3 files changed, 704 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/boot/dts/exynos3250-rinato.dts
> >

