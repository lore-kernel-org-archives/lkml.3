Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3CKJhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:37:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57866 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3CKJhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:37:33 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-89-513da5db833d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: adp8870: add missing braces
Date: Mon, 11 Mar 2013 18:37:30 +0900
Message-id: <00c801ce1e3c$0d5023f0$27f06bd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ePA0xuiLT2nkYRcS0gOTrPXZXFw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zA93bS20DDfrXilpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MlqWTWQvecVR8XNXA2sC4jL2LkZNDQsBE4vuvh8wQtpjEhXvr
	2boYuTiEBJYxSrz5PZcRpuj6loksEIlFjBK3f08C6xASmM0ksaJXC8RmE1CT+PLlMNBUDg4R
	AX2JthYNkDCzQKnE1gfvWUBsYQFzifPPdoLNZBFQlXi5exMriM0rYCvxYvlTRghbUOLH5Hss
	EL1aEpu3NbFC2PISm9e8ZQYZLyGgLvHory5IWERAT2LLweVMECUiEvtevGMEOVNCoJtdomHV
	dKhdAhLfJh9igeiVldh0AOpfSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPS
	i4z1ihNzi0vz0vWS83M3MULipH8H490D1ocYk4HWT2SWEk3OB8ZZXkm8obGZkYWpiamxkbml
	GWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYtZW3JtytEVDmlpDMWBjc2bn2
	3p2lggEXzByuyYvJi0tVnH1W8r2waO9J98eK37bP/HVkMVvt8mPXOIPjlV323OJdsNPva+8O
	5curS1Q8zjeKV0c+zzmelXKatdF0nsOLE+8/Wk848zCUYW1G/6v0L2xHQkXvHm4W+vRc9sOj
	UubQFYKfnVfNVGIpzkg01GIuKk4EAOg0Y82pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd3bS20DDRad4re4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGS1LJ7MWvOOo+LiqgbWB
	cRl7FyMnh4SAicT1LRNZIGwxiQv31rN1MXJxCAksYpS4/XsSM0hCSGA2k8SKXi0Qm01ATeLL
	l8NAzRwcIgL6Em0tGiBhZoFSia0P3oPNERYwlzj/bCcjiM0ioCrxcvcmVhCbV8BW4sXyp4wQ
	tqDEj8n3WCB6tSQ2b2tihbDlJTavecsMMl5CQF3i0V9dkLCIgJ7EloPLmSBKRCT2vXjHOIFR
	YBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH4TOpHYwrGywO
	MQpwMCrx8E7QsQ0UYk0sK67MPcQowcGsJMK7cpNNoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJL
	iSbnAxNEXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwTlvx
	OUaQNeaWZFCF36zS9mn2YjrlH8xDj2u/zfZVrju16WDdg0NCIiETv82bfd5ZPTLRTK1dMJFV
	etlP7td5txykp7i8lz85lcPz09HC6ZaV54veHlGY9tTh0a3fXJ5pJjfE5ou7P2Vfm3jDxbBq
	6p9dOQ/cW9+GZE86PTG+9d/L53w6v25kKbEUZyQaajEXFScCAGveumMGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing braces to include error message.
The error message is related to the return value for
sysfs_create_group(). However, sysfs_create_group() is called
when pdata->en_ambl_sens is not zero. Thus, the checking return
value should be included in the if statement.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 712c25a..7930ab3 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -895,13 +895,13 @@ static int adp8870_probe(struct i2c_client *client,
 
 	data->bl = bl;
 
-	if (pdata->en_ambl_sens)
+	if (pdata->en_ambl_sens) {
 		ret = sysfs_create_group(&bl->dev.kobj,
 			&adp8870_bl_attr_group);
-
-	if (ret) {
-		dev_err(&client->dev, "failed to register sysfs\n");
-		goto out1;
+		if (ret) {
+			dev_err(&client->dev, "failed to register sysfs\n");
+			goto out1;
+		}
 	}
 
 	ret = adp8870_bl_setup(bl);
-- 
1.7.2.5


