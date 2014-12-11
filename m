Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaLKMT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:19:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:4453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaLKMTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:19:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="622146536"
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
To: alsa-devel@alsa-project.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sound: oss: Remove dead sound card number definitions part #2
Date: Thu, 11 Dec 2014 14:19:13 +0200
Message-Id: <1418300353-13243-4-git-send-email-jarkko.nikula@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418300353-13243-1-git-send-email-jarkko.nikula@linux.intel.com>
References: <1418300353-13243-1-git-send-email-jarkko.nikula@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these is used in kernel tree.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
RFC, I don't know can these be used in user-space?
---
 include/uapi/linux/soundcard.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/include/uapi/linux/soundcard.h b/include/uapi/linux/soundcard.h
index f3b21f989872..d2256bf4bdd8 100644
--- a/include/uapi/linux/soundcard.h
+++ b/include/uapi/linux/soundcard.h
@@ -48,32 +48,10 @@
  *	Supported card ID numbers (Should be somewhere else?)
  */
 
-#define SNDCARD_ADLIB		1
 #define SNDCARD_SB		2
 #define SNDCARD_PAS		3
-#define SNDCARD_GUS		4
 #define SNDCARD_MPU401		5
-#define SNDCARD_SB16		6
-#define SNDCARD_SB16MIDI	7
 #define SNDCARD_UART6850	8
-#define SNDCARD_GUS16		9
-#define SNDCARD_MSS		10
-#define SNDCARD_PSS     	11
-#define SNDCARD_SSCAPE		12
-#define SNDCARD_PSS_MPU     	13
-#define SNDCARD_PSS_MSS     	14
-#define SNDCARD_SSCAPE_MSS	15
-#define SNDCARD_TRXPRO		16
-#define SNDCARD_TRXPRO_SB	17
-#define SNDCARD_TRXPRO_MPU	18
-#define SNDCARD_MAD16		19
-#define SNDCARD_MAD16_MPU	20
-#define SNDCARD_CS4232		21
-#define SNDCARD_CS4232_MPU	22
-#define SNDCARD_MAUI		23
-#define SNDCARD_PSEUDO_MSS	24
-#define SNDCARD_GUSPNP		25
-#define SNDCARD_UART401		26
 /* Sound card numbers 27 to N are reserved. Don't add more numbers here. */
 
 /***********************************
-- 
2.1.3

