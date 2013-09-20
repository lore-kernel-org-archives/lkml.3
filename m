Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3ITUde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:33:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Markus Kreidl <markus.kreidl@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 01/93] Revert "net/core/sock.c: add missing VSOCK string in af_family_*_key_strings"
Date: Fri, 20 Sep 2013 13:07:56 -0700
Message-Id: <1379707768-1804-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

This reverts commit 98aab898043fdc0f63621dae282fb5448fc39f9a, which
was commit 456db6a4d495f40777da6f1f32f62f13026f52db upstream.

98aab89 should not have been applied to v3.8-stable since VSOCK is not
relevant for v3.8.

Cc: Federico Vaga <federico.vaga@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Markus Kreidl <markus.kreidl@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/sock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 57b3243..b8af814 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -208,7 +208,7 @@ static const char *const af_family_key_strings[AF_MAX+1] = {
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
   "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" , "sk_lock-AF_ALG"      ,
-  "sk_lock-AF_NFC"   , "sk_lock-AF_VSOCK"    , "sk_lock-AF_MAX"
+  "sk_lock-AF_NFC"   , "sk_lock-AF_MAX"
 };
 static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_UNSPEC", "slock-AF_UNIX"     , "slock-AF_INET"     ,
@@ -224,7 +224,7 @@ static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
   "slock-AF_IEEE802154", "slock-AF_CAIF" , "slock-AF_ALG"      ,
-  "slock-AF_NFC"   , "slock-AF_VSOCK"    ,"slock-AF_MAX"
+  "slock-AF_NFC"   , "slock-AF_MAX"
 };
 static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
@@ -240,7 +240,7 @@ static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_IEEE802154", "clock-AF_CAIF" , "clock-AF_ALG"      ,
-  "clock-AF_NFC"   , "clock-AF_VSOCK"    , "clock-AF_MAX"
+  "clock-AF_NFC"   , "clock-AF_MAX"
 };
 
 /*
-- 
1.8.1.2

