Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaGVUJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:09:45 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46995 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaGVUJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:02 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 3/5] staging: vt6655: statify some variables
Date: Tue, 22 Jul 2014 22:08:28 +0200
Message-Id: <1406059710-30903-4-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406059710-30903-1-git-send-email-gclement@baobob.org>
References: <1406059710-30903-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some variables are used only in the context of their .c file, which
gives warnings with sparse.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/baseband.c    | 14 +++++++-------
 drivers/staging/vt6655/bssdb.c       |  4 ++--
 drivers/staging/vt6655/card.c        |  6 +++---
 drivers/staging/vt6655/device_main.c |  4 ++--
 drivers/staging/vt6655/wcmd.c        |  2 +-
 drivers/staging/vt6655/wmgr.c        | 10 +++++-----
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 0985563..67bc3b4 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -75,7 +75,7 @@ static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Variables  --------------------------*/
 
 #define CB_VT3253_INIT_FOR_RFMD 446
-unsigned char byVT3253InitTab_RFMD[CB_VT3253_INIT_FOR_RFMD][2] = {
+static unsigned char byVT3253InitTab_RFMD[CB_VT3253_INIT_FOR_RFMD][2] = {
 	{0x00, 0x30},
 	{0x01, 0x00},
 	{0x02, 0x00},
@@ -525,7 +525,7 @@ unsigned char byVT3253InitTab_RFMD[CB_VT3253_INIT_FOR_RFMD][2] = {
 };
 
 #define CB_VT3253B0_INIT_FOR_RFMD 256
-unsigned char byVT3253B0_RFMD[CB_VT3253B0_INIT_FOR_RFMD][2] = {
+static unsigned char byVT3253B0_RFMD[CB_VT3253B0_INIT_FOR_RFMD][2] = {
 	{0x00, 0x31},
 	{0x01, 0x00},
 	{0x02, 0x00},
@@ -786,7 +786,7 @@ unsigned char byVT3253B0_RFMD[CB_VT3253B0_INIT_FOR_RFMD][2] = {
 
 #define CB_VT3253B0_AGC_FOR_RFMD2959 195
 /* For RFMD2959 */
-unsigned char byVT3253B0_AGC4_RFMD2959[CB_VT3253B0_AGC_FOR_RFMD2959][2] = {
+static unsigned char byVT3253B0_AGC4_RFMD2959[CB_VT3253B0_AGC_FOR_RFMD2959][2] = {
 	{0xF0, 0x00},
 	{0xF1, 0x3E},
 	{0xF0, 0x80},
@@ -986,7 +986,7 @@ unsigned char byVT3253B0_AGC4_RFMD2959[CB_VT3253B0_AGC_FOR_RFMD2959][2] = {
 
 #define CB_VT3253B0_INIT_FOR_AIROHA2230 256
 /* For AIROHA */
-unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
+static unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 	{0x00, 0x31},
 	{0x01, 0x00},
 	{0x02, 0x00},
@@ -1247,7 +1247,7 @@ unsigned char byVT3253B0_AIROHA2230[CB_VT3253B0_INIT_FOR_AIROHA2230][2] = {
 
 #define CB_VT3253B0_INIT_FOR_UW2451 256
 /* For UW2451 */
-unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
+static unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 	{0x00, 0x31},
 	{0x01, 0x00},
 	{0x02, 0x00},
@@ -1508,7 +1508,7 @@ unsigned char byVT3253B0_UW2451[CB_VT3253B0_INIT_FOR_UW2451][2] = {
 
 #define CB_VT3253B0_AGC 193
 /* For AIROHA */
-unsigned char byVT3253B0_AGC[CB_VT3253B0_AGC][2] = {
+static unsigned char byVT3253B0_AGC[CB_VT3253B0_AGC][2] = {
 	{0xF0, 0x00},
 	{0xF1, 0x00},
 	{0xF0, 0x80},
@@ -1704,7 +1704,7 @@ unsigned char byVT3253B0_AGC[CB_VT3253B0_AGC][2] = {
 	{0xF0, 0x00},
 };
 
-const unsigned short awcFrameTime[MAX_RATE] =
+static const unsigned short awcFrameTime[MAX_RATE] =
 {10, 20, 55, 110, 24, 36, 48, 72, 96, 144, 192, 216};
 
 /*---------------------  Static Functions  --------------------------*/
diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 59679cd..eb3474d 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -65,14 +65,14 @@
 /*---------------------  Static Variables  --------------------------*/
 static int msglevel = MSG_LEVEL_INFO;
 
-const unsigned short awHWRetry0[5][5] = {
+static const unsigned short awHWRetry0[5][5] = {
 	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
 	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
 	{RATE_36M, RATE_36M, RATE_24M, RATE_18M, RATE_18M},
 	{RATE_48M, RATE_48M, RATE_36M, RATE_24M, RATE_24M},
 	{RATE_54M, RATE_54M, RATE_48M, RATE_36M, RATE_36M}
 };
-const unsigned short awHWRetry1[5][5] = {
+static const unsigned short awHWRetry1[5][5] = {
 	{RATE_18M, RATE_18M, RATE_12M, RATE_6M, RATE_6M},
 	{RATE_24M, RATE_24M, RATE_18M, RATE_6M, RATE_6M},
 	{RATE_36M, RATE_36M, RATE_24M, RATE_12M, RATE_12M},
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 988858b..e29dcd8 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -87,7 +87,7 @@ static unsigned char abyDefaultSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x0
 
 /*---------------------  Static Variables  --------------------------*/
 
-const unsigned short cwRXBCNTSFOff[MAX_RATE] =
+static const unsigned short cwRXBCNTSFOff[MAX_RATE] =
 {17, 17, 17, 17, 34, 23, 17, 11, 8, 5, 4, 3};
 
 /*---------------------  Static Functions  --------------------------*/
@@ -1576,7 +1576,7 @@ CARDvSafeResetRx(
  * Return Value: response Control frame rate
  *
  */
-unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned short wRateIdx)
+static unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned short wRateIdx)
 {
 	PSDevice    pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ui = (unsigned int) wRateIdx;
@@ -1603,7 +1603,7 @@ unsigned short CARDwGetCCKControlRate(void *pDeviceHandler, unsigned short wRate
  * Return Value: response Control frame rate
  *
  */
-unsigned short CARDwGetOFDMControlRate(void *pDeviceHandler, unsigned short wRateIdx)
+static unsigned short CARDwGetOFDMControlRate(void *pDeviceHandler, unsigned short wRateIdx)
 {
 	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	unsigned int ui = (unsigned int) wRateIdx;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 4dcdfca..5576c30 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -260,7 +260,7 @@ static CHIP_INFO chip_info_table[] = {
 	{0, NULL}
 };
 
-const struct pci_device_id vt6655_pci_id_table[] = {
+static const struct pci_device_id vt6655_pci_id_table[] = {
 	{ PCI_VDEVICE(VIA, 0x3253), (kernel_ulong_t)chip_info_table},
 	{ 0, }
 };
@@ -285,7 +285,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static int device_notify_reboot(struct notifier_block *, unsigned long event, void *ptr);
 static int viawget_suspend(struct pci_dev *pcid, pm_message_t state);
 static int viawget_resume(struct pci_dev *pcid);
-struct notifier_block device_notifier = {
+static struct notifier_block device_notifier = {
 	.notifier_call = device_notify_reboot,
 	.next = NULL,
 	.priority = 0,
diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index a689645..a379cec 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -234,7 +234,7 @@ s_vProbeChannel(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeProbeRequest(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index cc4f5b9..9853a8f 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -3144,7 +3144,7 @@ s_MgrMakeBeacon(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeProbeResponse(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
@@ -3326,7 +3326,7 @@ s_MgrMakeProbeResponse(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeAssocRequest(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
@@ -3586,7 +3586,7 @@ s_MgrMakeAssocRequest(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeReAssocRequest(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
@@ -3831,7 +3831,7 @@ s_MgrMakeReAssocRequest(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeAssocResponse(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
@@ -3902,7 +3902,7 @@ s_MgrMakeAssocResponse(
  *
  -*/
 
-PSTxMgmtPacket
+static PSTxMgmtPacket
 s_MgrMakeReAssocResponse(
 	PSDevice pDevice,
 	PSMgmtObject pMgmt,
-- 
1.8.5.5

