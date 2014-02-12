Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaBLPqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaBLPqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:46:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/4] Sparc: sparc_cpu_model isn't in asm/system.h any more
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Feb 2014 15:45:59 +0000
Message-ID: <20140212154559.2405.3104.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc_cpu_model isn't in asm/system.h any more, so remove a comment about it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: sparclinux@vger.kernel.org
---

 drivers/sbus/char/jsflash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 6b4678a..018b64b 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -507,11 +507,9 @@ static int jsflash_init(void)
 	}
 
 	/* Let us be really paranoid for modifications to probing code. */
-	/* extern enum sparc_cpu sparc_cpu_model; */ /* in <asm/system.h> */
-	if (sparc_cpu_model != sun4m) {
+	if (sparc_cpu_model != sun4m)
 		/* We must be on sun4m because we use MMU Bypass ASI. */
 		return -ENXIO;
-	}
 
 	if (jsf0.base == 0) {
 		jsf = &jsf0;

