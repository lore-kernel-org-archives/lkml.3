Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbaGPAMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:12:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760AbaGOXNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 26/44] drm/radeon: fix typo in golden register setup on evergreen
Date: Tue, 15 Jul 2014 16:17:24 -0700
Message-Id: <20140715231647.473104936@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231646.690728348@linuxfoundation.org>
References: <20140715231646.690728348@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6abafb78f9881b4891baf74ab4e9f090ae45230e upstream.

Fixes hangs on driver load on some cards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76998

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -94,7 +94,7 @@ static const u32 evergreen_golden_regist
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002,
 	0x913c, 0x0000000f, 0x0000000a
 };
@@ -381,7 +381,7 @@ static const u32 cedar_golden_registers[
 	0x8c1c, 0xffffffff, 0x00001010,
 	0x28350, 0xffffffff, 0x00000000,
 	0xa008, 0xffffffff, 0x00010000,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x9508, 0xffffffff, 0x00000002
 };
 
@@ -540,7 +540,7 @@ static const u32 juniper_mgcg_init[] =
 static const u32 supersumo_golden_registers[] =
 {
 	0x5eb4, 0xffffffff, 0x00000002,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x7030, 0xffffffff, 0x00000011,
 	0x7c30, 0xffffffff, 0x00000011,
 	0x6104, 0x01000300, 0x00000000,
@@ -624,7 +624,7 @@ static const u32 sumo_golden_registers[]
 static const u32 wrestler_golden_registers[] =
 {
 	0x5eb4, 0xffffffff, 0x00000002,
-	0x5cc, 0xffffffff, 0x00000001,
+	0x5c4, 0xffffffff, 0x00000001,
 	0x7030, 0xffffffff, 0x00000011,
 	0x7c30, 0xffffffff, 0x00000011,
 	0x6104, 0x01000300, 0x00000000,


