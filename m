Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3JBQKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:10:45 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:33439 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3JBQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:10:43 -0400
From: Kevin Mulvey <kevin@kevinmulvey.net>
To: rob@landley.net
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Mulvey <kevin@kevinmulvey.net>
Subject: [PATCH] Documentation: "kerneli" typo in description for "Serpent cipher algorithm" Bug #60848
Date: Wed,  2 Oct 2013 12:10:37 -0400
Message-Id: <1380730237-42543-1-git-send-email-kevin@kevinmulvey.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change kerneli to kernel as well as kerneli.org to kernel.org

Signed-off-by: Kevin Mulvey <kevin@kevinmulvey.net>
---
 Documentation/crypto/api-intro.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 8b49302..94c2e8c 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -155,7 +155,7 @@ of the API:
 
 Portions of this API were derived from the following projects:
   
-  Kerneli Cryptoapi (http://www.kerneli.org/)
+  Kernel Cryptoapi (http://www.kernel.org/)
     Alexander Kjeldaas
     Herbert Valerio Riedel
     Kyle McMartin
-- 
1.8.1.4

