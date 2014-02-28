Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaB1CG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 21:06:57 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45659 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB1CGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 21:06:55 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cxt1e1: remove unused variable
Date: Fri, 28 Feb 2014 11:06:50 +0900
Message-ID: <1933280.Qmju879bY8@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 02b4f8f..07de83f 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -49,10 +49,9 @@ show_two (hdw_info_t *hi, int brdno)
     ci_t       *ci;
     struct pci_dev *pdev;
     char       *bid;
-    char       *bp, banner[80];
+    char       banner[80];
     char        sn[6];
 
-    bp = banner;
     memset (banner, 0, 80);         /* clear print buffer */
 
     ci = (ci_t *)(netdev_priv(hi->ndev));
-- 
1.7.9.5

---
