Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3EIKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:40:48 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44000 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3EIKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:40:45 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 19/21] MIPS: MSP71xx: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:57 +0400
Message-Id: <1368095819-11011-8-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/mips/pmcs-msp71xx/msp_prom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/pmcs-msp71xx/msp_prom.c b/arch/mips/pmcs-msp71xx/msp_prom.c
index 0edb89a..1c98975 100644
--- a/arch/mips/pmcs-msp71xx/msp_prom.c
+++ b/arch/mips/pmcs-msp71xx/msp_prom.c
@@ -83,7 +83,7 @@ static inline unsigned char str2hexnum(unsigned char c)
 	return 0; /* foo */
 }
 
-static inline int str2eaddr(unsigned char *ea, unsigned char *str)
+int str2eaddr(unsigned char *ea, unsigned char *str)
 {
 	int index = 0;
 	unsigned char num = 0;
-- 
1.8.1.4

