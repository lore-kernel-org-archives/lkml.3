Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3KLJnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:43:33 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:40508 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3KLJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:43:30 -0500
From: Eric Skoglund <ericskog@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shaun@xresource.ca, dulshani.gunawardhana89@gmail.com,
        sachin.kamat@linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Eric Skoglund <eric@pagefault.se>
Subject: [PATCH 1/3] Drivers: Staging: cxt1e1: sbeid: Fixed coding style issue - space -> tabs
Date: Tue, 12 Nov 2013 10:42:21 +0100
Message-Id: <1384249343-10468-1-git-send-email-ericskog@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Skoglund <eric@pagefault.se>

This patch converts spaces to tabs to conform to the coding style standards.

Signed-off-by: Eric Skoglund <eric@pagefault.se>
---
 drivers/staging/cxt1e1/sbeid.c | 318 ++++++++++++++++++++---------------------
 1 file changed, 159 insertions(+), 159 deletions(-)

diff --git a/drivers/staging/cxt1e1/sbeid.c b/drivers/staging/cxt1e1/sbeid.c
index 6ec51bc..75efbc3 100644
--- a/drivers/staging/cxt1e1/sbeid.c
+++ b/drivers/staging/cxt1e1/sbeid.c
@@ -22,44 +22,44 @@
 char       *
 sbeid_get_bdname (ci_t *ci)
 {
-    char       *np = NULL;
+	char       *np = NULL;
 
-    switch (ci->brd_id)
-    {
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
-        np = "wanPTMC-256T3 <E1>";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
-        np = "wanPTMC-256T3 <T1>";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
-        np = "wanPMC-C4T1E1";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
-        np = "wanPMC-C2T1E1";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
-        np = "wanPMC-C1T1E1";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
-        np = "wanPCI-C4T1E1";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
-        np = "wanPCI-C2T1E1";
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
-        np = "wanPCI-C1T1E1";
-        break;
-    default:
-        /*** np = "<unknown>";  ***/
-        np = "wanPCI-CxT1E1";
-        break;
-    }
+	switch (ci->brd_id)
+	{
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
+		np = "wanPTMC-256T3 <E1>";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
+		np = "wanPTMC-256T3 <T1>";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
+		np = "wanPMC-C4T1E1";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
+		np = "wanPMC-C2T1E1";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
+		np = "wanPMC-C1T1E1";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
+		np = "wanPCI-C4T1E1";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
+		np = "wanPCI-C2T1E1";
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
+		np = "wanPCI-C1T1E1";
+		break;
+	default:
+		/*** np = "<unknown>";  ***/
+		np = "wanPCI-CxT1E1";
+		break;
+	}
 
-    return np;
+	return np;
 }
 
 
@@ -68,96 +68,96 @@ sbeid_get_bdname (ci_t *ci)
 void
 sbeid_set_hdwbid (ci_t *ci)
 {
-    /*
-     * set SBE's unique hardware identification (for legacy boards might not
-     * have this register implemented)
-     */
+	/*
+	 * set SBE's unique hardware identification (for legacy boards might not
+	 * have this register implemented)
+	 */
 
-    switch (ci->brd_id)
-    {
+	switch (ci->brd_id)
+	{
         case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
-        ci->hdw_bid = SBE_BID_256T3_E1; /* 0x46 - SBE wanPTMC-256T3 (E1
-                                         * Version) */
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
-        ci->hdw_bid = SBE_BID_256T3_T1; /* 0x42 - SBE wanPTMC-256T3 (T1
-                                         * Version) */
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
-        /*
-         * This Board ID is a generic identification.  Use the found number
-         * of ports to further define this hardware.
-         */
-        switch (ci->max_port)
-        {
-        default:                    /* shouldn't need a default, but have one
-                                     * anyway */
-        case 4:
-            ci->hdw_bid = SBE_BID_PMC_C4T1E1;   /* 0xC4 - SBE wanPMC-C4T1E1 */
-            break;
-        case 2:
-            ci->hdw_bid = SBE_BID_PMC_C2T1E1;   /* 0xC2 - SBE wanPMC-C2T1E1 */
-            ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
-            break;
-        case 1:
-            ci->hdw_bid = SBE_BID_PMC_C1T1E1;   /* 0xC1 - SBE wanPMC-C1T1E1 */
-            ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
-            break;
-        }
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
-        ci->hdw_bid = SBE_BID_PMC_C2T1E1;       /* 0xC2 - SBE wanPMC-C2T1E1 */
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
-        ci->hdw_bid = SBE_BID_PMC_C1T1E1;       /* 0xC1 - SBE wanPMC-C1T1E1 */
-        break;
+		ci->hdw_bid = SBE_BID_256T3_E1; /* 0x46 - SBE wanPTMC-256T3 (E1
+						 * Version) */
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
+		ci->hdw_bid = SBE_BID_256T3_T1; /* 0x42 - SBE wanPTMC-256T3 (T1
+						 * Version) */
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
+		/*
+		 * This Board ID is a generic identification.  Use the found number
+		 * of ports to further define this hardware.
+		 */
+		switch (ci->max_port)
+		{
+		default:                    /* shouldn't need a default, but have one
+					     * anyway */
+		case 4:
+			ci->hdw_bid = SBE_BID_PMC_C4T1E1;   /* 0xC4 - SBE wanPMC-C4T1E1 */
+			break;
+		case 2:
+			ci->hdw_bid = SBE_BID_PMC_C2T1E1;   /* 0xC2 - SBE wanPMC-C2T1E1 */
+			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
+			break;
+		case 1:
+			ci->hdw_bid = SBE_BID_PMC_C1T1E1;   /* 0xC1 - SBE wanPMC-C1T1E1 */
+			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
+			break;
+		}
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
+		ci->hdw_bid = SBE_BID_PMC_C2T1E1;       /* 0xC2 - SBE wanPMC-C2T1E1 */
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
+		ci->hdw_bid = SBE_BID_PMC_C1T1E1;       /* 0xC1 - SBE wanPMC-C1T1E1 */
+		break;
 #ifdef SBE_PMCC4_ENABLE
-        /*
-         * This case is entered as a result of the inability to obtain the
-         * <bid> from the board's EEPROM.  Assume a PCI board and set
-         * <hdsbid> according to the number ofr found ports.
-         */
-    case 0:
-        /* start by assuming 4-port for ZERO casing */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
-        /* drop thru to set hdw_bid and alternate PCI CxT1E1 settings */
+		/*
+		 * This case is entered as a result of the inability to obtain the
+		 * <bid> from the board's EEPROM.  Assume a PCI board and set
+		 * <hdsbid> according to the number ofr found ports.
+		 */
+	case 0:
+		/* start by assuming 4-port for ZERO casing */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		/* drop thru to set hdw_bid and alternate PCI CxT1E1 settings */
 #endif
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
-        /*
-         * This Board ID is a generic identification.  Use the number of
-         * found ports to further define this hardware.
-         */
-        switch (ci->max_port)
-        {
-        default:                    /* shouldn't need a default, but have one
-                                     * anyway */
-        case 4:
-            ci->hdw_bid = SBE_BID_PCI_C4T1E1;   /* 0x04 - SBE wanPCI-C4T1E1 */
-            break;
-        case 2:
-            ci->hdw_bid = SBE_BID_PCI_C2T1E1;   /* 0x02 - SBE wanPCI-C2T1E1 */
-            ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
-            break;
-        case 1:
-            ci->hdw_bid = SBE_BID_PCI_C1T1E1;   /* 0x01 - SBE wanPCI-C1T1E1 */
-            ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
-            break;
-        }
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
-        ci->hdw_bid = SBE_BID_PCI_C2T1E1;       /* 0x02 - SBE wanPCI-C2T1E1 */
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
-        ci->hdw_bid = SBE_BID_PCI_C1T1E1;       /* 0x01 - SBE wanPCI-C1T1E1 */
-        break;
-    default:
-        /*** bid = "<unknown>";  ***/
-        ci->hdw_bid = SBE_BID_PMC_C4T1E1;       /* 0x41 - SBE wanPTMC-C4T1E1 */
-        break;
-    }
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
+		/*
+		 * This Board ID is a generic identification.  Use the number of
+		 * found ports to further define this hardware.
+		 */
+		switch (ci->max_port)
+		{
+		default:                    /* shouldn't need a default, but have one
+					     * anyway */
+		case 4:
+			ci->hdw_bid = SBE_BID_PCI_C4T1E1;   /* 0x04 - SBE wanPCI-C4T1E1 */
+			break;
+		case 2:
+			ci->hdw_bid = SBE_BID_PCI_C2T1E1;   /* 0x02 - SBE wanPCI-C2T1E1 */
+			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
+			break;
+		case 1:
+			ci->hdw_bid = SBE_BID_PCI_C1T1E1;   /* 0x01 - SBE wanPCI-C1T1E1 */
+			ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
+			break;
+		}
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
+		ci->hdw_bid = SBE_BID_PCI_C2T1E1;       /* 0x02 - SBE wanPCI-C2T1E1 */
+		break;
+	case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
+		ci->hdw_bid = SBE_BID_PCI_C1T1E1;       /* 0x01 - SBE wanPCI-C1T1E1 */
+		break;
+	default:
+		/*** bid = "<unknown>";  ***/
+		ci->hdw_bid = SBE_BID_PMC_C4T1E1;       /* 0x41 - SBE wanPTMC-C4T1E1 */
+		break;
+	}
 }
 
 /* given the presetting of hdw_bid, set the corresponding brd_id */
@@ -165,45 +165,45 @@ sbeid_set_hdwbid (ci_t *ci)
 void
 sbeid_set_bdtype (ci_t *ci)
 {
-    /* set SBE's unique PCI VENDOR/DEVID */
-    switch (ci->hdw_bid)
-    {
+	/* set SBE's unique PCI VENDOR/DEVID */
+	switch (ci->hdw_bid)
+	{
         case SBE_BID_C1T3:      /* SBE wanPMC-C1T3 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3);
-        break;
-    case SBE_BID_C24TE1:            /* SBE wanPTMC-C24TE1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1);
-        break;
-    case SBE_BID_256T3_E1:          /* SBE wanPTMC-256T3 E1 Version */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1);
-        break;
-    case SBE_BID_256T3_T1:          /* SBE wanPTMC-256T3 T1 Version */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1);
-        break;
-    case SBE_BID_PMC_C4T1E1:        /* 0xC4 - SBE wanPMC-C4T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1);
-        break;
-    case SBE_BID_PMC_C2T1E1:        /* 0xC2 - SBE wanPMC-C2T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
-        break;
-    case SBE_BID_PMC_C1T1E1:        /* 0xC1 - SBE wanPMC-C1T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
-        break;
-    case SBE_BID_PCI_C4T1E1:        /* 0x04 - SBE wanPCI-C4T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
-        break;
-    case SBE_BID_PCI_C2T1E1:        /* 0x02 - SBE wanPCI-C2T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
-        break;
-    case SBE_BID_PCI_C1T1E1:        /* 0x01 - SBE wanPCI-C1T1E1 */
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
-        break;
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3);
+		break;
+	case SBE_BID_C24TE1:            /* SBE wanPTMC-C24TE1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1);
+		break;
+	case SBE_BID_256T3_E1:          /* SBE wanPTMC-256T3 E1 Version */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1);
+		break;
+	case SBE_BID_256T3_T1:          /* SBE wanPTMC-256T3 T1 Version */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1);
+		break;
+	case SBE_BID_PMC_C4T1E1:        /* 0xC4 - SBE wanPMC-C4T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1);
+		break;
+	case SBE_BID_PMC_C2T1E1:        /* 0xC2 - SBE wanPMC-C2T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1);
+		break;
+	case SBE_BID_PMC_C1T1E1:        /* 0xC1 - SBE wanPMC-C1T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1);
+		break;
+	case SBE_BID_PCI_C4T1E1:        /* 0x04 - SBE wanPCI-C4T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		break;
+	case SBE_BID_PCI_C2T1E1:        /* 0x02 - SBE wanPCI-C2T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1);
+		break;
+	case SBE_BID_PCI_C1T1E1:        /* 0x01 - SBE wanPCI-C1T1E1 */
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1);
+		break;
 
-    default:
-        /*** hdw_bid = "<unknown>";  ***/
-        ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
-        break;
-    }
+	default:
+		/*** hdw_bid = "<unknown>";  ***/
+		ci->brd_id = SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1);
+		break;
+	}
 }
 
 
-- 
1.8.3.1

