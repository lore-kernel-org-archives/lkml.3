Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaG2CR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:17:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaG2CRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:17:18 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-49-53d7042b7446
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/3] ARM: dts: Add TMU dt node and missing data for Exynos3250
Date: Tue, 29 Jul 2014 11:17:09 +0900
Message-id: <1406600232-31033-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkRFeb5Xqwwfc+dYtJ6w4wWVz/8pzV
	Yv6Rc6wWvQuuslmcbXrDbrHp8TVWi4VtS1gsLu+aw2Yx4/w+Jovbl3kt1s94zeLA7dHS3MPm
	8XfVC2aPzUvqPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj6M3NbAWTWSrOTTvL2MC4kbmL
	kZNDQsBEYv219VC2mMSFe+vZuhi5OIQEljJKnL28nQmmaPKErWC2kMAiRonna4shipqYJK4+
	eMkGkmAT0JLY/+IGmC0iICnR1PCHGaSIWWAVk8SN4y/AVggL+ElMX78BqIiDg0VAVWLiUguQ
	MK+Aq8T5p11Qy+QkPux5xA7SKyEwnV3iXscuFpAEi4CAxLfJh1hAeiUEZCU2HYC6WlLi4Iob
	LBMYBRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAzt0/+e9e1gvHnA+hBjMtC4icxS
	osn5wNjIK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MLOXzD7pM+qpx9s88loaNblGsydHmqZJ/BC+LprSGauSrVKdkGHByBKxTXbUgweDe4gss
	5de3zlX69XaiOoPhsYiH7sX+mjETzmevNvjD8o7rdfUs38A5qwWVArjPzNZuOb+qbZb2gV93
	zlz9kxx+g8HyD/Pjd5x7RP4uOszwQ+6F1nFl/aJdSizFGYmGWsxFxYkAc3zorYMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAV1tluvBBgfmyltMWneAyeL6l+es
	FvOPnGO16F1wlc3ibNMbdotNj6+xWixsW8JicXnXHDaLGef3MVncvsxrsX7GaxYHbo+W5h42
	j7+rXjB7bF5S79G3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYM47e3MxWMJml4ty0s4wNjBuZuxg5OSQETCQmT9jKBGGLSVy4t54NxBYSWMQo8XxtcRcj
	F5DdxCRx9cFLsASbgJbE/hc3wGwRAUmJpoY/zCBFzAKrmCRuHH8BNlVYwE9i+voNQEUcHCwC
	qhITl1qAhHkFXCXOP+2CWiYn8WHPI/YJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+du
	YgRHzjPpHYyrGiwOMQpwMCrx8G6Yey1YiDWxrLgy9xCjBAezkgjv/CVAId6UxMqq1KL8+KLS
	nNTiQ4ymQMsnMkuJJucDozqvJN7Q2MTMyNLI3NDCyNhcSZz3YKt1oJBAemJJanZqakFqEUwf
	EwenVANjGKfi5K+WBh07mhTkVX+afKo9UxXFnjzLOero7mmSJ3x9L54SK1s8L4LrY/2N4M2i
	0p/OH1SP9RXdsE/Us/KhYPn5+891Xq2xYju3JdBCPEaU3yzB9/JHdw5WboaiNzXTLITUt3+x
	UbJ8eDtXdHpUNqe+1Osqo4cZh5qMHcX6dsqcl5KesFSJpTgj0VCLuag4EQBXQeszsgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add TMU (Thermal Management Unit) dt node and missing pinctrl
property of uart0/1. Also, this patchset remove duplcate 'interrupt-parent'
property for code clean.

Chanwoo Choi (3):
  ARM: dts: Add TMU dt node to monitor the temperature for Exynos3250
  ARM: dts: Remove duplicate 'interrput-parent' property for Exynos3250
  ARM: dts: Add missing pinctrl for uart0/1 for Exynos3250

 arch/arm/boot/dts/exynos3250.dtsi | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

-- 
1.8.0

