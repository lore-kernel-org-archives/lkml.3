Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaD1KrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:47:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaD1KrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:47:05 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d3-535e31a7f47c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 4/7 v8] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Mon, 28 Apr 2014 16:14:56 +0530
Message-id: <1398681899-20782-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTne5YVywwaT5ShYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKaHz4kq3gC3fFpBuzGBsYP3B2MXJySAiYSFx5No8R
	whaTuHBvPVsXIxeHkMBSRoktb+eywhRN/riBBcQWEpjOKHHhYB5EUT+TxK4Hk8GK2ATMJA4u
	Ws0OYosIOEv8bl7DClLELLCOUeLTm8NMIAlhgRCJlpaHYDaLgKrEhN+3wZp5BVwlDh88AWRz
	AG1TkJgzyQYkzCngJnF1/TlGiMWuEkt7fzCDzJQQWMUu0br5AhvEHAGJb5MPsUD0ykpsOsAM
	cbSkxMEVN1gmMAovYGRYxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREY9Kf/PevdwXj7gPUh
	xmSgcROZpUST84FRk1cSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjK4rAybMZnB153tcqXVXwLFNO2zBBcerrYuWbqqZ8Y2v+Mj82StrOOMXuZkx
	TtJt7NyWuD3TzjWX/8c9zjs9F2Y5vX7n7ruqWMroxMaDAk6te453tdj1hotxTqlKs2GtEonN
	PLPi8/7bV8pCsxxb8k029K4Rau7wunZRwHt645TSPZcqdB+xK7EUZyQaajEXFScCAKFtY1mQ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd3lhnHBButXSlm8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY0bjw5dsBV+4
	KybdmMXYwPiBs4uRk0NCwERi8scNLBC2mMSFe+vZQGwhgemMEhcO5nUxcgHZ/UwSux5MZgVJ
	sAmYSRxctJodxBYRcJb43byGFaSIWWAdo8SnN4eZQBLCAiESLS0PwWwWAVWJCb9vgzXzCrhK
	HD54AsjmANqmIDFnkg1ImFPATeLq+nOMEItdJZb2/mCewMi7gJFhFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwTD2T2sG4ssHiEKMAB6MSD2/EnNhgIdbEsuLK3EOMEhzMSiK8+yXigoV4
	UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5HxjveSXxhsYm5qbGppYmFiZmlqQJK4nzHmi1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXAGPVMx4rFYp3+23WfU8WOPWMUtAqYv/aCmVXxrpNWenvf37x+
	WFjt2LW/Cb17TPb9+JUdfOLOhZIKoTv6z16++BJ29AbHo+ZouX1fytfHu5yeaXDHziE+zy40
	MaT6oNDLT5nyWd1mxcr39zIX+/u9FeWQO2t7Yxp35E/5/LxzeooT10c/sbj7XYmlOCPRUIu5
	qDgRAFIjZxXtAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Kconfig such that ARCH_EXYNOS SoCs
which includes (Exynos4210, Exynos5250 and Exynos5420)
can also select Samsung SSS(Security SubSystem) driver.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Change since v6:
None
Change since v5:
None

 drivers/crypto/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0..f066fa2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -301,14 +301,14 @@ config CRYPTO_DEV_SAHARA
 	  found in some Freescale i.MX chips.
 
 config CRYPTO_DEV_S5P
-	tristate "Support for Samsung S5PV210 crypto accelerator"
-	depends on ARCH_S5PV210
+	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
+	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
-	  Select this to offload Samsung S5PV210 or S5PC110 from AES
+	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
 	  algorithms execution.
 
 config CRYPTO_DEV_NX
-- 
1.7.9.5

