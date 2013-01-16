Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3APQHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36580 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3APQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 160/222] staging: vt6656: 64 bit fixes : correct all type sizes
Date: Wed, 16 Jan 2013 13:56:00 -0200
Message-Id: <1358351822-7675-161-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 7730492855a2f9c828599bcd8d62760f96d319e4 upstream.

After this patch all BYTE/WORD/DWORD types can be replaced with the appropriate u sizes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/vt6656/ttype.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
index 0f70562c..dfbf747 100644
--- a/drivers/staging/vt6656/ttype.h
+++ b/drivers/staging/vt6656/ttype.h
@@ -44,9 +44,9 @@ typedef int             BOOL;
 
 /****** Simple typedefs  ***************************************************/
 
-typedef unsigned char   BYTE;           //  8-bit
-typedef unsigned short  WORD;           // 16-bit
-typedef unsigned long   DWORD;          // 32-bit
+typedef u8 BYTE;
+typedef u16 WORD;
+typedef u32 DWORD;
 
 // QWORD is for those situation that we want
 // an 8-byte-aligned 8 byte long structure
@@ -62,8 +62,8 @@ typedef UQuadWord       QWORD;          // 64-bit
 
 /****** Common pointer types ***********************************************/
 
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
+typedef u32 ULONG_PTR;
+typedef u32 DWORD_PTR;
 
 // boolean pointer
 
-- 
1.7.9.5

