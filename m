Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaB1HJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:09:37 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41881 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaB1HJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:09:34 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging: cxt1e1: remove space between function name and parenthesis
Date: Fri, 28 Feb 2014 16:09:29 +0900
Message-ID: <1583984.3tLQeI2kmp@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl warnings:
 WARNING: space prohibited between function name
 and open parenthesis '('

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |  120 +++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 07de83f..5e93580 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -36,15 +36,15 @@ extern int  error_flag;
 extern int  drvr_state;
 
 /* forward references */
-void        c4_stopwd (ci_t *);
-struct net_device * __init c4_add_dev (hdw_info_t *, int, unsigned long, unsigned long, int, int);
+void        c4_stopwd(ci_t *);
+struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long, unsigned long, int, int);
 
 
 struct s_hdw_info hdw_info[MAX_BOARDS];
 
 
 void        __init
-show_two (hdw_info_t *hi, int brdno)
+show_two(hdw_info_t *hi, int brdno)
 {
     ci_t       *ci;
     struct pci_dev *pdev;
@@ -52,26 +52,26 @@ show_two (hdw_info_t *hi, int brdno)
     char       banner[80];
     char        sn[6];
 
-    memset (banner, 0, 80);         /* clear print buffer */
+    memset(banner, 0, 80);         /* clear print buffer */
 
     ci = (ci_t *)(netdev_priv(hi->ndev));
-    bid = sbeid_get_bdname (ci);
+    bid = sbeid_get_bdname(ci);
     switch (hi->promfmt)
     {
     case PROM_FORMAT_TYPE1:
-        memcpy (sn, (FLD_TYPE1 *) (hi->mfg_info.pft1.Serial), 6);
+        memcpy(sn, (FLD_TYPE1 *)(hi->mfg_info.pft1.Serial), 6);
         break;
     case PROM_FORMAT_TYPE2:
-        memcpy (sn, (FLD_TYPE2 *) (hi->mfg_info.pft2.Serial), 6);
+        memcpy(sn, (FLD_TYPE2 *)(hi->mfg_info.pft2.Serial), 6);
         break;
     default:
-        memset (sn, 0, 6);
+        memset(sn, 0, 6);
         break;
     }
 
-    sprintf (banner, "%s: %s  S/N %06X, MUSYCC Rev %02X",
-             hi->devname, bid,
-             ((sn[3] << 16) & 0xff0000) |
+    sprintf(banner, "%s: %s  S/N %06X, MUSYCC Rev %02X",
+            hi->devname, bid,
+            ((sn[3] << 16) & 0xff0000) |
               ((sn[4] << 8) & 0x00ff00) |
               (sn[5] & 0x0000ff),
              (u_int8_t) hi->revid[0]);
@@ -82,20 +82,20 @@ show_two (hdw_info_t *hi, int brdno)
     pr_info("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
             hi->devname, "MUSYCC",
             (unsigned long) hi->addr_mapped[0], hi->addr[0],
-            hi->pci_busno, (u_int8_t) PCI_SLOT (pdev->devfn),
-            (u_int8_t) PCI_FUNC (pdev->devfn), pdev->irq);
+            hi->pci_busno, (u_int8_t)PCI_SLOT(pdev->devfn),
+            (u_int8_t)PCI_FUNC(pdev->devfn), pdev->irq);
 
     pdev = hi->pdev[1];
     pr_info("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
             hi->devname, "EBUS  ",
             (unsigned long) hi->addr_mapped[1], hi->addr[1],
-            hi->pci_busno, (u_int8_t) PCI_SLOT (pdev->devfn),
-            (u_int8_t) PCI_FUNC (pdev->devfn), pdev->irq);
+            hi->pci_busno, (u_int8_t)PCI_SLOT(pdev->devfn),
+            (u_int8_t)PCI_FUNC(pdev->devfn), pdev->irq);
 }
 
 
 void        __init
-hdw_sn_get (hdw_info_t *hi, int brdno)
+hdw_sn_get(hdw_info_t *hi, int brdno)
 {
     /* obtain hardware EEPROM information */
     long        addr;
@@ -103,7 +103,7 @@ hdw_sn_get (hdw_info_t *hi, int brdno)
     addr = (long) hi->addr_mapped[1] + EEPROM_OFFSET;
 
     /* read EEPROM with largest known format size... */
-    pmc_eeprom_read_buffer (addr, 0, (char *) hi->mfg_info.data, sizeof (FLD_TYPE2));
+    pmc_eeprom_read_buffer(addr, 0, (char *)hi->mfg_info.data, sizeof(FLD_TYPE2));
 
 #if 0
     {
@@ -133,7 +133,7 @@ hdw_sn_get (hdw_info_t *hi, int brdno)
             hi->mfg_info.Serial[5]);
 #endif
 
-    if ((hi->promfmt = pmc_verify_cksum (&hi->mfg_info.data)) == PROM_FORMAT_Unk)
+    if ((hi->promfmt = pmc_verify_cksum(&hi->mfg_info.data)) == PROM_FORMAT_Unk)
     {
         /* bad crc, data is suspect */
         if (cxt1e1_log_level >= LOG_WARN)
@@ -145,7 +145,7 @@ hdw_sn_get (hdw_info_t *hi, int brdno)
 
 
 void        __init
-prep_hdw_info (void)
+prep_hdw_info(void)
 {
     hdw_info_t *hi;
     int         i;
@@ -165,7 +165,7 @@ prep_hdw_info (void)
 }
 
 void
-cleanup_ioremap (void)
+cleanup_ioremap(void)
 {
     hdw_info_t *hi;
     int         i;
@@ -176,14 +176,14 @@ cleanup_ioremap (void)
             break;
         if (hi->addr_mapped[0])
         {
-            iounmap ((void *) (hi->addr_mapped[0]));
-            release_mem_region ((long) hi->addr[0], hi->len[0]);
+            iounmap((void *)(hi->addr_mapped[0]));
+            release_mem_region((long) hi->addr[0], hi->len[0]);
             hi->addr_mapped[0] = 0;
         }
         if (hi->addr_mapped[1])
         {
-            iounmap ((void *) (hi->addr_mapped[1]));
-            release_mem_region ((long) hi->addr[1], hi->len[1]);
+            iounmap((void *)(hi->addr_mapped[1]));
+            release_mem_region((long) hi->addr[1], hi->len[1]);
             hi->addr_mapped[1] = 0;
         }
     }
@@ -191,7 +191,7 @@ cleanup_ioremap (void)
 
 
 void
-cleanup_devs (void)
+cleanup_devs(void)
 {
     hdw_info_t *hi;
     int         i;
@@ -204,18 +204,18 @@ cleanup_devs (void)
 #ifdef CONFIG_PROC_FS
         sbecom_proc_brd_cleanup(netdev_priv(hi->ndev));
 #endif
-        unregister_netdev (hi->ndev);
-        free_irq (hi->pdev[0]->irq, hi->ndev);
+        unregister_netdev(hi->ndev);
+        free_irq(hi->pdev[0]->irq, hi->ndev);
 #ifdef CONFIG_SBE_PMCC4_NCOMM
-        free_irq (hi->pdev[1]->irq, hi->ndev);
+        free_irq(hi->pdev[1]->irq, hi->ndev);
 #endif
-        OS_kfree (hi->ndev);
+        OS_kfree(hi->ndev);
     }
 }
 
 
 static int  __init
-c4_hdw_init (struct pci_dev *pdev, int found)
+c4_hdw_init(struct pci_dev *pdev, int found)
 {
     hdw_info_t *hi;
     int         i;
@@ -223,7 +223,7 @@ c4_hdw_init (struct pci_dev *pdev, int found)
     unsigned char busno = 0xff;
 
     /* our MUSYCC chip supports two functions, 0 & 1 */
-    if ((fun = PCI_FUNC (pdev->devfn)) > 1)
+    if ((fun = PCI_FUNC(pdev->devfn)) > 1)
     {
         pr_warning("unexpected devfun: 0x%x\n", pdev->devfn);
         return 0;
@@ -262,11 +262,11 @@ c4_hdw_init (struct pci_dev *pdev, int found)
     else
         hi->pci_busno = 0;          /* default for system PCI inconsistency */
     hi->pci_slot = slot;
-    pci_read_config_byte (pdev, PCI_INTERRUPT_PIN, &hi->pci_pin[fun]);
-    pci_read_config_byte (pdev, PCI_REVISION_ID, &hi->revid[fun]);
+    pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &hi->pci_pin[fun]);
+    pci_read_config_byte(pdev, PCI_REVISION_ID, &hi->revid[fun]);
     hi->bus = pdev->bus;
-    hi->addr[fun] = pci_resource_start (pdev, 0);
-    hi->len[fun] = pci_resource_end (pdev, 0) - hi->addr[fun] + 1;
+    hi->addr[fun] = pci_resource_start(pdev, 0);
+    hi->len[fun] = pci_resource_end(pdev, 0) - hi->addr[fun] + 1;
     hi->pdev[fun] = pdev;
 
     {
@@ -276,8 +276,8 @@ c4_hdw_init (struct pci_dev *pdev, int found)
          */
         char       *cp = hi->devname;
 
-        strcpy (cp, KBUILD_MODNAME);
-        cp += strlen (cp);          /* reposition */
+        strcpy(cp, KBUILD_MODNAME);
+        cp += strlen(cp);          /* reposition */
         *cp++ = '-';
         *cp++ = '0' + (found / 2);  /* there are two found interfaces per
                                      * board */
@@ -289,20 +289,20 @@ c4_hdw_init (struct pci_dev *pdev, int found)
 
 
 status_t    __init
-c4hw_attach_all (void)
+c4hw_attach_all(void)
 {
     hdw_info_t *hi;
     struct pci_dev *pdev = NULL;
     int         found = 0, i, j;
 
     error_flag = 0;
-    prep_hdw_info ();
+    prep_hdw_info();
     /*** scan PCI bus for all possible boards */
-    while ((pdev = pci_get_device (PCI_VENDOR_ID_CONEXANT,
-                                    PCI_DEVICE_ID_CN8474,
-                                    pdev)))
+    while ((pdev = pci_get_device(PCI_VENDOR_ID_CONEXANT,
+                                  PCI_DEVICE_ID_CN8474,
+                                  pdev)))
     {
-        if (c4_hdw_init (pdev, found))
+        if (c4_hdw_init(pdev, found))
             found++;
     }
     if (!found)
@@ -327,19 +327,19 @@ c4hw_attach_all (void)
             break;
         for (j = 0; j < 2; j++)
         {
-	    if (!request_mem_region (hi->addr[j], hi->len[j], hi->devname))
+	    if (!request_mem_region(hi->addr[j], hi->len[j], hi->devname))
             {
                 pr_warning("%s: memory in use, addr=0x%lx, len=0x%lx ?\n",
                            hi->devname, hi->addr[j], hi->len[j]);
-                cleanup_ioremap ();
+                cleanup_ioremap();
                 return -ENOMEM;
             }
-            hi->addr_mapped[j] = (unsigned long) ioremap (hi->addr[j], hi->len[j]);
+            hi->addr_mapped[j] = (unsigned long)ioremap(hi->addr[j], hi->len[j]);
             if (!hi->addr_mapped[j])
             {
                 pr_warning("%s: ioremap fails, addr=0x%lx, len=0x%lx ?\n",
                            hi->devname, hi->addr[j], hi->len[j]);
-                cleanup_ioremap ();
+                cleanup_ioremap();
                 return -ENOMEM;
             }
 #ifdef SBE_MAP_DEBUG
@@ -356,32 +356,32 @@ c4hw_attach_all (void)
     {
         if (hi->pci_slot == 0xff)
             break;
-        if (pci_enable_device (hi->pdev[0]) ||
-            pci_enable_device (hi->pdev[1]))
+        if (pci_enable_device(hi->pdev[0]) ||
+            pci_enable_device(hi->pdev[1]))
         {
             drvr_state = SBE_DRVR_DOWN;
             pr_warning("%s: failed to enable card %d slot %d\n",
                        hi->devname, i, hi->pci_slot);
-            cleanup_devs ();
-            cleanup_ioremap ();
+            cleanup_devs();
+            cleanup_ioremap();
             return -EIO;
         }
-        pci_set_master (hi->pdev[0]);
-        pci_set_master (hi->pdev[1]);
-        if (!(hi->ndev = c4_add_dev (hi, i, (long) hi->addr_mapped[0],
-                                     (long) hi->addr_mapped[1],
-                                     hi->pdev[0]->irq,
-                                     hi->pdev[1]->irq)))
+        pci_set_master(hi->pdev[0]);
+        pci_set_master(hi->pdev[1]);
+        if (!(hi->ndev = c4_add_dev(hi, i, (long) hi->addr_mapped[0],
+                                    (long) hi->addr_mapped[1],
+                                    hi->pdev[0]->irq,
+                                    hi->pdev[1]->irq)))
         {
             drvr_state = SBE_DRVR_DOWN;
-            cleanup_ioremap ();
+            cleanup_ioremap();
             /* NOTE: c4_add_dev() does its own device cleanup */
 #if 0
-            cleanup_devs ();
+            cleanup_devs();
 #endif
             return error_flag;      /* error_flag set w/in add_dev() */
         }
-        show_two (hi, i);           /* displays found information */
+        show_two(hi, i);           /* displays found information */
     }
     return 0;
 }
-- 
1.7.9.5

---
