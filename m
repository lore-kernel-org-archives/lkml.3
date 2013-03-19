Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab3CSArD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:47:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37657 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3CSArB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:47:01 -0400
X-AuditID: cbfee68d-b7f786d000005188-c9-5147b583f9ed
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] memstick: r592: make r592_pm_ops static
Date: Tue, 19 Mar 2013 09:46:59 +0900
Message-id: <005b01ce243b$437785e0$ca6691a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kO0MTwESS4sQBR6iG1oaqAdC99A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t8zQ93mre6BBl8maVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MC0/mMBbc56o4uruTsYHxN0cXIweHhICJROdSjS5GTiBTTOLC
	vfVsXYxcHEICyxgl3v38wgJTc/JUMkR8EaPE5KdfmSGc2UwSn3/tZATpZhNQk/jy5TA7SIOI
	gL5EWwvYUGaBIoldD/cxgdjCAhYSTw+sBitnEVCVWDHhPTuIzStgK/Hryk9GCFtQ4sfkeywQ
	vVoS63ceZ4Kw5SU2r3nLDHGPusSjv7oQm/QkWj45QFSISOx78Y4R5DIJgWZ2ic4j+5kgVglI
	fJt8COoVWYlNB5gh3pWUOLjiBssERrFZSBbPQrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3IUK84
	Mbe4NC9dLzk/dxMjJEZ6dzDePmB9iDEZaP1EZinR5HxgjOWVxBsamxlZmJqYGhuZW5qRJqwk
	zqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHYxSRhut2erPdbF7a7sYT/uP3q6TR9
	vvSzeka9vCaLF3vKN5qtYdl2VzHpD+PUtqVdTZHhHAmSTV3zFNKfuDLVM8qsZOyb9VArQPit
	xxJnMbkcr55OpfWHZuazh76fpcO+pf6hr05vkwSHpabO3YT9dieMtG1+qMq71rufzWVzCe7P
	u1uqxFKckWioxVxUnAgA5V75UqcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAd3mre6BBgdmqFhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjAtP5jAW3OeqOLq7k7GB
	8TdHFyMHh4SAicTJU8ldjJxAppjEhXvr2boYuTiEBBYxSkx++pUZwpnNJPH5105GkCo2ATWJ
	L18Os4M0iwjoS7S1aICEmQWKJHY93McEYgsLWEg8PbAarJxFQFVixYT37CA2r4CtxK8rPxkh
	bEGJH5PvsUD0akms33mcCcKWl9i85i0zxG3qEo/+6kJs0pNo+eQAUSEise/FO8YJjAKzkAya
	hWTQLCSDZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAafSe9gXNVgcYhRgINR
	iYdXIcw9UIg1say4MvcQowQHs5IIb7A/UIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgekh
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYuyRfng0t2hc8
	y+eHyfK11qLOXwI2nLr0ryox5XjL+UkFbHm23jf8mm6XPHVt+st/zLHjtXu8XYH7SY+u+oWr
	L4q2v7sV8oVh29VgI08niRWan7fnX1uyT+3cSQOPhf8yp57hPJsk0Ob5TiGr0uzilz1vjpxW
	DFkWm7Ou5e6Rqez+afPTqrTXK7EUZyQaajEXFScCAJAG3IUFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

r592_pm_ops is not exported. Also, CONFIG_PM_SLEEP is used to
remove unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/r592.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index a7c5b31..9718661 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -847,7 +847,7 @@ static void r592_remove(struct pci_dev *pdev)
 			dev->dummy_dma_page_physical_address);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int r592_suspend(struct device *core_dev)
 {
 	struct pci_dev *pdev = to_pci_dev(core_dev);
@@ -870,10 +870,10 @@ static int r592_resume(struct device *core_dev)
 	r592_update_card_detect(dev);
 	return 0;
 }
-
-SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
 #endif
 
+static SIMPLE_DEV_PM_OPS(r592_pm_ops, r592_suspend, r592_resume);
+
 MODULE_DEVICE_TABLE(pci, r592_pci_id_tbl);
 
 static struct pci_driver r852_pci_driver = {
@@ -881,9 +881,7 @@ static struct pci_driver r852_pci_driver = {
 	.id_table	= r592_pci_id_tbl,
 	.probe		= r592_probe,
 	.remove		= r592_remove,
-#ifdef CONFIG_PM
 	.driver.pm	= &r592_pm_ops,
-#endif
 };
 
 static __init int r592_module_init(void)
-- 
1.7.2.5


