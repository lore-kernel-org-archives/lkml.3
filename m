Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbaGCRNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:13:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41240 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaGCRNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:13:32 -0400
From: Hao Lan <bylanhao@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>, linux-kernel@zh-kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hao Lan <bylanhao@gmail.com>
Subject: [PATCH 1/1] [CHINESE DOCUMENTATION] Translated new section in Documentation/email-clients.txt
Date: Fri,  4 Jul 2014 01:13:16 +0800
Message-Id: <1404407596-5628-1-git-send-email-bylanhao@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/email-clients.txt has a new section about git,and this patch have translated it.

Signed-off-by: Hao Lan <bylanhao@gmail.com>
---
 Documentation/zh_CN/email-clients.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/zh_CN/email-clients.txt b/Documentation/zh_CN/email-clients.txt
index b9a1a3e..a293291 100644
--- a/Documentation/zh_CN/email-clients.txt
+++ b/Documentation/zh_CN/email-clients.txt
@@ -26,6 +26,16 @@ Documentation/email-clients.txt 的中文翻译
 Linux邮件客户端配置信息
 ======================================================================
 
+Git
+----------------------------------------------------------------------
+最近的时期大部分的开发者使用 `git send-email` 来替代常规的邮件客户端。
+这个工具的man page手册是相当不错的教程。在接收那端，维护者使用 `git am`
+去应用这些补丁。
+
+如果你是使用git的新手请把你的第一个补丁发送给你自己。把它保存为包含标题
+的原始文本。运行 `git am raw_email.txt` 并使用 `git log` 检查改动记录。
+当改动生效时再发送补丁到恰当的邮件列表。
+
 普通配置
 ----------------------------------------------------------------------
 Linux内核补丁是通过邮件被提交的，最好把补丁作为邮件体的内嵌文本。有些维护者
-- 
1.9.3

