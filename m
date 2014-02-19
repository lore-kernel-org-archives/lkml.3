Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaBSUlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:41:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBSUln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:41:43 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: qcom: Copyright marking changes
Date: Wed, 19 Feb 2014 14:41:39 -0600
Message-Id: <1392842499-11200-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code Aurora Forum (CAF) is part of Linux Foundation Labs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/mach-qcom/platsmp.c  | 3 +--
 arch/arm/mach-qcom/scm-boot.c | 2 +-
 arch/arm/mach-qcom/scm-boot.h | 2 +-
 arch/arm/mach-qcom/scm.c      | 2 +-
 arch/arm/mach-qcom/scm.h      | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-qcom/platsmp.c b/arch/arm/mach-qcom/platsmp.c
index 9c53ea7..ede7f53 100644
--- a/arch/arm/mach-qcom/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -1,8 +1,7 @@
 /*
  *  Copyright (C) 2002 ARM Ltd.
  *  All Rights Reserved
- *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *  Copyright (c) 2014 The Linux Foundation. All rights reserved.
+ *  Copyright (c) 2010, 2014 The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-qcom/scm-boot.c b/arch/arm/mach-qcom/scm-boot.c
index 45cee3e..4f0e1fa 100644
--- a/arch/arm/mach-qcom/scm-boot.c
+++ b/arch/arm/mach-qcom/scm-boot.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/arch/arm/mach-qcom/scm-boot.h b/arch/arm/mach-qcom/scm-boot.h
index 7be32ff..b8a1aba 100644
--- a/arch/arm/mach-qcom/scm-boot.h
+++ b/arch/arm/mach-qcom/scm-boot.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index c536fd6..21d69c1 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
diff --git a/arch/arm/mach-qcom/scm.h b/arch/arm/mach-qcom/scm.h
index 00b31ea..979f549 100644
--- a/arch/arm/mach-qcom/scm.h
+++ b/arch/arm/mach-qcom/scm.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

