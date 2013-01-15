Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab3AOWt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:49:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:45778 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091Ab3AOWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:49:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 050/171] staging: vt6656: 64 bit fixes : correct all type sizes
Date: Tue, 15 Jan 2013 14:43:35 -0800
Message-Id: <20130115224317.033399537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 7730492855a2f9c828599bcd8d62760f96d319e4 upstream.

After this patch all BYTE/WORD/DWORD types can be replaced with the appropriate u sizes.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/ttype.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

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
@@ -62,8 +62,8 @@ typedef UQuadWord       QWORD;
 
 /****** Common pointer types ***********************************************/
 
-typedef unsigned long   ULONG_PTR;      // 32-bit
-typedef unsigned long   DWORD_PTR;      // 32-bit
+typedef u32 ULONG_PTR;
+typedef u32 DWORD_PTR;
 
 // boolean pointer
 


