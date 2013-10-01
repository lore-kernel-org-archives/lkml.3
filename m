Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3JALKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:10:09 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:35535 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3JALJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:09:22 -0400
From: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the random tree
Date: Tue,  1 Oct 2013 13:07:22 +0200
Message-Id: <1380625644-11331-6-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20131001110344.GA20249@ulmo.nvidia.com>
References: <20131001110344.GA20249@ulmo.nvidia.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the random tree got a conflict in:

	init/main.c

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc init/main.c
index 7cc4b78,586cd33..379090f
--- a/init/main.c
+++ b/init/main.c
@@@ -75,7 -75,7 +75,8 @@@
  #include <linux/blkdev.h>
  #include <linux/elevator.h>
  #include <linux/sched_clock.h>
 +#include <linux/context_tracking.h>
+ #include <linux/random.h>
  
  #include <asm/io.h>
  #include <asm/bugs.h>
