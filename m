Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaATHRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 02:17:20 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7069 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaATHRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 02:17:14 -0500
Message-ID: <52DCCD61.9080302@huawei.com>
Date: Mon, 20 Jan 2014 15:16:49 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>
CC: Xishi Qiu <qiuxishi@huawei.com>, <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] doc/kmemcheck: add kmemcheck to kernel-parameters
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "kmemcheck=xx" to Documentation/kernel-parameters.txt.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..671de56 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1415,6 +1415,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Valid arguments: on, off
 			Default: on
 
+	kmemcheck=	[X86] Boot-time kmemcheck enable/disable/one-shot mode
+			Valid arguments: 0, 1, 2
+			kmemcheck=0 (disabled)
+			kmemcheck=1 (enabled)
+			kmemcheck=2 (one-shot mode)
+			Default: 2 (one-shot mode)
+
 	kstack=N	[X86] Print N words from the kernel stack
 			in oops dumps.
 
-- 
1.7.1


