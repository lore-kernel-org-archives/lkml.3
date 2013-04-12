Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3DLLGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:06:07 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:58656 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3DLLGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:06:05 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <inux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] ARM: daVinci: dm644x/dm355/dm365: replace V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL
Date: Fri, 12 Apr 2013 16:35:34 +0530
Message-Id: <1365764734-16515-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch replaces V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL
respectively as this are the proper video standards.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 Note:- This patch is on top of following pull
  https://patchwork.linuxtv.org/patch/17888/

 arch/arm/mach-davinci/board-dm355-evm.c  |    4 ++--
 arch/arm/mach-davinci/board-dm365-evm.c  |    4 ++--
 arch/arm/mach-davinci/board-dm644x-evm.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 1043506..886481c 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -247,7 +247,7 @@ static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
 	{
 		.name		= "ntsc",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_525_60,
+		.std_id		= V4L2_STD_NTSC,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 480,
@@ -259,7 +259,7 @@ static struct vpbe_enc_mode_info dm355evm_enc_preset_timing[] = {
 	{
 		.name		= "pal",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_625_50,
+		.std_id		= V4L2_STD_PAL,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 576,
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 0518ce5..2a66743 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -381,7 +381,7 @@ static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
 	{
 		.name		= "ntsc",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_525_60,
+		.std_id		= V4L2_STD_NTSC,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 480,
@@ -393,7 +393,7 @@ static struct vpbe_enc_mode_info dm365evm_enc_std_timing[] = {
 	{
 		.name		= "pal",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_625_50,
+		.std_id		= V4L2_STD_PAL,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 576,
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index a021800..745280d 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -622,7 +622,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
 	{
 		.name		= "ntsc",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_525_60,
+		.std_id		= V4L2_STD_NTSC,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 480,
@@ -634,7 +634,7 @@ static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
 	{
 		.name		= "pal",
 		.timings_type	= VPBE_ENC_STD,
-		.std_id		= V4L2_STD_625_50,
+		.std_id		= V4L2_STD_PAL,
 		.interlaced	= 1,
 		.xres		= 720,
 		.yres		= 576,
-- 
1.7.4.1

