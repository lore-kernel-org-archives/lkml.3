Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3IQLPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:15:02 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63904 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3IQLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:14:59 -0400
Subject: [PATCH 2/2] X.509: add module description and license
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 17 Sep 2013 15:14:55 +0400
Message-ID: <20130917111455.12333.27091.stgit@zurg>
In-Reply-To: <20130917111452.12333.1997.stgit@zurg>
References: <20130917111452.12333.1997.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes lack of license, otherwise x509_key_parser.ko taints kernel.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 crypto/asymmetric_keys/x509_public_key.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..0325212 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -237,3 +237,6 @@ static void __exit x509_key_exit(void)
 
 module_init(x509_key_init);
 module_exit(x509_key_exit);
+
+MODULE_DESCRIPTION("X.509 certificate parser");
+MODULE_LICENSE("GPL");

