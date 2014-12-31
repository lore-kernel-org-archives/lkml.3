Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaLaDik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 22:38:40 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:37699
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752058AbaLaDie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 22:38:34 -0500
From: Zidan Wang <b50113@freescale.com>
To: <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <lars@metafoo.de>, <ckeepax@opensource.wolfsonmicro.com>,
        <Li.Xiubo@freescale.com>, <patches@opensource.wolfsonmicro.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Zidan Wang <b50113@freescale.com>
Subject: [alsa-devel][PATCH 4/4] ASoC: wm8960: Fix capture sample rate from 11250 to 11025
Date: Wed, 31 Dec 2014 11:39:14 +0800
Message-ID: <1419997154-860-4-git-send-email-b50113@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419997154-860-1-git-send-email-b50113@freescale.com>
References: <1419997154-860-1-git-send-email-b50113@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(97736003)(4396001)(50226001)(31966008)(120916001)(2351001)(36756003)(50986999)(62966003)(68736005)(92566001)(76176999)(33646002)(86362001)(21056001)(77156002)(89996001)(104016003)(50466002)(2950100001)(87936001)(48376002)(107046002)(99396003)(77096005)(6806004)(69596002)(110136001)(84676001)(46102003)(81156004)(47776003)(85426001)(106466001)(19580395003)(19580405001)(20776003)(229853001)(64706001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1253;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1253;
X-Forefront-PRVS: 0442E569BC
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 03:38:30.2136
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8960 codec can't support sample rate 11250, it must be 11025.

Signed-off-by: Zidan Wang <b50113@freescale.com>
---
 sound/soc/codecs/wm8960.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index cb42385..68790f1 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -560,7 +560,7 @@ static struct {
 	{ 22050, 2 },
 	{ 24000, 2 },
 	{ 16000, 3 },
-	{ 11250, 4 },
+	{ 11025, 4 },
 	{ 12000, 4 },
 	{  8000, 5 },
 };
-- 
1.9.1

