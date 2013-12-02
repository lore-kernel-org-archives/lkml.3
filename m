Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LBXOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:14:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14056 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3LBXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:14:04 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-83-529d14354171
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'linux-leds'" <linux-leds@vger.kernel.org>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 14/39] leds: leds-ss4200: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:13:57 +0900
Message-id: <002301ceefb4$2d92a4e0$88b7eea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAs2JQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zY10zkblBBk+eMloc3TmRyaJ58Xo2
	i8sLL7FaXN41h81i65t1jA6sHjtn3WX32D93DbtH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZWxY/pSl4DZbxZt1+Q2MN1m7GDk5JARMJF59uMQIYYtJXLi3nq2LkYtDSGAZo8SpRVMZYYpa
	+huZIBKLGCW2/f0J1i0k8ItRoqUvD8RmE1CT+PLlMDuILSJgKrHx/RRGkAZmgUmMEs9+f2CB
	aLCVmP5iM9AkDg5OATuJvk+1IGFhAT+Je8evsIOEWQRUJa4+0AEJ8wJVb/q9gh3CFpT4Mfke
	2BRmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXF+ICI4mJbTugykUk9r14B3aNhMAldomXWyaA
	JVgEBCS+TT7EAtErK7HpADPEu5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQn
	pRcZ6hUn5haX5qXrJefnbmKExGbvDsbbB6wPMSYDrZ/ILCWanA+M7bySeENjMyMLUxNTYyNz
	SzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYEzfqrz62NYFWtWT4pSXxzUc
	2hgu9Et624MlM6wCHh1x3Pj8G1vBPIeVSgbcm97Pr49fEOioKZ+TJJxtv8PhwVzuF9XBlxuq
	nh3y37xE7sOGe0UzpNyZw4pm6KbGGH303HA22js6/54C+ynPqHXfNBnUPfOtvitPf16zVfnz
	j9l6CsKVTE90vimxFGckGmoxFxUnAgCEzj0i4wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAV1TkblBBn191hZHd05ksmhevJ7N
	4vLCS6wWl3fNYbPY+mYdowOrx85Zd9k99s9dw+7Rt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBkblj9lKbjNVvFmXX4D403WLkZODgkBE4mW/kYmCFtM
	4sK99WxdjFwcQgKLGCW2/f0JViQk8ItRoqUvD8RmE1CT+PLlMDuILSJgKrHx/RRGkAZmgUmM
	Es9+f2CBaLCVmP5iM9BUDg5OATuJvk+1IGFhAT+Je8evsIOEWQRUJa4+0AEJ8wJVb/q9gh3C
	FpT4Mfke2BRmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXF+ICI4mJbTugykUk9r14xziBUWgW
	kkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/4zqR2MKxssDjEK
	cDAq8fA+2D4nSIg1say4MvcQowQHs5IIbyfP3CAh3pTEyqrUovz4otKc1OJDjMlAf05klhJN
	zgcmpbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYHS2bJ/+
	a3dBvlGNTeeS3wedAxfsSW/xKs/3WruSU3f1GmOrq44WBrmLhYpP73qjceHRotL3H6QTngU1
	P5Hhn90bf/Hqad9OdXc9l/lzH6xqcf602sBwiltKMYdbTmKY0pRlt1NLm6UUd0RPW8R002Cn
	YsvtW3ydrHsunHq/uvSlYl7+vEjvx0osxRmJhlrMRcWJAKaWN9pAAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/leds/leds-ss4200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 5b8f938..2bdf642 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -63,7 +63,7 @@ MODULE_LICENSE("GPL");
 /*
  * PCI ID of the Intel ICH7 LPC Device within which the GPIO block lives.
  */
-static DEFINE_PCI_DEVICE_TABLE(ich7_lpc_pci_id) = {
+static const struct pci_device_id ich7_lpc_pci_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_30) },
-- 
1.7.10.4


