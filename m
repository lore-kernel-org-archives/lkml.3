Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3ENSWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:22:25 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:56652 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3ENSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:22:12 -0400
Date: Tue, 14 May 2013 11:15:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH libata/for-3.10-fixes] libata: update "Maintained by:" tags
Message-ID: <20130514181531.GM6795@mtj.dyndns.org>
References: <20130507171921.GB5531@mtj.dyndns.org>
 <51896BDF.5070101@pobox.com>
 <20130507213011.GA14082@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507213011.GA14082@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Removed Linus from cc)

The following patch has been applied to libata/for-3.10-fixes.  Will
push out to Linus with the next batch of updates.

Thanks!

>From 8c3d3d4b12bf8de8c59fe1eb1bf866a8676ca309 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 14 May 2013 11:09:50 -0700

Jeff moved on to a greener pasture.

 s/Maintained by: Jeff Garzik/Maintained by: Tejun Heo/g

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/ata/acard-ahci.c   | 2 +-
 drivers/ata/ahci.c         | 2 +-
 drivers/ata/ahci.h         | 2 +-
 drivers/ata/ata_piix.c     | 2 +-
 drivers/ata/libahci.c      | 2 +-
 drivers/ata/libata-core.c  | 2 +-
 drivers/ata/libata-eh.c    | 2 +-
 drivers/ata/libata-scsi.c  | 2 +-
 drivers/ata/libata-sff.c   | 2 +-
 drivers/ata/pdc_adma.c     | 2 +-
 drivers/ata/sata_promise.c | 2 +-
 drivers/ata/sata_sil.c     | 2 +-
 drivers/ata/sata_sx4.c     | 2 +-
 drivers/ata/sata_via.c     | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/acard-ahci.c b/drivers/ata/acard-ahci.c
index 4e94ba2..9d0cf01 100644
--- a/drivers/ata/acard-ahci.c
+++ b/drivers/ata/acard-ahci.c
@@ -2,7 +2,7 @@
 /*
  *  acard-ahci.c - ACard AHCI SATA support
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 251e57d..2180876 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1,7 +1,7 @@
 /*
  *  ahci.c - AHCI SATA support
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b830e6c..10b14d4 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -1,7 +1,7 @@
 /*
  *  ahci.h - Common AHCI SATA definitions and declarations
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 2f48123..26bda6e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1,7 +1,7 @@
 /*
  *    ata_piix.c - Intel PATA/SATA controllers
  *
- *    Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 34c8216..a70ff15 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1,7 +1,7 @@
 /*
  *  libahci.c - Common AHCI SATA low-level routines
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 63c743b..d35524c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1,7 +1,7 @@
 /*
  *  libata-core.c - helper library for ATA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index f9476fb..c69fcce 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1,7 +1,7 @@
 /*
  *  libata-eh.c - libata error handling
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dd310b27..0101af5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1,7 +1,7 @@
 /*
  *  libata-scsi.c - helper library for ATA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index d8af325..b603720 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1,7 +1,7 @@
 /*
  *  libata-sff.c - helper library for PCI IDE BMDMA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 5053333..8ea6e6a 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -1,7 +1,7 @@
 /*
  *  pdc_adma.c - Pacific Digital Corporation ADMA
  *
- *  Maintained by:  Mark Lord <mlord@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *
  *  Copyright 2005 Mark Lord
  *
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index fb0dd87..958ba2a 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -1,7 +1,7 @@
 /*
  *  sata_promise.c - Promise SATA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *		    Mikael Pettersson <mikpe@it.uu.se>
  *  		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index a7b3167..0ae3ca4 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -1,7 +1,7 @@
 /*
  *  sata_sil.c - Silicon Image SATA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *  		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 7b7127a..9947010 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1,7 +1,7 @@
 /*
  *  sata_sx4.c - Promise SATA
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  *  		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 5913ea9..87f056e 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -1,7 +1,7 @@
 /*
  *  sata_via.c - VIA Serial ATA controllers
  *
- *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *  Maintained by:  Tejun Heo <tj@kernel.org>
  * 		   Please ALWAYS copy linux-ide@vger.kernel.org
  *		   on emails.
  *
-- 
1.8.1.4

