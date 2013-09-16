Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3IPE4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 00:56:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52861 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3IPEz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 00:55:56 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-15-52368f56e845
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jens Axboe'" <axboe@kernel.dk>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] block: sx8: use module_pci_driver()
Date: Mon, 16 Sep 2013 13:55:49 +0900
Message-id: <000101ceb299$03b50b20$0b1f2160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ymQNolKFi0ZN3SoCAKtWb5a/8Nw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI92wfrMgg0/rlS3mrF/DZrH6bj+b
	xeWFl1gtLu+aw+bA4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY8//f4wF
	rWwVdxo2MDcwdrB2MXJySAiYSNxa288CYYtJXLi3nq2LkYtDSGAZo8TKc/sZYYrO/9kGlZjO
	KPHlQAsjhPOLUeLuraNg7WwCahJfvhxm72Lk4BAR0Jdoa9EACTMLpEk0/N8ONkhYwEJi+7qz
	zCA2i4CqxMr3vWA2r4CtREfXfjYIW1Dix+R7LBC9WhLrdx5ngrDlJTavecsMMl5CQF3i0V9d
	iE16EjsfCkBUiEjse/EO7DIJgXXsEtfXbGSHWCUg8W3yIRaIVlmJTQeYId6SlDi44gbLBEax
	WUgWz0KyeBaSxbOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyTCencw3j5gfYgx
	GWj9RGYp0eR8YITmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoExIXfJNpYmS/3WfOPL2XIsq+cI9CkqRf1qOXH98M+D4vfasvmVn7+N+fdm2awP
	dgJhjhuXm4Wb9116H7O93l9GkT/NbhajoK1RVoL6PF8X/sO7Py3ZpWi0c+n9M/MNTrRJOUjy
	lBjtSEvf+ulWZ7/1vUseF3+43ps8gz3F/nFf5+4/ryYcm7RTiaU4I9FQi7moOBEAy2EbmcYC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd2wfrMgg8dX5C3mrF/DZrH6bj+b
	xeWFl1gtLu+aw+bA4nH5bKnHiRm/WTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPP/3+MBa1sFXcaNjA3MHawdjFyckgImEic/7ONDcIWk7hwbz2Q
	zcUhJDCdUeLLgRZGCOcXo8TdW0dZQKrYBNQkvnw5zN7FyMEhIqAv0daiARJmFkiTaPi/nRHE
	FhawkNi+7iwziM0ioCqx8n0vmM0rYCvR0bWfDcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveMoOM
	lxBQl3j0Vxdik57EzocCEBUiEvtevGOcwCgwC8mgWUgGzUIyaBaSlgWMLKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxguP3mdQOxpUNFocYBTgYlXh4O7TNgoRYE8uKK3MPMUpwMCuJ8Eb7
	AYV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5ha8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qBsZ450OddtvyHDBMvx8oVNyzW7mdVe71mQ+WE03M+8fVe
	WiS3NDTj26LNX73nGT561LnY9V2RsfT2TS1vT01bE5n77szsSRpbvR4XnPAQaYpoWse91+DC
	8pB1a0qbBFcq2+VLTL8l03SD/ZTRu+w61Z1qXOJWMfNu3+iOqtLRveU4a9akuMDvZ5RYijMS
	DbWYi4oTAVS8/cgjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module_pci_driver() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/sx8.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 3fb6ab4..7b2ac95 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1747,17 +1747,4 @@ static void carm_remove_one (struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 }
 
-static int __init carm_init(void)
-{
-	return pci_register_driver(&carm_driver);
-}
-
-static void __exit carm_exit(void)
-{
-	pci_unregister_driver(&carm_driver);
-}
-
-module_init(carm_init);
-module_exit(carm_exit);
-
-
+module_pci_driver(carm_driver);
-- 
1.7.10.4


