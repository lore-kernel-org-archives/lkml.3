Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3EFEEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:04:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29003 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EFEEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:04:41 -0400
X-AuditID: cbfee690-b7f136d000000fea-5c-51872bc9610a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/8] mfd: intel_msic: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:04:25 +0900
Message-id: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDqyl0+9UQvzRTQyj2xWBJqMXVg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ92T2u2BBqs2CllcXniJ1eLyrjls
	FlO2H2G3ON3N6sDiMe9koEffllWMHp83yQUwR3HZpKTmZJalFunbJXBl7NrazlJwlK1i3oYF
	jA2Me1i7GDk5JARMJPYuXMQMYYtJXLi3nq2LkYtDSGAZo8TbX/Pgin7tbmeFSExnlPj99AeU
	84tR4vrJaUwgVWwCahJfvhxmB7FFBLQkuo+dZwOxmQWqJRo3TgarERbwl3jefo8RxGYRUJVY
	Nu8ImM0rYCkxqWcbK4QtKPFj8j0WiF4tifU7jzNB2PISm9e8hTpVQWLH2deMELv0JNZ2/WaE
	qBGR2PfiHSPIcRICy9glWi49ZYFYJiDxbfIhIJsDKCErsekA1BxJiYMrbrBMYBSbhWT1LCSr
	ZyFZPQvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQmJrwg7GewesDzEmA62fyCwl
	mpwPjM28knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTBavaoLOLqR6eGJnXbLX99NvtnyS6c7b36mX27E18qEabsYbJU2qV6zfHZ3a/JNI7+Us25n
	+tkUSs4Ha6TcPvOlweHg6cLl6QpGvVWzYiTzbrtMWpfLmtLNclc8dXNY08tq0Yc3tpslFvpw
	XY781Hc4/EzUo3ijayJ8n/aunXP/gHCjbPW1ov1KLMUZiYZazEXFiQDIkTUNwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO5J7fZAg8uX+CwuL7zEanF51xw2
	iynbj7BbnO5mdWDxmHcy0KNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNN
	zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0J
	gusxMkADCesYM3ZtbWcpOMpWMW/DAsYGxj2sXYycHBICJhK/drdD2WISF+6tZ+ti5OIQEpjO
	KPH76Q9WCOcXo8T1k9OYQKrYBNQkvnw5zA5iiwhoSXQfO88GYjMLVEs0bpwMViMs4C/xvP0e
	I4jNIqAqsWzeETCbV8BSYlLPNlYIW1Dix+R7LBC9WhLrdx5ngrDlJTavecsMcZGCxI6zrxkh
	dulJrO36zQhRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4cp9J72Bc1WBxiFGAg1GJh7fgSVugEGtiWXFl7iFGCQ5mJRFen71AId6UxMqq
	1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJpW8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5ak
	ZqemFqQWwWxh4uCUamBUtT78SoXz5SXGmU+UyhvLf3dp8q0IEJVJW6baLL2X5/P5fSY/sjjY
	gz6XZ9pbL3l78f3K3R9udPgYP3jSxXNLy1svt+hugLq/q593wNcIrT2XUn3fnX76MFOlbilX
	qURQYHLQKpnfE/9d+DD9k3VSy0Rjw63iWz9fvZysNSnofcx1OfPbBqlKLMUZiYZazEXFiQB9
	bEHBIAMAAA==
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
 drivers/mfd/intel_msic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 5be3b5e..977506e 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -443,7 +443,6 @@ static int intel_msic_remove(struct platform_device *pdev)
 	struct intel_msic *msic = platform_get_drvdata(pdev);
 
 	intel_msic_remove_devices(msic);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5

