Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaIAG0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:26:32 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39342 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaIAG0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:26:30 -0400
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, mikko.rapeli@iki.fi
Subject: [RFC PATCH v2 02/27] scripts/headers.sh: add verbose option to make calls if defined
Date: Mon,  1 Sep 2014 09:25:53 +0300
Message-Id: <1409552778-2537-3-git-send-email-mikko.rapeli@iki.fi>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
References: <1408660449-4011-1-git-send-email-mikko.rapeli@iki.fi>
 <1409552778-2537-1-git-send-email-mikko.rapeli@iki.fi>
X-SA-Exim-Connect-IP: 217.30.184.161
X-SA-Exim-Mail-From: mcfrisk@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful when debugging the scripts.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 scripts/headers.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/headers.sh b/scripts/headers.sh
index 978b42b..09e8a5c 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -7,7 +7,7 @@ set -e
 do_command()
 {
 	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
-		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
+		make V=$KBUILD_VERBOSE ARCH=$2 KBUILD_HEADERS=$1 headers_$1
 	else
 		printf "Ignoring arch: %s\n" ${arch}
 	fi
-- 
2.1.0

