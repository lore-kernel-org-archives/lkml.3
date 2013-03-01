Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3CAUNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:13:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3CATpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [ 65/77] ab8500-chargalg: Only root should have write permission on sysfs file
Date: Fri,  1 Mar 2013 11:44:50 -0800
Message-Id: <20130301194358.849093982@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee.jones@linaro.org>

commit e3455002d04276c256a531f7175dce0f7d1cb78a upstream.

Only root should have write permission on sysfs file ab8500_chargalg/chargalg.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/abx500_chargalg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1698,7 +1698,7 @@ static ssize_t abx500_chargalg_sysfs_cha
 static struct attribute abx500_chargalg_en_charger = \
 {
 	.name = "chargalg",
-	.mode = S_IWUGO,
+	.mode = S_IWUSR,
 };
 
 static struct attribute *abx500_chargalg_chg[] = {


