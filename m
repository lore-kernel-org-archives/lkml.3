Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaDMTN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 15:13:29 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:46749 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 15:13:28 -0400
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Apr 2014 21:13:27 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534AE1D6.1040304@orange.fr>
Date: Sun, 13 Apr 2014 21:13:26 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Subject: [PATCH v2 2/3] Fix coding style problem (cast with space) in drivers/staging/crystalhd/crystalhd_lnx.c
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
In-Reply-To: <20140413154859.GA18189@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pascal COMBES <pascom@orange.fr>

Fix coding style problem in drivers/staging/crystalhd/crystalhd_lnx.c:
No space needed before a cast.

Signed-off-by: Pascal COMBES <pascom@orange.fr>
---
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index fd7f08a..15e8f02 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
 
 static irqreturn_t chd_dec_isr(int irq, void *arg)
 {
-	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
+	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;
 	int rc = 0;
 	if (adp)
 		rc = crystalhd_cmd_interrupt(&adp->cmds);

