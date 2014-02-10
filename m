Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaBJBMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:12:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20736 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaBJBMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:12:40 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-ea-52f827879770
From: Jingoo Han <jg1.han@samsung.com>
To: "'Ralf Baechle'" <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
In-reply-to: <003901cf25fc$73002790$590076b0$%han@samsung.com>
Subject: [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
Date: Mon, 10 Feb 2014 10:12:38 +0900
Message-id: <003d01cf25fd$309c58a0$91d509e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l/GYGhOsBgXmsQoSPhLhnprg0iAAAIq5w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zQ9129R9BBt+/S1hcXniJ1WLJ5Pms
	Fpd3zWGzmDB1ErvFpT0qDqweR1euZfJY8uYQq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	dFycyl6wjrXi9tUelgbGtSxdjBwcEgImEqeeqHQxcgKZYhIX7q1n62Lk4hASWMYoMeHyIzaI
	hInEl3mXWSAS0xklei58har6xSix41cbK0gVm4CaxJcvh9lBbBEBDYmzB1vBipgFOhklFv/+
	BJYQErCVmNuwH8zmFLCTmLf0G1izsICFxIf7K8DWsQioSmy9+gUszgtUP+3WVhYIW1Dix+R7
	YDazgJbE+p3HmSBseYnNa94yQ7yjLvHory6IKSJgJPHltThEhYjEvhfvGEHOkRC4xC7x/fcq
	FohVAhLfJh+ChoSsxKYDzBAPS0ocXHGDZQKjxCwki2chWTwLyeJZSFYsYGRZxSiaWpBcUJyU
	XmSqV5yYW1yal66XnJ+7iRESnRN3MN4/YH2IMRlo/URmKdHkfGB055XEGxqbGVmYmpgaG5lb
	mpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDoynbsVUH/vH+PRvxWvfSPo0t
	f2Nq285+M/xbMCuGTebNrK/vXm7ImdeUrlGj4fvmUWDbrDVP9X/JPxHU1mS56LBdNM0jmN18
	7qpOgy5O48YpQvHifnK1p7efcHQsK9eeMr8ldsF6+6VtTb9W8fsxVRfOTTix/FUCa/vKWcv/
	mE6OT898U+H/RImlOCPRUIu5qDgRAMk23InkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd129R9BBmvmi1pcXniJ1WLJ5Pms
	Fpd3zWGzmDB1ErvFpT0qDqweR1euZfJY8uYQq0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZnRcnMpesI614vbVHpYGxrUsXYycHBICJhJf5l2GssUk
	Ltxbz9bFyMUhJDCdUaLnwlco5xejxI5fbawgVWwCahJfvhxmB7FFBDQkzh5sBStiFuhklFj8
	+xNYQkjAVmJuw34wm1PATmLe0m9gzcICFhIf7q9gA7FZBFQltl79AhbnBaqfdmsrC4QtKPFj
	8j0wm1lAS2L9zuNMELa8xOY1b5m7GDmATlWXePRXF8QUETCS+PJaHKJCRGLfi3eMExiFZiEZ
	NAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnD0P5PewbiqweIQowAH
	oxIP744/34OEWBPLiitzDzFKcDArifC+vAsU4k1JrKxKLcqPLyrNSS0+xJgM9OdEZinR5Hxg
	YsoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBka2sklTb9w9
	rpX598nyti8TTujOKNnDbmXikPNE6VWbr3ZooZ/hTkHn6LbU4/mGM6S3x6a6xir9eeq2quqR
	1NS74d/FeqdrPTK/3X2Xgf3mNVv/XwcYH2V39iY9+SI2v5r7k13PrRUudRvbK/8eve7w8ZHF
	xG/NaxcUvD5mG1Z09adCiJdL5xolluKMREMt5qLiRAB00v/3QgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HAVE_PWM symbol is only for legacy platforms that provide
the PWM API without using the generic framework. The jz4740
platform uses the generic PWM framework, after the commit "f6b8a57
pwm: Add Ingenic JZ4740 support".

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/mips/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dcae3a7..d132603 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -235,7 +235,6 @@ config MACH_JZ4740
 	select IRQ_CPU
 	select ARCH_REQUIRE_GPIOLIB
 	select SYS_HAS_EARLY_PRINTK
-	select HAVE_PWM
 	select HAVE_CLK
 	select GENERIC_IRQ_CHIP
 
-- 
1.7.10.4


