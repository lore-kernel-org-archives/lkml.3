Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3C0Uwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 16:52:38 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:64196 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab3C0Uwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 16:52:36 -0400
Message-ID: <1364417548.1345.38.camel@x61.thuisdomein>
Subject: [PATCH] tokenring: delete last holdout of CONFIG_TR
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 21:52:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2013 20:52:28.0854 (UTC) FILETIME=[FE7DDD60:01CE2B2C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tokenring support was deleted in v3.5. One last holdout of the macro
CONFIG_TR escaped that fate. Until now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 include/linux/netdevice.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b3d00fa..05d142f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -144,8 +144,6 @@ static inline bool dev_xmit_complete(int rc)
 # else
 #  define LL_MAX_HEADER 96
 # endif
-#elif IS_ENABLED(CONFIG_TR)
-# define LL_MAX_HEADER 48
 #else
 # define LL_MAX_HEADER 32
 #endif
-- 
1.7.11.7

