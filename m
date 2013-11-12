Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3KLJni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:43:38 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43994 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3KLJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:43:31 -0500
From: Eric Skoglund <ericskog@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, dulshani.gunawardhana89@gmail.com,
        sachin.kamat@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Eric Skoglund <eric@pagefault.se>
Subject: [PATCH 3/3] Drivers: Staging: cxt1e1: stbeid: Fixed whitespace between function and parameters
Date: Tue, 12 Nov 2013 10:42:23 +0100
Message-Id: <1384249343-10468-3-git-send-email-ericskog@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384249343-10468-1-git-send-email-ericskog@gmail.com>
References: <1384249343-10468-1-git-send-email-ericskog@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Skoglund <eric@pagefault.se>

This patch fixes whitespace coding style errors: func () --> func()

Signed-of-by: Eric Skoglund <eric@pagefault.se>
---
 drivers/staging/cxt1e1/sbeid.c | 84 +++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeid.c b/drivers/staging/cxt1e1/sbeid.c
index bf6c943..97c5c6e 100644
--- a/drivers/staging/cxt1e1/sbeid.c
+++ b/drivers/staging/cxt1e1/sbeid.c
@@ -20,36 +20,36 @@
 #include "sbe_bid.h"
 
 char       *
-sbeid_get_bdname (ci_t *ci)
+sbeid_get_bdname(ci_t *ci)
 {
 	char       *np = NULL;
 
 	switch (ci->brd_id) {
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
 		np = "wanPTMC-256T3 <E1>";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
 		np = "wanPTMC-256T3 <T1>";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
 		np = "wanPMC-C4T1E1";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
 		np = "wanPMC-C2T1E1";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
 		np = "wanPMC-C1T1E1";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
 		np = "wanPCI-C4T1E1";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
 		np = "wanPCI-C2T1E1";
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
 		np = "wanPCI-C1T1E1";
 		break;
 	default:
@@ -65,7 +65,7 @@ sbeid_get_bdname (ci_t *ci)
 /* given the presetting of brd_id, set the corresponding hdw_id */
 
 void
-sbeid_set_hdwbid (ci_t *ci)
+sbeid_set_hdwbid(ci_t *ci)
 {
 	/*
 	 * set SBE's unique hardware identification (for legacy boards might not
@@ -73,16 +73,16 @@ sbeid_set_hdwbid (ci_t *ci)
 	 */
 
 	switch (ci->brd_id) {
-        case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
 		ci->hdw_bid = SBE_BID_256T3_E1; /* 0x46 - SBE wanPTMC-256T3 (E1
 						 * Version) */
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
 		ci->hdw_bid = SBE_BID_256T3_T1; /* 0x42 - SBE wanPTMC-256T3 (T1
 						 * Version) */
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
 		/*
 		 * This Board ID is a generic identification.  Use the found number
 		 * of ports to further define this hardware.
@@ -95,20 +95,20 @@ sbeid_set_hdwbid (ci_t *ci)
 			break;
 		case 2:
 			ci->hdw_bid = SBE_BID_PMC_C2T1E1;   /* 0xC2 - SBE wanPMC-C2T1E1 */
-			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
+			ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
 			break;
 		case 1:
 			ci->hdw_bid = SBE_BID_PMC_C1T1E1;   /* 0xC1 - SBE wanPMC-C1T1E1 */
-			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
+			ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
 			break;
 		}
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
 		ci->hdw_bid = SBE_BID_PMC_C2T1E1;       /* 0xC2 - SBE wanPMC-C2T1E1 */
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
 		ci->hdw_bid = SBE_BID_PMC_C1T1E1;       /* 0xC1 - SBE wanPMC-C1T1E1 */
 		break;
 #ifdef SBE_PMCC4_ENABLE
@@ -119,10 +119,10 @@ sbeid_set_hdwbid (ci_t *ci)
 		 */
 	case 0:
 		/* start by assuming 4-port for ZERO casing */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
 		/* drop thru to set hdw_bid and alternate PCI CxT1E1 settings */
 #endif
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
 		/*
 		 * This Board ID is a generic identification.  Use the number of
 		 * found ports to further define this hardware.
@@ -135,18 +135,18 @@ sbeid_set_hdwbid (ci_t *ci)
 			break;
 		case 2:
 			ci->hdw_bid = SBE_BID_PCI_C2T1E1;   /* 0x02 - SBE wanPCI-C2T1E1 */
-			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
+			ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
 			break;
 		case 1:
 			ci->hdw_bid = SBE_BID_PCI_C1T1E1;   /* 0x01 - SBE wanPCI-C1T1E1 */
-			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
+			ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
 			break;
 		}
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
 		ci->hdw_bid = SBE_BID_PCI_C2T1E1;       /* 0x02 - SBE wanPCI-C2T1E1 */
 		break;
-	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
 		ci->hdw_bid = SBE_BID_PCI_C1T1E1;       /* 0x01 - SBE wanPCI-C1T1E1 */
 		break;
 	default:
@@ -159,44 +159,44 @@ sbeid_set_hdwbid (ci_t *ci)
 /* given the presetting of hdw_bid, set the corresponding brd_id */
 
 void
-sbeid_set_bdtype (ci_t *ci)
+sbeid_set_bdtype(ci_t *ci)
 {
 	/* set SBE's unique PCI VENDOR/DEVID */
 	switch (ci->hdw_bid) {
-        case SBE_BID_C1T3:      /* SBE wanPMC-C1T3 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3);
+	case SBE_BID_C1T3:      /* SBE wanPMC-C1T3 */
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3);
 		break;
 	case SBE_BID_C24TE1:            /* SBE wanPTMC-C24TE1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1);
 		break;
 	case SBE_BID_256T3_E1:          /* SBE wanPTMC-256T3 E1 Version */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1);
 		break;
 	case SBE_BID_256T3_T1:          /* SBE wanPTMC-256T3 T1 Version */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1);
 		break;
 	case SBE_BID_PMC_C4T1E1:        /* 0xC4 - SBE wanPMC-C4T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1);
 		break;
 	case SBE_BID_PMC_C2T1E1:        /* 0xC2 - SBE wanPMC-C2T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
 		break;
 	case SBE_BID_PMC_C1T1E1:        /* 0xC1 - SBE wanPMC-C1T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
 		break;
 	case SBE_BID_PCI_C4T1E1:        /* 0x04 - SBE wanPCI-C4T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
 		break;
 	case SBE_BID_PCI_C2T1E1:        /* 0x02 - SBE wanPCI-C2T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
 		break;
 	case SBE_BID_PCI_C1T1E1:        /* 0x01 - SBE wanPCI-C1T1E1 */
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
 		break;
 
 	default:
 		/*** hdw_bid = "<unknown>";  ***/
-		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		ci->brd_id = SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
 		break;
 	}
 }
-- 
1.8.3.1

