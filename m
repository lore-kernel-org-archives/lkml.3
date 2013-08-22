Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3HVCKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:10:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12532 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3HVCKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:10:44 -0400
X-AuditID: cbfee68e-b7f276d000002279-37-52157322c3ed
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        "'Suman Anna'" <s-anna@ti.com>, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mailbox: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:10:42 +0900
Message-id: <002201ce9edc$cdc3fb90$694bf2b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3M2sAta6C6PlQ5uPPfpfFDUkPg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY12lYtEgg4OTtCzmrF/DZnF54SVW
	i8u75rBZPF7xlt1i7699rA6sHov3vGTyODHjN4tH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY1PfM/aCnawVL28dYG1gPMjSxcjJISFgInHjUScThC0mceHeerYuRi4OIYFljBK3
	N+1khila07uLGSKxiFGiu3cvVNUvRolVb64xglSxCahJfPlymB3EFhHQlVj1HKKDWWAWo8SU
	C2dYQRLCAs4St3vXgI1lEVCVaDl1HOwOXgFbif9LT0DZghI/Jt8Ds5kFtCTW7zzOBGHLS2xe
	8xaolwPoJHWJR391IXbpSXycv4IVokREYt+Ld4wgeyUEDrFLzGt9wgaxS0Di2+RDLBC9shKb
	DkB9JilxcMUNlgmMYrOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGRXnFibnFpXrpecn7u
	JkZI9PXtYLx5wPoQYzLQ+onMUqLJ+cDozSuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDo4l8x+qbxbPSXBUfLng6xV17+kdxTnaBntRm+V86l/R3
	JfzbmMJ4qXnXlB3LfFVnKQfuyriseHSiyJRkV7+uf5PNrpXfK1/8QS1mj2+lhdUfjdjuWxmO
	a6Mmq/r3dl2ccGii3srvsjG1O1hNLHMTIz9O2MtY/VV724rVRpLXZ2SpfxLes+xSrxJLcUai
	oRZzUXEiABy0wJHUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV2lYtEgg/mT1SzmrF/DZnF54SVW
	i8u75rBZPF7xlt1i7699rA6sHov3vGTyODHjN4tH35ZVjB7Hb2xn8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNT3zP2gp2sFS9vHWBtYDzI0sXIySEhYCKx
	pncXM4QtJnHh3nq2LkYuDiGBRYwS3b17oZxfjBKr3lxjBKliE1CT+PLlMDuILSKgK7HqOUg3
	FwezwCxGiSkXzrCCJIQFnCVu964BG8sioCrRcuo42DpeAVuJ/0tPQNmCEj8m3wOzmQW0JNbv
	PM4EYctLbF7zFqiXA+gkdYlHf3UhdulJfJy/ghWiRERi34t3jBMYgZYiTJqFZNIsJJNmIWlZ
	wMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4tp9J72Bc1WBxiFGAg1GJh/fCTpEgIdbE
	suLK3EOMEhzMSiK80lqiQUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0w7eSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWBnCX/fji/ZMSfeEXc2mlSuE
	J78/fddSf8eBCpE1NgenbHodYCKytmiLZDhXBRev4Pmi9+9LLu3/2xikmK4me/dBcu3CAw6f
	J7SfLyvaHXPbMNxPWJ/r2DSvlvmHZRmEn2hHrcw57O/QyfbRJq837Kz10eKCk5GZ3/cdvsMn
	OoVv9qNDlye0KrEUZyQaajEXFScCAG/6NiUxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mailbox/mailbox-omap2.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index eba380d..42d2b89 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -325,7 +325,6 @@ static int omap2_mbox_remove(struct platform_device *pdev)
 	kfree(privblk);
 	kfree(mboxblk);
 	kfree(list);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.10.4


