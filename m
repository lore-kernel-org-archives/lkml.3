Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3GKG4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:56:47 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44516 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3GKG4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:56:46 -0400
From: Cosmin Stanescu <cosmin90stanescu@gmail.com>
To: davem@davemloft.net
Cc: dhowells@redhat.com, ebiederm@xmission.com, rusty@rustcorp.com.au,
        serge.hallyn@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] strict_strtoul in (obsolete) changed to kstrtoul
Date: Thu, 11 Jul 2013 09:56:32 +0300
Message-Id: <1373525792-9106-1-git-send-email-cosmin90stanescu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: “Cosmin <“cosmin90stanescu@gmail.com”>

Signed-off-by: “Cosmin <“cosmin90stanescu@gmail.com”>
---
 net/dns_resolver/dns_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 0a69d07..f347a2c 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -118,7 +118,7 @@ dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 				if (opt_vlen <= 0)
 					goto bad_option_value;
 
-				ret = strict_strtoul(eq, 10, &derrno);
+				ret = kstrtoul(eq, 10, &derrno);
 				if (ret < 0)
 					goto bad_option_value;
 
-- 
1.7.10.4

