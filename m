Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaGIPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720AbaGIPQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:16:50 -0400
Subject: [PATCH09/17] KEYS: X.509: Fix a spelling mistake
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:16:23 +0100
Message-ID: <20140709151623.23074.80430.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index b6df198..14cac28 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -33,7 +33,7 @@ config X509_CERTIFICATE_PARSER
 	select ASN1
 	select OID_REGISTRY
 	help
-	  This option procides support for parsing X.509 format blobs for key
+	  This option provides support for parsing X.509 format blobs for key
 	  data and provides the ability to instantiate a crypto key from a
 	  public key packet found inside the certificate.
 

