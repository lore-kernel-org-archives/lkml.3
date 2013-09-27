Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3I0S2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:28:24 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:59609 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3I0S2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:28:21 -0400
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [RESEND] snd-ac97-codec: Add ID for TI TLV320AIC27 codec
From: Ondrej Zary <linux@rainbow-software.org>
Date: Fri, 27 Sep 2013 20:27:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309272027.59117.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 0x54584e03 ID for TI TLV320AIC27 AC'97 codec according to datasheet:
http://www.ti.com/lit/ds/slas253a/slas253a.pdf

The weird thing is that the chip is physically marked 320AD91.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/pci/ac97/ac97_codec.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 445ca48..bf578ba2 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -175,6 +175,7 @@ static const struct ac97_codec_id snd_ac97_codec_ids[] = {
 { 0x54524106, 0xffffffff, "TR28026",		NULL,		NULL },
 { 0x54524108, 0xffffffff, "TR28028",		patch_tritech_tr28028,	NULL }, // added by xin jin [07/09/99]
 { 0x54524123, 0xffffffff, "TR28602",		NULL,		NULL }, // only guess --jk [TR28023 = eMicro EM28023 (new CT1297)]
+{ 0x54584e03, 0xffffffff, "TLV320AIC27",	NULL,		NULL },
 { 0x54584e20, 0xffffffff, "TLC320AD9xC",	NULL,		NULL },
 { 0x56494161, 0xffffffff, "VIA1612A",		NULL,		NULL }, // modified ICE1232 with S/PDIF
 { 0x56494170, 0xffffffff, "VIA1617A",		patch_vt1617a,	NULL }, // modified VT1616 with S/PDIF
-- 
Ondrej Zary
