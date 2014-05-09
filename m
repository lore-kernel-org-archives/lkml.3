Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbaEIKJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:09:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53603 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756633AbaEIKJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:34 -0400
X-Sasl-enc: aWfNnAVxwAX8kd5ZZoCF5yaEkE9agM8dkEEa3l4qk4Ky 1399630173
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 10/10] staging: gdm72xx: Remove task from TODO list 
Date: Fri,  9 May 2014 18:08:29 +0800
Message-Id: <1399630109-18701-10-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed line related to replacement of kernel_thread with kthread,
as issue was fixed on ff5e4a1d2702 ('Staging: gdm72xx: gdm_usb:
fix deprecated function kernel_thread')

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/TODO b/drivers/staging/gdm72xx/TODO
index 5ab27fb..62d0cd6 100644
--- a/drivers/staging/gdm72xx/TODO
+++ b/drivers/staging/gdm72xx/TODO
@@ -1,3 +1,2 @@
 TODO:
-- Replace kernel_thread with kthread in gdm_usb.c
 - Clean up coding style to meet kernel standard.
-- 
1.8.4

