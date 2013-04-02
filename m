Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112Ab3DBSlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:41:15 -0400
Received: from nm14-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.162]:25192
	"EHLO nm14-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760612Ab3DBSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:41:13 -0400
X-Yahoo-Newman-Id: 71673.76687.bm@smtp108.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZOZGyR8VM1migI6jrxuJeIbPFXSrFl5R6G9008f8Edv3bfo
 f0G4Lrzy.AjsnyHnyOsjDR9Z6OZH3n72WXRToFoMG8WnvFrSO.xyXgQTBLEO
 jV.ByATZwvKXLL4vWBtMbcA_vh_6C60IqF_gVNSFG2cnoe5g1R6AXZyQcRhi
 mxC.6PdckC51WpS7GRb0LdVcTbi68xE416dzAQBpy34fRpzkW2JQj10krQNX
 EKK.owDZkOhtAy93_DYhWVbn.HnKQhxPkPPniYpARgpBFA8oVISgSk3zDNbS
 nlceWXyIjn9ow9HrawYAZg5zgec.OCvY6jNMC.COY8jEnnmR2BzVDIg0FNua
 12sKaXGVDjeodeEgON12XsL5.d.rcNszzahBhg0rzHLXR4jaofWmi4MkojJZ
 Oiz_HRyZAGouesy6b_.RAhu5DruL9g8lhCiafuSgeEF1Ci1US505FAE0U_bk
 4A5qg
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp108.biz.mail.ne1.yahoo.com with SMTP; 02 Apr 2013 11:41:12 -0700 PDT
Message-ID: <515B264E.2020603@schaufler-ca.com>
Date: Tue, 02 Apr 2013 11:41:18 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: include magic.h in smackfs.c
References: <20130402190929.62cea8988921a2599588a566@canb.auug.org.au> <515B12EB.50303@infradead.org>
In-Reply-To: <515B12EB.50303@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported for linux-next: Tree for Apr 2 (smack)
Add the required include for smackfs.c

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/smack/smackfs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 2479a41..53a08b8 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -26,6 +26,7 @@
 #include <linux/seq_file.h>
 #include <linux/ctype.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include "smack.h"
 
 /*

