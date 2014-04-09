Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbaDIRHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:07:53 -0400
Received: from mailscanner02.zoner.fi ([84.34.166.11]:37824 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaDIRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:07:52 -0400
Date: Wed, 9 Apr 2014 20:07:22 +0300
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dpc@ucore.info, linux-kernel@vger.kernel.org
Subject: [PATCH] xz: Add comments for the intentionally missing break
 statements
Message-ID: <20140409200722.53ace0d4@tukaani.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

 lib/xz/xz_dec_lzma2.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -Narup linux-3.14.orig/lib/xz/xz_dec_lzma2.c linux-3.14/lib/xz/xz_dec_lzma2.c
--- linux-3.14.orig/lib/xz/xz_dec_lzma2.c	2014-03-31 06:40:15.000000000 +0300
+++ linux-3.14/lib/xz/xz_dec_lzma2.c	2014-04-09 18:20:01.229614074 +0300
@@ -1043,6 +1043,8 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 
 			s->lzma2.sequence = SEQ_LZMA_PREPARE;
 
+		/* Fall through */
+
 		case SEQ_LZMA_PREPARE:
 			if (s->lzma2.compressed < RC_INIT_BYTES)
 				return XZ_DATA_ERROR;
@@ -1053,6 +1055,8 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 			s->lzma2.compressed -= RC_INIT_BYTES;
 			s->lzma2.sequence = SEQ_LZMA_RUN;
 
+		/* Fall through */
+
 		case SEQ_LZMA_RUN:
 			/*
 			 * Set dictionary limit to indicate how much we want
