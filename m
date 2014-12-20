Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaLTQrw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:47:52 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43685 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaLTQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:47:49 -0500
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCHv2 1/1] staging: rtl8723au: Fix sparse invalid assignment warnings
Date: Sat, 20 Dec 2014 18:47:27 +0200
Message-Id: <1419094047-16107-1-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1418567365-18168-1-git-send-email-giannis.damigos@gmail.com>
References: <1418567365-18168-1-git-send-email-giannis.damigos@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the hal/rtl8723au_xmit.c file that fixes the
following warnings found by sparse tool:

drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:88:22: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:88:22:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:88:22:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:91:22: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:91:22:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:91:22:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:99:22: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:99:22:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:99:22:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:103:30: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:103:30:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:103:30:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:106:38: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:106:38:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:106:38:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:108:38: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:108:38:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:108:38:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:112:38: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:112:38:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:112:38:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:120:22: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:120:22:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:120:22:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:123:30: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:123:30:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:123:30:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:125:30: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:125:30:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:125:30:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:129:30: warning: invalid assignment: |=
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:129:30:    left side has type unsigned int
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:129:30:    right side has type restricted __le32
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:184:51: warning: incorrect type in argument 2 (different base types)
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:184:51:    expected unsigned int [usertype] *pdw
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:184:51:    got restricted __le32 *<noident>
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:185:51: warning: incorrect type in argument 2 (different base types)
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:185:51:    expected unsigned int [usertype] *pdw
drivers/staging/rtl8723au//hal/rtl8723au_xmit.c:185:51:    got restricted __le32 *<noident>

Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
index 6070510..1759487 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
@@ -79,7 +79,7 @@ static void fill_txdesc_sectype(struct pkt_attrib *pattrib, struct tx_desc *ptxd
 	}
 }
 
-static void fill_txdesc_vcs(struct pkt_attrib *pattrib, u32 *pdw)
+static void fill_txdesc_vcs(struct pkt_attrib *pattrib, __le32 *pdw)
 {
 	/* DBG_8723A("cvs_mode =%d\n", pattrib->vcs_mode); */
 
@@ -114,7 +114,7 @@ static void fill_txdesc_vcs(struct pkt_attrib *pattrib, u32 *pdw)
 	}
 }
 
-static void fill_txdesc_phy(struct pkt_attrib *pattrib, u32 *pdw)
+static void fill_txdesc_phy(struct pkt_attrib *pattrib, __le32 *pdw)
 {
 	if (pattrib->ht_en) {
 		*pdw |= (pattrib->bwmode&HT_CHANNEL_WIDTH_40) ? cpu_to_le32(BIT(25)) : 0;
-- 
2.2.1

