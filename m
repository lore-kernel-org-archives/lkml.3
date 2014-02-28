Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaB1HM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:12:27 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34201 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaB1HM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:12:26 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, dulshani.gunawardhana89@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shaun@xresource.ca
Subject: [PATCH 3/5] Staging: cxt1e1: Fix line length over 80 characters in hwprobe.c
Date: Fri, 28 Feb 2014 16:12:22 +0900
Message-ID: <1978948.javkNJXx5G@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


clean up checkpatch.pl warnings:
 WARNING: Line length over 80 characters

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/hwprobe.c |   45 
++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c 
b/drivers/staging/cxt1e1/hwprobe.c
index 85040bb..d6ccbd9 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -37,7 +37,8 @@ extern int  drvr_state;
 
 /* forward references */
 void        c4_stopwd(ci_t *);
-struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long, 
unsigned long, int, int);
+struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long,
+				      unsigned long, int, int);
 
 
 struct s_hdw_info hdw_info[MAX_BOARDS];
@@ -104,24 +105,31 @@ hdw_sn_get(hdw_info_t *hi, int brdno)
 	addr = (long) hi->addr_mapped[1] + EEPROM_OFFSET;
 
 	/* read EEPROM with largest known format size... */
-	pmc_eeprom_read_buffer(addr, 0, (char *)hi->mfg_info.data, 
sizeof(FLD_TYPE2));
+	pmc_eeprom_read_buffer(addr, 0, (char *)hi->mfg_info.data,
+			       sizeof(FLD_TYPE2));
 
 #if 0
 	{
 		unsigned char *ucp = (unsigned char *) &hi->mfg_info.data;
 
 		pr_info("eeprom[00]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3), *(ucp + 4), 
*(ucp + 5), *(ucp + 6), *(ucp + 7));
+			*(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3),
+			*(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
 		pr_info("eeprom[08]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11), *(ucp + 12), 
*(ucp + 13), *(ucp + 14), *(ucp + 15));
+			*(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11),
+			*(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
 		pr_info("eeprom[16]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19), *(ucp + 
20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
+			*(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19),
+			*(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
 		pr_info("eeprom[24]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27), *(ucp + 
28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
+			*(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27),
+			*(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
 		pr_info("eeprom[32]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35), *(ucp + 
36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
+			*(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35),
+			*(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
 		pr_info("eeprom[40]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
-				*(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43), *(ucp + 
44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
+			*(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43),
+			*(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
 	}
 #endif
 #if 0
@@ -230,10 +238,11 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 		return 0;
 	}
 
-	if (pdev->bus)                  /* obtain bus number */
+	/* obtain bus number */
+	if (pdev->bus)
 		busno = pdev->bus->number;
 	else
-		busno = 0;                  /* default for system PCI inconsistency */
+		busno = 0; /* default for system PCI inconsistency */
 	slot = pdev->devfn & ~0x07;
 
 	/*
@@ -246,8 +255,8 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	for (i = 0, hi = hdw_info; i < MAX_BOARDS; i++, hi++)
 	{
 		/*
-		 * match with board's first found interface, otherwise this is first
-		 * found
+		 * match with board's first found interface, otherwise this is
+		 * fisrt found
 		 */
 		if ((hi->pci_slot == 0xff) ||   /* new board */
 		    ((hi->pci_slot == slot) && (hi->bus == pdev->bus)))
@@ -256,13 +265,14 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	if (i == MAX_BOARDS)            /* no match in above loop means MAX
 					 * exceeded */
 	{
-		pr_warning("exceeded number of allowed devices (>%d)?\n", MAX_BOARDS);
+		pr_warning("exceeded number of allowed devices (>%d)?\n",
+			   MAX_BOARDS);
 		return 0;
 	}
 	if (pdev->bus)
 		hi->pci_busno = pdev->bus->number;
 	else
-		hi->pci_busno = 0;          /* default for system PCI inconsistency */
+		hi->pci_busno = 0; /* default for system PCI inconsistency */
 	hi->pci_slot = slot;
 	pci_read_config_byte(pdev, PCI_INTERRUPT_PIN, &hi->pci_pin[fun]);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &hi->revid[fun]);
@@ -345,7 +355,8 @@ c4hw_attach_all(void)
 			}
 #ifdef SBE_MAP_DEBUG
 			pr_warning("%s: io remapped from phys %x to virt %x\n",
-				   hi->devname, (u_int32_t) hi->addr[j], (u_int32_t) hi-
>addr_mapped[j]);
+				   hi->devname, (u_int32_t) hi->addr[j],
+				   (u_int32_t) hi->addr_mapped[j]);
 #endif
 		}
 	}
@@ -380,9 +391,9 @@ c4hw_attach_all(void)
 #if 0
 			cleanup_devs();
 #endif
-			return error_flag;      /* error_flag set w/in add_dev() */
+			return error_flag; /* error_flag set w/in add_dev() */
 		}
-		show_two(hi, i);           /* displays found information */
+		show_two(hi, i); /* displays found information */
 	}
 	return 0;
 }
-- 
1.7.9.5

---
