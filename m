Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaDZPxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:53:33 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:55977 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaDZPxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:53:32 -0400
Date: Sat, 26 Apr 2014 18:53:15 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: daeseok.youn@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH next-20140424] staging/cxt1e1: sparse warning corrections
Message-ID: <20140426155315.GA4745@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Corrected sparse static declaration warnings.

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---    
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index cc2151e..2899258 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -40,10 +40,10 @@ struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long,
 				      unsigned long, int, int);
 
 
-struct s_hdw_info hdw_info[MAX_BOARDS];
+static struct s_hdw_info hdw_info[MAX_BOARDS];
 
 
-void __init
+static void __init
 show_two(hdw_info_t *hi, int brdno)
 {
 	ci_t       *ci;
@@ -88,7 +88,7 @@ show_two(hdw_info_t *hi, int brdno)
 }
 
 
-void __init
+static void __init
 hdw_sn_get(hdw_info_t *hi, int brdno)
 {
 	/* obtain hardware EEPROM information */
@@ -145,7 +145,7 @@ hdw_sn_get(hdw_info_t *hi, int brdno)
 }
 
 
-	void __init
+static void __init
 prep_hdw_info(void)
 {
 	hdw_info_t *hi;
@@ -164,7 +164,7 @@ prep_hdw_info(void)
 	}
 }
 
-void
+static void
 cleanup_ioremap(void)
 {
 	hdw_info_t *hi;
@@ -187,7 +187,7 @@ cleanup_ioremap(void)
 }
 
 
-void
+static void
 cleanup_devs(void)
 {
 	hdw_info_t *hi;
@@ -287,7 +287,7 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	return 1;
 }
 
-status_t __init
+static status_t __init
 c4hw_attach_all(void)
 {
 	hdw_info_t *hi;
