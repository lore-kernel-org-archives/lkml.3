Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762803Ab3ECGcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:32:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63671 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762722Ab3ECGb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:31:58 -0400
X-AuditID: cbfee691-b7fe56d000004b96-94-518359dc42a6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 22/42] rtc: rtc-m48t59: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:31:56 +0900
Message-id: <002401ce47c7$e8be6960$ba3b3c20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx+Wim3POLoyoTuWXq+8gV1bLhw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA927kc2BBi8lLJZcvMpuMWf9GjaL
	ywsvsVpc3jWHzWJ/ZwejA6vHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+SC2CN4rJJSc3JLEst
	0rdL4Mo42T+fseAGW8WZvmesDYwnWbsYOTkkBEwkJrxdCGWLSVy4t56ti5GLQ0hgGaPE7s1v
	WWCKurvusUAkFjFKrOmfzgzh/GKU2PJpEVg7m4CaxJcvh9m7GDk4RAT0JdpaNEBqmAW6GSUe
	Nc9lBqkRFgiWeLtyJhuIzSKgKrFk/S2wXl4BS4mrH/ZD2YISPybfA9vMLKAlsX7ncSYIW15i
	85q3zBAXKUjsOPuaEcQWEdCTeDTvABtEjYjEvhfvGEEWSwgcYpeY1nifCWKZgMS3yYdYQI6T
	EJCV2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFpnrFibnFpXnp
	esn5uZsYIbE3cQfj/QPWhxiTgdZPZJYSTc4Hxm5eSbyhsZmRhamJqbGRuaUZacJK4rzqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhgr7qzReLzfWWvq7nDWU9F69+o4OnYmeXpMPdpu
	rJmu/CzzleWa8rSbqXzrZlSpGGT3yS9O3DlpdfIGx4DdIiLbF7N8Ohr8xOaz57YTXCdO5ulJ
	lKsyr59Td/iNy8XubpYr+s0O1Zfn9Wu1fqha1yb538l3Tu+TE5/jj7ot+jHNepL7hInFSw8r
	sRRnJBpqMRcVJwIACu+LhNMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd07kc2BBhtWWlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHGyfz5jwQ22ijN9z1gbGE+ydjFyckgImEh0
	d91jgbDFJC7cW8/WxcjFISSwiFFiTf90ZgjnF6PElk+LwDrYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDNKPGoeS4zSI2wQLDE25Uz2UBsFgFViSXrb4H18gpYSlz9sB/KFpT4MRliM7OAlsT6
	nceZIGx5ic1r3jJDXKQgsePsa0YQW0RAT+LRvANsEDUiEvtevGOcwCgwC8moWUhGzUIyahaS
	lgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP7mfQOxlUNFocYBTgYlXh4FVqaAoVY
	E8uKK3MPMUpwMCuJ8Lr9AArxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDt5JXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDozPDs0iO7w+KH5ZtSltq3aDO
	4LMha7tY2SSrdYla9r4zCz6X76tn9rrCZX0yeccVVfmGEIEHE7L8QnYum3wk5c2DjU9nPbo5
	Y9qDgtktTJZzz6zQCJbfGfW3U0F0+6P2SQuWcl8Q9N0qlcQadfGHRc074VrpLYWZ50JOF21u
	ncf+qmgFn8mqRCWW4oxEQy3mouJEAIwc1/cxAwAA
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
 drivers/rtc/rtc-m48t59.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 130f29a..d4d31fa 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -513,7 +513,6 @@ static int m48t59_rtc_remove(struct platform_device *pdev)
 		iounmap(m48t59->ioaddr);
 	if (m48t59->irq != NO_IRQ)
 		free_irq(m48t59->irq, &pdev->dev);
-	platform_set_drvdata(pdev, NULL);
 	kfree(m48t59);
 	return 0;
 }
-- 
1.7.2.5


