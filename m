Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3CLWnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:43:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3CLWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 067/100] CIFS: Fix missing of oplock_read value in smb30_values structure
Date: Tue, 12 Mar 2013 15:31:52 -0700
Message-Id: <20130312223130.149057958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 067785c40e52089993757afa28988c05f3cb2694 upstream.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2ops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -744,4 +744,5 @@ struct smb_version_values smb30_values =
 	.cap_unix = 0,
 	.cap_nt_find = SMB2_NT_FIND,
 	.cap_large_files = SMB2_LARGE_FILES,
+	.oplock_read = SMB2_OPLOCK_LEVEL_II,
 };


