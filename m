Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbbATMgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:36:11 -0500
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:43072
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755079AbbATMgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:36:08 -0500
From: Zidan Wang <zidan.wang@freescale.com>
To: <timur@tabi.org>
CC: <nicoleotsuka@gmail.com>, <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Zidan Wang <zidan.wang@freescale.com>
Subject: [alsa-devel][PATCH 0/3] Add master mode, tmd and right-j mode support
Date: Tue, 20 Jan 2015 20:21:17 +0800
Message-ID: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=zidan.wang@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(87936001)(50226001)(46102003)(47776003)(92566002)(62966003)(110136001)(64706001)(104016003)(77156002)(33646002)(85426001)(106466001)(36756003)(97736003)(105606002)(2351001)(6806004)(48376002)(68736005)(50466002)(77096005)(86362001)(50986999)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1255;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0301MB1255;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1255;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1255;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 12:20:35.1099
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1255
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1301;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sai master mode support.
Add tdm slots support.
Add Right-J mode support.

Zidan Wang (3):
  SoC: fsl_sai: add sai master mode support
  ASoC: fsl_sai: Add support for tdm slots operation
  ASoC: fsl_sai: Add support for Right-J mode

 sound/soc/fsl/fsl_sai.c | 164 ++++++++++++++++++++++++++++++++++++++++++++----
 sound/soc/fsl/fsl_sai.h |  13 +++-
 2 files changed, 164 insertions(+), 13 deletions(-)

-- 
1.9.1

