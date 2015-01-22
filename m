Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbAVKJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:09:48 -0500
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:29324
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750861AbbAVKJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:09:43 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 05:09:42 EST
Message-ID: <1421920440.2590.3.camel@leyfoon-vm>
Subject: [GIT PULL] arch/nios2 for 3.19-rc6
From: Ley Foon Tan <lftan@altera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>
Date: Thu, 22 Jan 2015 17:54:00 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(377424004)(33646002)(19580395003)(47776003)(97736003)(64706001)(6806004)(50986999)(87936001)(33716001)(77156002)(62966003)(23676002)(106466001)(42186005)(575784001)(86362001)(50226001)(68736005)(103116003)(46102003)(92566002)(50466002)(110136001)(105596002)(229853001)(7099025)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1254;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0301MB1254;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1254;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1254;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 09:54:05.5279
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1254
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1287;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There is one arch/nios2 fix for 3.19.
Please consider pulling.

Regards
Ley Foon

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.rocketboards.org/linux-socfpga-next.git tags/nios2-fixes-v3.19-rc6

for you to fetch changes up to d24c8163b755be4a47482ab8240090d56ca8ef9b:

  nios2: fix kuser trampoline address (2015-01-22 17:05:16 +0800)

----------------------------------------------------------------
nios2 fixes for v3.19-rc6
- fix kuser trampoline address.

----------------------------------------------------------------
Ley Foon Tan (1):
      nios2: fix kuser trampoline address

 arch/nios2/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

