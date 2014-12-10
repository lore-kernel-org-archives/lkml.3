Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaLJRJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:09:22 -0500
Received: from box2.japko.eu ([91.121.152.53]:42071 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbaLJRJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:09:21 -0500
Date: Wed, 10 Dec 2014 18:05:31 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: whitespace checkpatch warning fix.
Message-ID: <20141210170531.GA5833@japko.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following checkpatch.pl error:
ERROR: space prohibited before that ',' (ctx:WxW)

Signed-off-by: Krzysztof Adamski <k@japko.eu>
---
 drivers/staging/vt6656/rxtx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..5a18e26 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -55,7 +55,7 @@ static const u16 vnt_fb_opt0[2][5] = {
 
 static const u16 vnt_fb_opt1[2][5] = {
 	{RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, /* fallback_rate0 */
-	{RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, /* fallback_rate1 */
+	{RATE_6M,  RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, /* fallback_rate1 */
 };
 
 #define RTSDUR_BB       0
-- 
1.7.10.4

