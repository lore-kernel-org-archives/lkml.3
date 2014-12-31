Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaLaM1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:27:43 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46584 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaLaM1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:27:19 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Sudip Mukherjee <sudip@vectorindia.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 2/3] staging: sm7xxfb: update TODO file
Date: Wed, 31 Dec 2014 17:56:44 +0530
Message-Id: <1420028805-30488-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update the email addresses in the TODO file, also update the final
destination of this driver. 

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/sm7xxfb/TODO | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sm7xxfb/TODO b/drivers/staging/sm7xxfb/TODO
index 1fcead5..6377380 100644
--- a/drivers/staging/sm7xxfb/TODO
+++ b/drivers/staging/sm7xxfb/TODO
@@ -3,7 +3,10 @@ TODO:
 - 2D acceleration support
 - use kernel coding style
 - refine the code and remove unused code
-- move it to drivers/video/sm7xxfb.c
+- move it to drivers/video/fbdev/sm7xxfb.c
 
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
-Teddy Wang <teddy.wang@siliconmotion.com.cn>.
+Please send any patches to
+	Greg Kroah-Hartman <greg@kroah.com>
+	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
+	Teddy Wang <teddy.wang@siliconmotion.com>
+	Sudip Mukherjee <sudip@vectorindia.org>
-- 
1.9.1

