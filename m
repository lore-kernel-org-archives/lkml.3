Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaIJVW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaIJVWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/6] PKCS#7: Add a missing static
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:22:17 +0100
Message-ID: <20140910212217.10752.41774.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing static (found by checker).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_trust.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index e666eb011a85..fad888ea4fad 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -23,9 +23,9 @@
 /**
  * Check the trust on one PKCS#7 SignedInfo block.
  */
-int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
-			     struct pkcs7_signed_info *sinfo,
-			     struct key *trust_keyring)
+static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
+				    struct pkcs7_signed_info *sinfo,
+				    struct key *trust_keyring)
 {
 	struct public_key_signature *sig = &sinfo->sig;
 	struct x509_certificate *x509, *last = NULL, *p;

