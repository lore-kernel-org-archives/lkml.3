Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaIJVX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbaIJVWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/6] KEYS: Fix missing statics
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:22:11 +0100
Message-ID: <20140910212211.10752.48243.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing statics (found by checker).

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 security/keys/request_key_auth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/request_key_auth.c b/security/keys/request_key_auth.c
index 842e6f410d50..739e7455d388 100644
--- a/security/keys/request_key_auth.c
+++ b/security/keys/request_key_auth.c
@@ -44,12 +44,12 @@ struct key_type key_type_request_key_auth = {
 	.read		= request_key_auth_read,
 };
 
-int request_key_auth_preparse(struct key_preparsed_payload *prep)
+static int request_key_auth_preparse(struct key_preparsed_payload *prep)
 {
 	return 0;
 }
 
-void request_key_auth_free_preparse(struct key_preparsed_payload *prep)
+static void request_key_auth_free_preparse(struct key_preparsed_payload *prep)
 {
 }
 

