Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbaGOG4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:56:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58945 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:56:40 -0400
Message-ID: <53C4D0A4.3060401@gmail.com>
Date: Tue, 15 Jul 2014 08:56:36 +0200
From: Klemen Jan Enova <klemen.jan.enova@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] wait: collapse into one type definition
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Klemen Jan Enova <klemen.jan.enova@gmail.com>
---
diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd68819..d5ba4c6 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -32,11 +32,10 @@ struct wait_bit_queue {
      wait_queue_t        wait;
  };

-struct __wait_queue_head {
+typedef struct {
      spinlock_t        lock;
      struct list_head    task_list;
-};
-typedef struct __wait_queue_head wait_queue_head_t;
+} wait_queue_head_t;

  struct task_struct;
