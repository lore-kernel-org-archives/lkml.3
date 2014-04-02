Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbaDBU1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:27:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42818 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758852AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/40] X.509: struct x509_certificate needs struct tm declaring
Date: Wed,  2 Apr 2014 22:12:50 +0200
Message-Id: <6d0140574e782fd9b2cc6119d95280e7db3c3d52.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 57be4a784bf58eb41784aa3431165b455cf7e9c6 upstream.

struct x509_certificate needs struct tm declaring by #inclusion of linux/time.h
prior to its definition.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 crypto/asymmetric_keys/x509_parser.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index f86dc5fcc4ad..d9351ee19f18 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/time.h>
 #include <crypto/public_key.h>
 
 struct x509_certificate {
-- 
1.9.1

