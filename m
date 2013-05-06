Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3EFEKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:10:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFEJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:09:58 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-55-51872d15f66f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 5/8] mfd: mcp-sa11x0: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:09:57 +0900
Message-id: <003201ce4a0f$91ebd600$b5c38200$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KD1+XCVCpFNUJT6KpXnGvJqHe0A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI11R3fZAg/4H8haXF15itbi8aw6b
	xeYPL9ksTnezOrB4tDT3sHnMOxno0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBn/fn9jLLjL
	UbG6R7KBcSF7FyMnh4SAicSsnSuYIGwxiQv31rN1MXJxCAksY5T48PIDC0zRqj+fWCES0xkl
	Pj3qYgVJCAn8YpS4+ZUTxGYTUJP48uUw2FQRAS2J7mPngSZxcDALFEn0nDYECQsL+Eucvnqc
	DcRmEVCVaDm9BaycV8BS4lbjfjYIW1Dix+R7YHuZgcas33mcCcKWl9i85i0zxD0KEjvOvmaE
	WKUnsftSHztEjYjEvhfvGEHulBBYxy5xsOEEE8QyAYlvkw+xgNwjISArsekA1BxJiYMrbrBM
	YBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQuKrbwfjzQPW
	hxiTgdZPZJYSTc4HxmdeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhjn3moscN8o9JijavrVc+kvEtXbLxTM2F6Y/eHnyoU6i1Z+4ci/wzh7yjbj
	6AvHJFMrr582Fbj649vqP5Z3ilgOzPEKk6l9vPKd9W4NH9a986fpR6wOqZj74bFOvOWrqZcm
	/5Q1q+YRCLpwf36Yzd+6ij1/rhdI8C6YWZol6s015citC9fC64oFlFiKMxINtZiLihMBbzhr
	vMUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoK6obnugwa0uGYvLCy+xWlzeNYfN
	YvOHl2wWp7tZHVg8Wpp72DzmnQz06NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0WyXv
	4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCNSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAa
	I3R9Q4LgeowM0EDCOsaMf7+/MRbc5ahY3SPZwLiQvYuRk0NCwERi1Z9PrBC2mMSFe+vZuhi5
	OIQEpjNKfHrUBZYQEvjFKHHzKyeIzSagJvHly2GwZhEBLYnuY+eBGjg4mAWKJHpOG4KEhQX8
	JU5fPc4GYrMIqEq0nN4CVs4rYClxq3E/G4QtKPFj8j0WEJsZaMz6nceZIGx5ic1r3jJD3KMg
	sePsa0aIVXoSuy/1sUPUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAiO3mdSOxhXNlgcYhTgYFTi4S140hYoxJpYVlyZe4hRgoNZSYTXZy9Q
	iDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBiSWvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaB
	QgLpiSWp2ampBalFMFuYODilGhgt10cJr6+9dW9Z9SwVvkwB9RDRNTMq5lXfP2HqNXeuRb7T
	pRl8Vx1PuYtorj2mGektJ7+hY9/qrVEPP6lPbew9OEWIu9TY91q5a9rdc9z/RF/7pbVO45yt
	umd+BrPfO8G4Hs+k12slZGIPT+pPrJLm2MzxtsHG3bRJdfa+I53ven5x7zvEeVmJpTgj0VCL
	uag4EQCxPK8MIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/mcp-sa11x0.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index f99d629..13198d9 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -225,8 +225,6 @@ static int mcp_sa11x0_probe(struct platform_device *dev)
 	if (ret == 0)
 		return 0;
 
-	platform_set_drvdata(dev, NULL);
-
  err_ioremap:
 	iounmap(m->base1);
 	iounmap(m->base0);
@@ -252,7 +250,6 @@ static int mcp_sa11x0_remove(struct platform_device *dev)
 	mem0 = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	mem1 = platform_get_resource(dev, IORESOURCE_MEM, 1);
 
-	platform_set_drvdata(dev, NULL);
 	mcp_host_del(mcp);
 	iounmap(m->base1);
 	iounmap(m->base0);
-- 
1.7.2.5


