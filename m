Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3LFJGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:06:17 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61201 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3LFJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:05:34 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: minchan@kernel.org, pyrasis@gamil.com, harryxiyou@gmail.com,
        tshibata@ab.jp.nec.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 3/4] Documentation: zh_CN: Update broken link to tpp
Date: Fri,  6 Dec 2013 18:04:44 +0900
Message-Id: <1386320685-28484-3-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386320685-28484-1-git-send-email-sj38.park@gmail.com>
References: <1386320685-28484-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Links for 'The Perfect Patch' which described on HOWTO document is
broken. Change those links to the copy at ozlabs.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/zh_CN/HOWTO | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 7fba5aa..6c914aa 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -112,7 +112,7 @@ Linux内核代码中包含有大量的文档。这些文档对于学习如何与
 
     其他关于如何正确地生成补丁的优秀文档包括：
     "The Perfect Patch"
-        http://userweb.kernel.org/~akpm/stuff/tpp.txt
+        http://www.ozlabs.org/~akpm/stuff/tpp.txt
     "Linux kernel patch submission format"
         http://linux.yyz.us/patch-format.html
 
@@ -515,7 +515,7 @@ Linux内核社区并不喜欢一下接收大段的代码。修改需要被恰当
 
 想了解它具体应该看起来像什么，请查阅以下文档中的“ChangeLog”章节：
   “The Perfect Patch”
-  	 http://userweb.kernel.org/~akpm/stuff/tpp.txt
+  	 http://www.ozlabs.org/~akpm/stuff/tpp.txt
 
 
 这些事情有时候做起来很难。要在任何方面都做到完美可能需要好几年时间。这是
-- 
1.8.1.2

