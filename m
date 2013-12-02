Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3LBXbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:31:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36615 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3LBXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:31:41 -0500
X-AuditID: cbfee691-b7f666d0000048b0-dc-529d185b15f6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Takashi Iwai'" <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 37/39] sound: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:31:39 +0900
Message-id: <003a01ceefb6$a6474ce0$f2d5e6a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABUR2A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY91oiblBBpMOqltcuXiIyaJ58Xo2
	i8sLL7FaXN41h83i5eY3TA6sHhs+N7F57J+7ht2jb8sqRo/Np6s9Pm+SC2CN4rJJSc3JLEst
	0rdL4Mro/radueDPaqaKnVv3szYwfvjO2MXIySEhYCLRP3kpO4QtJnHh3nq2LkYuDiGBZYwS
	O/5tY4MpejNrKStEYhGjxPKGx2DdQgK/GCWO7xAGsdkE1CS+fDkMNklEwFRi4/spjCANzALN
	jBL/37WxQzTYSkx/sZmpi5GDg1PATqLvUy1IWFjASeJ38wNmEJtFQFVi36O1TCA2L1D5xBPv
	2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDDJSQkBd4tFfXYgTjCR+P1nBCFEiIrHvxTuw
	cyQEXrJLTP//HGqXgMS3yYdYIHplJTYdYIb4V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPL
	KkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQWJ24g/H+AetDjMlA6ycyS4km5wNjPa8k3tDY
	zMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFcWh01vZ+P3
	+dWw1qxbZ/HPD+qP7vuoKJ9/evrHknXRck+cohSFN0mxBD9/yfT6bdTO+8yt9fMe75y7oHj7
	vdSV9WeUN5U5pX39s+ivfH3IKvcDG/L3BU89In5hrSV3z2Xj56WBCqdiV+64oZm04qnqmhN9
	ESwmHz9cfedgx7JT5PS+y8eeeucpsRRnJBpqMRcVJwIAUd5xsOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd1oiblBBksuyllcuXiIyaJ58Xo2
	i8sLL7FaXN41h83i5eY3TA6sHhs+N7F57J+7ht2jb8sqRo/Np6s9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6P62nbngz2qmip1b97M2MH74ztjFyMkhIWAi
	8WbWUlYIW0ziwr31bF2MXBxCAosYJZY3PAYrEhL4xShxfIcwiM0moCbx5cthdhBbRMBUYuP7
	KYwgDcwCzYwS/9+1sUM02EpMf7GZqYuRg4NTwE6i71MtSFhYwEnid/MDZhCbRUBVYt+jtUwg
	Ni9Q+cQT79kgbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywwyUkJAXeLRX12IE4wkfj9ZwQhR
	IiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	ETyT3sG4qsHiEKMAB6MSD++D7XOChFgTy4orcw8xSnAwK4nwdvLMDRLiTUmsrEotyo8vKs1J
	LT7EmAz06ERmKdHkfGCSyiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGRo/OJ4px/NfX1iTHnCjbqlT2fuEvLd3PF5/NDtyzJVFh4udTbs8emO89tPgSc4yB
	LIOOhrPmvzaNij03T+59IWG94WqVWuWBveL3PHsbPRfwvpVfoTlr8qbW2B2Pz1doSLReYg48
	XRPcOfHG/OXuOv0nHsV8Z235nnc2VnzG3J0Jr13spacwTVBiKc5INNRiLipOBAA9MB/USAMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 sound/oss/kahlua.c                  |    2 +-
 sound/pci/ad1889.c                  |    2 +-
 sound/pci/ali5451/ali5451.c         |    2 +-
 sound/pci/als300.c                  |    2 +-
 sound/pci/als4000.c                 |    2 +-
 sound/pci/asihpi/asihpi.c           |    2 +-
 sound/pci/atiixp.c                  |    2 +-
 sound/pci/atiixp_modem.c            |    2 +-
 sound/pci/au88x0/au8810.c           |    2 +-
 sound/pci/au88x0/au8820.c           |    2 +-
 sound/pci/au88x0/au8830.c           |    2 +-
 sound/pci/aw2/aw2-alsa.c            |    2 +-
 sound/pci/azt3328.c                 |    2 +-
 sound/pci/bt87x.c                   |    4 ++--
 sound/pci/ca0106/ca0106_main.c      |    2 +-
 sound/pci/cmipci.c                  |    4 ++--
 sound/pci/cs4281.c                  |    2 +-
 sound/pci/cs46xx/cs46xx.c           |    2 +-
 sound/pci/cs5530.c                  |    2 +-
 sound/pci/cs5535audio/cs5535audio.c |    2 +-
 sound/pci/ctxfi/xfi.c               |    2 +-
 sound/pci/echoaudio/darla20.c       |    2 +-
 sound/pci/echoaudio/darla24.c       |    2 +-
 sound/pci/echoaudio/echo3g.c        |    2 +-
 sound/pci/echoaudio/gina20.c        |    2 +-
 sound/pci/echoaudio/gina24.c        |    2 +-
 sound/pci/echoaudio/indigo.c        |    2 +-
 sound/pci/echoaudio/indigodj.c      |    2 +-
 sound/pci/echoaudio/indigodjx.c     |    2 +-
 sound/pci/echoaudio/indigoio.c      |    2 +-
 sound/pci/echoaudio/indigoiox.c     |    2 +-
 sound/pci/echoaudio/layla20.c       |    2 +-
 sound/pci/echoaudio/layla24.c       |    2 +-
 sound/pci/echoaudio/mia.c           |    2 +-
 sound/pci/echoaudio/mona.c          |    2 +-
 sound/pci/emu10k1/emu10k1.c         |    2 +-
 sound/pci/emu10k1/emu10k1x.c        |    2 +-
 sound/pci/ens1370.c                 |    2 +-
 sound/pci/es1938.c                  |    2 +-
 sound/pci/es1968.c                  |    2 +-
 sound/pci/fm801.c                   |    2 +-
 sound/pci/hda/hda_intel.c           |    2 +-
 sound/pci/ice1712/ice1712.c         |    2 +-
 sound/pci/ice1712/ice1724.c         |    2 +-
 sound/pci/intel8x0.c                |    2 +-
 sound/pci/intel8x0m.c               |    2 +-
 sound/pci/korg1212/korg1212.c       |    2 +-
 sound/pci/lola/lola.c               |    2 +-
 sound/pci/lx6464es/lx6464es.c       |    2 +-
 sound/pci/maestro3.c                |    2 +-
 sound/pci/mixart/mixart.c           |    2 +-
 sound/pci/nm256/nm256.c             |    2 +-
 sound/pci/oxygen/oxygen.c           |    2 +-
 sound/pci/oxygen/virtuoso.c         |    2 +-
 sound/pci/pcxhr/pcxhr.c             |    2 +-
 sound/pci/riptide/riptide.c         |    4 ++--
 sound/pci/rme32.c                   |    2 +-
 sound/pci/rme96.c                   |    2 +-
 sound/pci/rme9652/hdsp.c            |    2 +-
 sound/pci/rme9652/hdspm.c           |    2 +-
 sound/pci/rme9652/rme9652.c         |    2 +-
 sound/pci/sis7019.c                 |    2 +-
 sound/pci/sonicvibes.c              |    2 +-
 sound/pci/trident/trident.c         |    2 +-
 sound/pci/via82xx.c                 |    2 +-
 sound/pci/via82xx_modem.c           |    2 +-
 sound/pci/vx222/vx222.c             |    2 +-
 sound/pci/ymfpci/ymfpci.c           |    2 +-
 68 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/sound/oss/kahlua.c b/sound/oss/kahlua.c
index 12be1fb..c4b0434 100644
--- a/sound/oss/kahlua.c
+++ b/sound/oss/kahlua.c
@@ -197,7 +197,7 @@ MODULE_LICENSE("GPL");
  *	5530 only. The 5510/5520 decode is different.
  */
 
-static DEFINE_PCI_DEVICE_TABLE(id_tbl) = {
+static const struct pci_device_id id_tbl[] = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_AUDIO), 0 },
 	{ }
 };
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index b680d03..793cf1e 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -1048,7 +1048,7 @@ snd_ad1889_remove(struct pci_dev *pci)
 	snd_card_free(pci_get_drvdata(pci));
 }
 
-static DEFINE_PCI_DEVICE_TABLE(snd_ad1889_ids) = {
+static const struct pci_device_id snd_ad1889_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ANALOG_DEVICES, PCI_DEVICE_ID_AD1889JS) },
 	{ 0, },
 };
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index c6835a3..f7bdcc6 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -275,7 +275,7 @@ struct snd_ali {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_ali_ids) = {
+static const struct pci_device_id snd_ali_ids[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5451), 0, 0, 0},
 	{0, }
 };
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 591efb6..7bfeed8 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -152,7 +152,7 @@ struct snd_als300_substream_data {
 	int block_counter_register;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_als300_ids) = {
+static const struct pci_device_id snd_als300_ids[] = {
 	{ 0x4005, 0x0300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_ALS300 },
 	{ 0x4005, 0x0308, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DEVICE_ALS300_PLUS },
 	{ 0, }
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index ffc821b..6c9429e 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -116,7 +116,7 @@ struct snd_card_als4000 {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_als4000_ids) = {
+static const struct pci_device_id snd_als4000_ids[] = {
 	{ 0x4005, 0x4000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },   /* ALS4000 */
 	{ 0, }
 };
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 5f2acd3..623f1ae 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -2960,7 +2960,7 @@ static void snd_asihpi_remove(struct pci_dev *pci_dev)
 	asihpi_adapter_remove(pci_dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(asihpi_pci_tbl) = {
+static const struct pci_device_id asihpi_pci_tbl[] = {
 	{HPI_PCI_VENDOR_ID_TI, HPI_PCI_DEV_ID_DSP6205,
 		HPI_PCI_VENDOR_ID_AUDIOSCIENCE, PCI_ANY_ID, 0, 0,
 		(kernel_ulong_t)HPI_6205},
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index f6dec3e..144d594 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -286,7 +286,7 @@ struct atiixp {
 
 /*
  */
-static DEFINE_PCI_DEVICE_TABLE(snd_atiixp_ids) = {
+static const struct pci_device_id snd_atiixp_ids[] = {
 	{ PCI_VDEVICE(ATI, 0x4341), 0 }, /* SB200 */
 	{ PCI_VDEVICE(ATI, 0x4361), 0 }, /* SB300 */
 	{ PCI_VDEVICE(ATI, 0x4370), 0 }, /* SB400 */
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 289563e..c6d1148 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -261,7 +261,7 @@ struct atiixp_modem {
 
 /*
  */
-static DEFINE_PCI_DEVICE_TABLE(snd_atiixp_ids) = {
+static const struct pci_device_id snd_atiixp_ids[] = {
 	{ PCI_VDEVICE(ATI, 0x434d), 0 }, /* SB200 */
 	{ PCI_VDEVICE(ATI, 0x4378), 0 }, /* SB400 */
 	{ 0, }
diff --git a/sound/pci/au88x0/au8810.c b/sound/pci/au88x0/au8810.c
index aa51cc7..1b2e340 100644
--- a/sound/pci/au88x0/au8810.c
+++ b/sound/pci/au88x0/au8810.c
@@ -1,6 +1,6 @@
 #include "au8810.h"
 #include "au88x0.h"
-static DEFINE_PCI_DEVICE_TABLE(snd_vortex_ids) = {
+static const struct pci_device_id snd_vortex_ids[] = {
 	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_ADVANTAGE), 1,},
 	{0,}
 };
diff --git a/sound/pci/au88x0/au8820.c b/sound/pci/au88x0/au8820.c
index 2f321e7..74c53fa 100644
--- a/sound/pci/au88x0/au8820.c
+++ b/sound/pci/au88x0/au8820.c
@@ -1,6 +1,6 @@
 #include "au8820.h"
 #include "au88x0.h"
-static DEFINE_PCI_DEVICE_TABLE(snd_vortex_ids) = {
+static const struct pci_device_id snd_vortex_ids[] = {
 	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_1), 0,},
 	{0,}
 };
diff --git a/sound/pci/au88x0/au8830.c b/sound/pci/au88x0/au8830.c
index 279b78f..56f675a 100644
--- a/sound/pci/au88x0/au8830.c
+++ b/sound/pci/au88x0/au8830.c
@@ -1,6 +1,6 @@
 #include "au8830.h"
 #include "au88x0.h"
-static DEFINE_PCI_DEVICE_TABLE(snd_vortex_ids) = {
+static const struct pci_device_id snd_vortex_ids[] = {
 	{PCI_VDEVICE(AUREAL, PCI_DEVICE_ID_AUREAL_VORTEX_2), 0,},
 	{0,}
 };
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index 2925220..f05b843 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -160,7 +160,7 @@ MODULE_PARM_DESC(id, "ID string for the Audiowerk2 soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Audiowerk2 soundcard.");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_aw2_ids) = {
+static const struct pci_device_id snd_aw2_ids[] = {
 	{PCI_VENDOR_ID_PHILIPS, PCI_DEVICE_ID_PHILIPS_SAA7146, 0, 0,
 	 0, 0, 0},
 	{0}
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 1aef712..4d5b97b 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -376,7 +376,7 @@ struct snd_azf3328 {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_azf3328_ids) = {
+static const struct pci_device_id snd_azf3328_ids[] = {
 	{ 0x122D, 0x50DC, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },   /* PCI168/3328 */
 	{ 0x122D, 0x80DA, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },   /* 3328 */
 	{ 0, }
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 1880203..55a3d1e 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -789,7 +789,7 @@ fail:
 	  .driver_data = SND_BT87X_BOARD_ ## id }
 /* driver_data is the card id for that device */
 
-static DEFINE_PCI_DEVICE_TABLE(snd_bt87x_ids) = {
+static const struct pci_device_id snd_bt87x_ids[] = {
 	/* Hauppauge WinTV series */
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0x13eb, GENERIC),
 	/* Hauppauge WinTV series */
@@ -957,7 +957,7 @@ static void snd_bt87x_remove(struct pci_dev *pci)
 
 /* default entries for all Bt87x cards - it's not exported */
 /* driver_data is set to 0 to call detection */
-static DEFINE_PCI_DEVICE_TABLE(snd_bt87x_default_ids) = {
+static const struct pci_device_id snd_bt87x_default_ids[] = {
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, PCI_ANY_ID, PCI_ANY_ID, UNKNOWN),
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_879, PCI_ANY_ID, PCI_ANY_ID, UNKNOWN),
 	{ }
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index f4db558..bbf9f39 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1959,7 +1959,7 @@ static SIMPLE_DEV_PM_OPS(snd_ca0106_pm, snd_ca0106_suspend, snd_ca0106_resume);
 #endif
 
 // PCI IDs
-static DEFINE_PCI_DEVICE_TABLE(snd_ca0106_ids) = {
+static const struct pci_device_id snd_ca0106_ids[] = {
 	{ PCI_VDEVICE(CREATIVE, 0x0007), 0 },	/* Audigy LS or Live 24bit */
 	{ 0, }
 };
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 2755ec5..fb73198 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2803,7 +2803,7 @@ static inline void snd_cmipci_proc_init(struct cmipci *cm) {}
 #endif
 
 
-static DEFINE_PCI_DEVICE_TABLE(snd_cmipci_ids) = {
+static const struct pci_device_id snd_cmipci_ids[] = {
 	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338A), 0},
 	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8338B), 0},
 	{PCI_VDEVICE(CMEDIA, PCI_DEVICE_ID_CMEDIA_CM8738), 0},
@@ -3025,7 +3025,7 @@ static int snd_cmipci_create(struct snd_card *card, struct pci_dev *pci,
 	int integrated_midi = 0;
 	char modelstr[16];
 	int pcm_index, pcm_spdif_index;
-	static DEFINE_PCI_DEVICE_TABLE(intel_82437vx) = {
+	static const struct pci_device_id intel_82437vx[] = {
 		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82437VX) },
 		{ },
 	};
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 1dc793e..3eef727 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -494,7 +494,7 @@ struct cs4281 {
 
 static irqreturn_t snd_cs4281_interrupt(int irq, void *dev_id);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_cs4281_ids) = {
+static const struct pci_device_id snd_cs4281_ids[] = {
 	{ PCI_VDEVICE(CIRRUS, 0x6005), 0, },	/* CS4281 */
 	{ 0, }
 };
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index b034983..8234fbb 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(thinkpad, "Force to enable Thinkpad's CLKRUN control.");
 module_param_array(mmap_valid, bool, NULL, 0444);
 MODULE_PARM_DESC(mmap_valid, "Support OSS mmap.");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_cs46xx_ids) = {
+static const struct pci_device_id snd_cs46xx_ids[] = {
 	{ PCI_VDEVICE(CIRRUS, 0x6001), 0, },   /* CS4280 */
 	{ PCI_VDEVICE(CIRRUS, 0x6003), 0, },   /* CS4612 */
 	{ PCI_VDEVICE(CIRRUS, 0x6004), 0, },   /* CS4615 */
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index c6b82c8..1f86a42 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -66,7 +66,7 @@ struct snd_cs5530 {
 	unsigned long pci_base;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_cs5530_ids) = {
+static const struct pci_device_id snd_cs5530_ids[] = {
 	{PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_AUDIO, PCI_ANY_ID,
 							PCI_ANY_ID, 0, 0},
 	{0,}
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 902bebd..0276e12 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(id, "ID string for " DRIVER_NAME);
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable " DRIVER_NAME);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_cs5535audio_ids) = {
+static const struct pci_device_id snd_cs5535audio_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_AUDIO) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_AUDIO) },
 	{}
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
index d464ad2..568b365 100644
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -44,7 +44,7 @@ MODULE_PARM_DESC(enable, "Enable Creative X-Fi driver");
 module_param_array(subsystem, int, NULL, 0444);
 MODULE_PARM_DESC(subsystem, "Override subsystem ID for Creative X-Fi driver");
 
-static DEFINE_PCI_DEVICE_TABLE(ct_pci_dev_ids) = {
+static const struct pci_device_id ct_pci_dev_ids[] = {
 	/* only X-Fi is supported, so... */
 	{ PCI_DEVICE(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K1),
 	  .driver_data = ATC20K1,
diff --git a/sound/pci/echoaudio/darla20.c b/sound/pci/echoaudio/darla20.c
index d47e72a..4632946 100644
--- a/sound/pci/echoaudio/darla20.c
+++ b/sound/pci/echoaudio/darla20.c
@@ -63,7 +63,7 @@ static const struct firmware card_fw[] = {
 	{0, "darla20_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0010, 0, 0, 0},	/* DSP 56301 Darla20 rev.0 */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/darla24.c b/sound/pci/echoaudio/darla24.c
index 413acf7..f81c839 100644
--- a/sound/pci/echoaudio/darla24.c
+++ b/sound/pci/echoaudio/darla24.c
@@ -67,7 +67,7 @@ static const struct firmware card_fw[] = {
 	{0, "darla24_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0040, 0, 0, 0},	/* DSP 56301 Darla24 rev.0 */
 	{0x1057, 0x1801, 0xECC0, 0x0041, 0, 0, 0},	/* DSP 56301 Darla24 rev.1 */
 	{0,}
diff --git a/sound/pci/echoaudio/echo3g.c b/sound/pci/echoaudio/echo3g.c
index 1ec4edc..3a5346c 100644
--- a/sound/pci/echoaudio/echo3g.c
+++ b/sound/pci/echoaudio/echo3g.c
@@ -81,7 +81,7 @@ static const struct firmware card_fw[] = {
 	{0, "3g_asic.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x0100, 0, 0, 0},	/* Echo 3G */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/gina20.c b/sound/pci/echoaudio/gina20.c
index 039125b..9cb81c5 100644
--- a/sound/pci/echoaudio/gina20.c
+++ b/sound/pci/echoaudio/gina20.c
@@ -67,7 +67,7 @@ static const struct firmware card_fw[] = {
 	{0, "gina20_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0020, 0, 0, 0},	/* DSP 56301 Gina20 rev.0 */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/gina24.c b/sound/pci/echoaudio/gina24.c
index 5e966f6..35d3e6e 100644
--- a/sound/pci/echoaudio/gina24.c
+++ b/sound/pci/echoaudio/gina24.c
@@ -85,7 +85,7 @@ static const struct firmware card_fw[] = {
 	{0, "gina24_361_asic.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0050, 0, 0, 0},	/* DSP 56301 Gina24 rev.0 */
 	{0x1057, 0x1801, 0xECC0, 0x0051, 0, 0, 0},	/* DSP 56301 Gina24 rev.1 */
 	{0x1057, 0x3410, 0xECC0, 0x0050, 0, 0, 0},	/* DSP 56361 Gina24 rev.0 */
diff --git a/sound/pci/echoaudio/indigo.c b/sound/pci/echoaudio/indigo.c
index c166b7e..8d91842 100644
--- a/sound/pci/echoaudio/indigo.c
+++ b/sound/pci/echoaudio/indigo.c
@@ -68,7 +68,7 @@ static const struct firmware card_fw[] = {
 	{0, "indigo_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x0090, 0, 0, 0},	/* Indigo */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/indigodj.c b/sound/pci/echoaudio/indigodj.c
index a3ef3b9..289cb96 100644
--- a/sound/pci/echoaudio/indigodj.c
+++ b/sound/pci/echoaudio/indigodj.c
@@ -68,7 +68,7 @@ static const struct firmware card_fw[] = {
 	{0, "indigo_dj_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x00B0, 0, 0, 0},	/* Indigo DJ*/
 	{0,}
 };
diff --git a/sound/pci/echoaudio/indigodjx.c b/sound/pci/echoaudio/indigodjx.c
index f516444..201688e 100644
--- a/sound/pci/echoaudio/indigodjx.c
+++ b/sound/pci/echoaudio/indigodjx.c
@@ -68,7 +68,7 @@ static const struct firmware card_fw[] = {
 	{0, "indigo_djx_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x00E0, 0, 0, 0},	/* Indigo DJx*/
 	{0,}
 };
diff --git a/sound/pci/echoaudio/indigoio.c b/sound/pci/echoaudio/indigoio.c
index c22c82f..405a3f2 100644
--- a/sound/pci/echoaudio/indigoio.c
+++ b/sound/pci/echoaudio/indigoio.c
@@ -69,7 +69,7 @@ static const struct firmware card_fw[] = {
 	{0, "indigo_io_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x00A0, 0, 0, 0},	/* Indigo IO*/
 	{0,}
 };
diff --git a/sound/pci/echoaudio/indigoiox.c b/sound/pci/echoaudio/indigoiox.c
index 86cf2d0..e145b68 100644
--- a/sound/pci/echoaudio/indigoiox.c
+++ b/sound/pci/echoaudio/indigoiox.c
@@ -69,7 +69,7 @@ static const struct firmware card_fw[] = {
 	{0, "indigo_iox_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x00D0, 0, 0, 0},	/* Indigo IOx */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/layla20.c b/sound/pci/echoaudio/layla20.c
index 6a027f3..b392dd7 100644
--- a/sound/pci/echoaudio/layla20.c
+++ b/sound/pci/echoaudio/layla20.c
@@ -76,7 +76,7 @@ static const struct firmware card_fw[] = {
 	{0, "layla20_asic.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0030, 0, 0, 0},	/* DSP 56301 Layla20 rev.0 */
 	{0x1057, 0x1801, 0xECC0, 0x0031, 0, 0, 0},	/* DSP 56301 Layla20 rev.1 */
 	{0,}
diff --git a/sound/pci/echoaudio/layla24.c b/sound/pci/echoaudio/layla24.c
index 96a5991..bc7f730 100644
--- a/sound/pci/echoaudio/layla24.c
+++ b/sound/pci/echoaudio/layla24.c
@@ -87,7 +87,7 @@ static const struct firmware card_fw[] = {
 	{0, "layla24_2S_asic.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x0060, 0, 0, 0},	/* DSP 56361 Layla24 rev.0 */
 	{0,}
 };
diff --git a/sound/pci/echoaudio/mia.c b/sound/pci/echoaudio/mia.c
index b8ce27e..27a9a6e 100644
--- a/sound/pci/echoaudio/mia.c
+++ b/sound/pci/echoaudio/mia.c
@@ -77,7 +77,7 @@ static const struct firmware card_fw[] = {
 	{0, "mia_dsp.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x3410, 0xECC0, 0x0080, 0, 0, 0},	/* DSP 56361 Mia rev.0 */
 	{0x1057, 0x3410, 0xECC0, 0x0081, 0, 0, 0},	/* DSP 56361 Mia rev.1 */
 	{0,}
diff --git a/sound/pci/echoaudio/mona.c b/sound/pci/echoaudio/mona.c
index 1283bfb..3d13875 100644
--- a/sound/pci/echoaudio/mona.c
+++ b/sound/pci/echoaudio/mona.c
@@ -92,7 +92,7 @@ static const struct firmware card_fw[] = {
 	{0, "mona_2_asic.fw"}
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_echo_ids) = {
+static const struct pci_device_id snd_echo_ids[] = {
 	{0x1057, 0x1801, 0xECC0, 0x0070, 0, 0, 0},	/* DSP 56301 Mona rev.0 */
 	{0x1057, 0x1801, 0xECC0, 0x0071, 0, 0, 0},	/* DSP 56301 Mona rev.1 */
 	{0x1057, 0x1801, 0xECC0, 0x0072, 0, 0, 0},	/* DSP 56301 Mona rev.2 */
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index 9e1bd0c..7feeb78 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(delay_pcm_irq, "Delay PCM interrupt by specified number of samp
 /*
  * Class 0401: 1102:0008 (rev 00) Subsystem: 1102:1001 -> Audigy2 Value  Model:SB0400
  */
-static DEFINE_PCI_DEVICE_TABLE(snd_emu10k1_ids) = {
+static const struct pci_device_id snd_emu10k1_ids[] = {
 	{ PCI_VDEVICE(CREATIVE, 0x0002), 0 },	/* EMU10K1 */
 	{ PCI_VDEVICE(CREATIVE, 0x0004), 1 },	/* Audigy */
 	{ PCI_VDEVICE(CREATIVE, 0x0008), 1 },	/* Audigy 2 Value SB0400 */
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 56ad9d6..6a80ab8 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1626,7 +1626,7 @@ static void snd_emu10k1x_remove(struct pci_dev *pci)
 }
 
 // PCI IDs
-static DEFINE_PCI_DEVICE_TABLE(snd_emu10k1x_ids) = {
+static const struct pci_device_id snd_emu10k1x_ids[] = {
 	{ PCI_VDEVICE(CREATIVE, 0x0006), 0 },	/* Dell OEM version (EMU10K1) */
 	{ 0, }
 };
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 61262f3..f5963b6 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -446,7 +446,7 @@ struct ensoniq {
 
 static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_audiopci_ids) = {
+static const struct pci_device_id snd_audiopci_ids[] = {
 #ifdef CHIP1370
 	{ PCI_VDEVICE(ENSONIQ, 0x5000), 0, },	/* ES1370 */
 #endif
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 9213fb3..7eb87f2 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -243,7 +243,7 @@ struct es1938 {
 
 static irqreturn_t snd_es1938_interrupt(int irq, void *dev_id);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_es1938_ids) = {
+static const struct pci_device_id snd_es1938_ids[] = {
 	{ PCI_VDEVICE(ESS, 0x1969), 0, },   /* Solo-1 */
 	{ 0, }
 };
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index b0e3d92..cd1d947 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -570,7 +570,7 @@ struct es1968 {
 
 static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id);
 
-static DEFINE_PCI_DEVICE_TABLE(snd_es1968_ids) = {
+static const struct pci_device_id snd_es1968_ids[] = {
 	/* Maestro 1 */
         { 0x1285, 0x0100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, TYPE_MAESTRO },
 	/* Maestro 2 */
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index 45bc8a9..739f224 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -210,7 +210,7 @@ struct fm801 {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_fm801_ids) = {
+static const struct pci_device_id snd_fm801_ids[] = {
 	{ 0x1319, 0x0801, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, 0, },   /* FM801 */
 	{ 0x5213, 0x0510, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, 0, },   /* Gallant Odyssey Sound 4 */
 	{ 0, }
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c6d2301..d1f11a5 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3969,7 +3969,7 @@ static void azx_remove(struct pci_dev *pci)
 }
 
 /* PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
+static const struct pci_device_id azx_ids[] = {
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20),
 	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 28ec872..b8378e7 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -105,7 +105,7 @@ module_param_array(dxr_enable, int, NULL, 0444);
 MODULE_PARM_DESC(dxr_enable, "Enable DXR support for Terratec DMX6FIRE.");
 
 
-static DEFINE_PCI_DEVICE_TABLE(snd_ice1712_ids) = {
+static const struct pci_device_id snd_ice1712_ids[] = {
 	{ PCI_VDEVICE(ICE, PCI_DEVICE_ID_ICE_1712), 0 },   /* ICE1712 */
 	{ 0, }
 };
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 5004717..4a3165b 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -94,7 +94,7 @@ MODULE_PARM_DESC(model, "Use the given board model.");
 
 
 /* Both VT1720 and VT1724 have the same PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(snd_vt1724_ids) = {
+static const struct pci_device_id snd_vt1724_ids[] = {
 	{ PCI_VDEVICE(ICE, PCI_DEVICE_ID_VT1724), 0 },
 	{ 0, }
 };
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 08d8733..e5cb94e 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -430,7 +430,7 @@ struct intel8x0 {
 	u32 int_sta_mask;		/* interrupt status mask */
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_intel8x0_ids) = {
+static const struct pci_device_id snd_intel8x0_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x2415), DEVICE_INTEL },	/* 82801AA */
 	{ PCI_VDEVICE(INTEL, 0x2425), DEVICE_INTEL },	/* 82901AB */
 	{ PCI_VDEVICE(INTEL, 0x2445), DEVICE_INTEL },	/* 82801BA */
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 3573c11..ab7edfd 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -219,7 +219,7 @@ struct intel8x0m {
 	unsigned int pcm_pos_shift;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_intel8x0m_ids) = {
+static const struct pci_device_id snd_intel8x0m_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x2416), DEVICE_INTEL },	/* 82801AA */
 	{ PCI_VDEVICE(INTEL, 0x2426), DEVICE_INTEL },	/* 82901AB */
 	{ PCI_VDEVICE(INTEL, 0x2446), DEVICE_INTEL },	/* 82801BA */
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 9cf9829..9413b8a 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -418,7 +418,7 @@ module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Korg 1212 soundcard.");
 MODULE_AUTHOR("Haroldo Gamal <gamal@alternex.com.br>");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_korg1212_ids) = {
+static const struct pci_device_id snd_korg1212_ids[] = {
 	{
 		.vendor	   = 0x10b5,
 		.device	   = 0x906d,
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 0568540..a7beffe 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -762,7 +762,7 @@ static void lola_remove(struct pci_dev *pci)
 }
 
 /* PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(lola_ids) = {
+static const struct pci_device_id lola_ids[] = {
 	{ PCI_VDEVICE(DIGIGRAM, 0x0001) },
 	{ 0, }
 };
diff --git a/sound/pci/lx6464es/lx6464es.c b/sound/pci/lx6464es/lx6464es.c
index 5fcaaa6..a016e39 100644
--- a/sound/pci/lx6464es/lx6464es.c
+++ b/sound/pci/lx6464es/lx6464es.c
@@ -56,7 +56,7 @@ static const char card_name[] = "LX6464ES";
 
 #define PCI_DEVICE_ID_PLX_LX6464ES		PCI_DEVICE_ID_PLX_9056
 
-static DEFINE_PCI_DEVICE_TABLE(snd_lx6464es_ids) = {
+static const struct pci_device_id snd_lx6464es_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_LX6464ES),
 	  .subvendor = PCI_VENDOR_ID_DIGIGRAM,
 	  .subdevice = PCI_SUBDEVICE_ID_DIGIGRAM_LX6464ES_SERIAL_SUBSYSTEM
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index d541736..836ce95 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -800,7 +800,7 @@ struct snd_m3 {
 /*
  * pci ids
  */
-static DEFINE_PCI_DEVICE_TABLE(snd_m3_ids) = {
+static const struct pci_device_id snd_m3_ids[] = {
 	{PCI_VENDOR_ID_ESS, PCI_DEVICE_ID_ESS_ALLEGRO_1, PCI_ANY_ID, PCI_ANY_ID,
 	 PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, 0},
 	{PCI_VENDOR_ID_ESS, PCI_DEVICE_ID_ESS_ALLEGRO, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 1e0f6ee..c9fe3e2 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(enable, "Enable Digigram " CARD_NAME " soundcard.");
 /*
  */
 
-static DEFINE_PCI_DEVICE_TABLE(snd_mixart_ids) = {
+static const struct pci_device_id snd_mixart_ids[] = {
 	{ PCI_VDEVICE(MOTOROLA, 0x0003), 0, }, /* MC8240 */
 	{ 0, }
 };
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index fe79fff..97eac98 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -262,7 +262,7 @@ struct nm256 {
 /*
  * PCI ids
  */
-static DEFINE_PCI_DEVICE_TABLE(snd_nm256_ids) = {
+static const struct pci_device_id snd_nm256_ids[] = {
 	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256AV_AUDIO), 0},
 	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256ZX_AUDIO), 0},
 	{PCI_VDEVICE(NEOMAGIC, PCI_DEVICE_ID_NEOMAGIC_NM256XL_PLUS_AUDIO), 0},
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index ada6c25..74afb6b 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -97,7 +97,7 @@ enum {
 	MODEL_XONAR_DGX,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(oxygen_ids) = {
+static const struct pci_device_id oxygen_ids[] = {
 	/* C-Media's reference design */
 	{ OXYGEN_PCI_SUBID(0x10b0, 0x0216), .driver_data = MODEL_CMEDIA_REF },
 	{ OXYGEN_PCI_SUBID(0x10b0, 0x0217), .driver_data = MODEL_CMEDIA_REF },
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 64b9fda..ce33544 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(id, "ID string");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "enable card");
 
-static DEFINE_PCI_DEVICE_TABLE(xonar_ids) = {
+static const struct pci_device_id xonar_ids[] = {
 	{ OXYGEN_PCI_SUBID(0x1043, 0x8269) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x8275) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x82b7) },
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index d379b28..a4b05a2 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -102,7 +102,7 @@ enum {
 	PCI_ID_LAST
 };
 
-static DEFINE_PCI_DEVICE_TABLE(pcxhr_ids) = {
+static const struct pci_device_id pcxhr_ids[] = {
 	{ 0x10b5, 0x9656, 0x1369, 0xb001, 0, 0, PCI_ID_VX882HR, },
 	{ 0x10b5, 0x9656, 0x1369, 0xb101, 0, 0, PCI_ID_PCX882HR, },
 	{ 0x10b5, 0x9656, 0x1369, 0xb201, 0, 0, PCI_ID_VX881HR, },
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 56cc891..d29fa04 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -508,7 +508,7 @@ static int riptide_reset(struct cmdif *cif, struct snd_riptide *chip);
 /*
  */
 
-static DEFINE_PCI_DEVICE_TABLE(snd_riptide_ids) = {
+static const struct pci_device_id snd_riptide_ids[] = {
 	{ PCI_DEVICE(0x127a, 0x4310) },
 	{ PCI_DEVICE(0x127a, 0x4320) },
 	{ PCI_DEVICE(0x127a, 0x4330) },
@@ -517,7 +517,7 @@ static DEFINE_PCI_DEVICE_TABLE(snd_riptide_ids) = {
 };
 
 #ifdef SUPPORT_JOYSTICK
-static DEFINE_PCI_DEVICE_TABLE(snd_riptide_joystick_ids) = {
+static const struct pci_device_id snd_riptide_joystick_ids[] = {
 	{ PCI_DEVICE(0x127a, 0x4312) },
 	{ PCI_DEVICE(0x127a, 0x4322) },
 	{ PCI_DEVICE(0x127a, 0x4332) },
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index cc26346..ef93838 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -226,7 +226,7 @@ struct rme32 {
 	struct snd_kcontrol *spdif_ctl;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_rme32_ids) = {
+static const struct pci_device_id snd_rme32_ids[] = {
 	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32), 0,},
 	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_8), 0,},
 	{PCI_VDEVICE(XILINX_RME, PCI_DEVICE_ID_RME_DIGI32_PRO), 0,},
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 0236363..1211d36 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -263,7 +263,7 @@ struct rme96 {
 	struct snd_kcontrol   *spdif_ctl;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_rme96_ids) = {
+static const struct pci_device_id snd_rme96_ids[] = {
 	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96), 0, },
 	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96_8), 0, },
 	{ PCI_VDEVICE(XILINX, PCI_DEVICE_ID_RME_DIGI96_8_PRO), 0, },
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index f59a321..fd348ce 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -603,7 +603,7 @@ static void snd_hammerfall_free_buffer(struct snd_dma_buffer *dmab, struct pci_d
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(snd_hdsp_ids) = {
+static const struct pci_device_id snd_hdsp_ids[] = {
 	{
 		.vendor = PCI_VENDOR_ID_XILINX,
 		.device = PCI_DEVICE_ID_XILINX_HAMMERFALL_DSP,
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index e98dc00..c6bf321 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -1077,7 +1077,7 @@ struct hdspm {
 };
 
 
-static DEFINE_PCI_DEVICE_TABLE(snd_hdspm_ids) = {
+static const struct pci_device_id snd_hdspm_ids[] = {
 	{
 	 .vendor = PCI_VENDOR_ID_XILINX,
 	 .device = PCI_DEVICE_ID_XILINX_HAMMERFALL_DSP_MADI,
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index b96d9e1..18cf23d 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -313,7 +313,7 @@ static void snd_hammerfall_free_buffer(struct snd_dma_buffer *dmab, struct pci_d
 }
 
 
-static DEFINE_PCI_DEVICE_TABLE(snd_rme9652_ids) = {
+static const struct pci_device_id snd_rme9652_ids[] = {
 	{
 		.vendor	   = 0x10ee,
 		.device	   = 0x3fc4,
diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index e413b4e..196df18 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -52,7 +52,7 @@ MODULE_PARM_DESC(enable, "Enable SiS7019 Audio Accelerator.");
 module_param(codecs, int, 0444);
 MODULE_PARM_DESC(codecs, "Set bit to indicate that codec number is expected to be present (default 1)");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_sis7019_ids) = {
+static const struct pci_device_id snd_sis7019_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x7019) },
 	{ 0, }
 };
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 2a46bf9..bc929f3 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -242,7 +242,7 @@ struct sonicvibes {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_sonic_ids) = {
+static const struct pci_device_id snd_sonic_ids[] = {
 	{ PCI_VDEVICE(S3, 0xca00), 0, },
         { 0, }
 };
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index b3b588b..29a0d32 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(pcm_channels, "Number of hardware channels assigned for PCM.");
 module_param_array(wavetable_size, int, NULL, 0444);
 MODULE_PARM_DESC(wavetable_size, "Maximum memory size in kB for wavetable synth.");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_trident_ids) = {
+static const struct pci_device_id snd_trident_ids[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_TRIDENT, PCI_DEVICE_ID_TRIDENT_4DWAVE_DX), 
 		PCI_CLASS_MULTIMEDIA_AUDIO << 8, 0xffff00, 0},
 	{PCI_DEVICE(PCI_VENDOR_ID_TRIDENT, PCI_DEVICE_ID_TRIDENT_4DWAVE_NX), 
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 5ae6f04..7029142 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -404,7 +404,7 @@ struct via82xx {
 #endif
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_via82xx_ids) = {
+static const struct pci_device_id snd_via82xx_ids[] = {
 	/* 0x1106, 0x3058 */
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C686_5), TYPE_CARD_VIA686, },	/* 686A */
 	/* 0x1106, 0x3059 */
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index ca19028..7424c13 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -260,7 +260,7 @@ struct via82xx_modem {
 	struct snd_info_entry *proc_entry;
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_via82xx_modem_ids) = {
+static const struct pci_device_id snd_via82xx_modem_ids[] = {
 	{ PCI_VDEVICE(VIA, 0x3068), TYPE_CARD_VIA82XX_MODEM, },
 	{ 0, }
 };
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index ab8a9b1..c4fa2f7 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -60,7 +60,7 @@ enum {
 	VX_PCI_VX222_NEW
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snd_vx222_ids) = {
+static const struct pci_device_id snd_vx222_ids[] = {
 	{ 0x10b5, 0x9050, 0x1369, PCI_ANY_ID, 0, 0, VX_PCI_VX222_OLD, },   /* PLX */
 	{ 0x10b5, 0x9030, 0x1369, PCI_ANY_ID, 0, 0, VX_PCI_VX222_NEW, },   /* PLX */
 	{ 0, }
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index e8932b2..3e14fd7 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(joystick_port, "Joystick port address");
 module_param_array(rear_switch, bool, NULL, 0444);
 MODULE_PARM_DESC(rear_switch, "Enable shared rear/line-in switch");
 
-static DEFINE_PCI_DEVICE_TABLE(snd_ymfpci_ids) = {
+static const struct pci_device_id snd_ymfpci_ids[] = {
 	{ PCI_VDEVICE(YAMAHA, 0x0004), 0, },   /* YMF724 */
 	{ PCI_VDEVICE(YAMAHA, 0x000d), 0, },   /* YMF724F */
 	{ PCI_VDEVICE(YAMAHA, 0x000a), 0, },   /* YMF740 */
-- 
1.7.10.4


