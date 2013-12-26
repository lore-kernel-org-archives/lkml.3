Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3LZD0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 22:26:16 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:34169 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZD0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 22:26:14 -0500
Message-ID: <52BBA18F.4080102@huawei.com>
Date: Thu, 26 Dec 2013 11:25:03 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc/kmemcheck: add kmemcheck to kernel-parameters.txt
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kmemcheck to Documentation/kernel-parameters.txt.

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
 
+	kmemcheck=	[KNL] Boot-time kmemcheck enable/disable/one-shot mode
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



