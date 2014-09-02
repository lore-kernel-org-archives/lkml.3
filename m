Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaIBMwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:52:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaIBMwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:52:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/5] KEYS: Set pr_fmt() in asymmetric key signature handling
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2014 13:52:15 +0100
Message-ID: <20140902125215.9247.33312.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing in base signature handling should have a prefix, so set pr_fmt().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/signature.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 50b3f880b4ff..7525fd183574 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -11,6 +11,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) "SIG: "fmt
 #include <keys/asymmetric-subtype.h>
 #include <linux/module.h>
 #include <linux/err.h>

