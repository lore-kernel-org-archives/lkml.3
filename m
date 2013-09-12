Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3ILSyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:54:18 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:53227 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3ILSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:54:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] snd-ac97-codec: Add ID for TI TLV320AIC27 codec
Date: Thu, 12 Sep 2013 20:54:01 +0200
Message-Id: <1379012042-4382-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
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

