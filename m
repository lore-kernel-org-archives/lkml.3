Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaLaHLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 02:11:04 -0500
Received: from mail-bn1on0078.outbound.protection.outlook.com ([157.56.110.78]:20590
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbaLaHLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 02:11:02 -0500
Message-ID: <1420009853.2896.10.camel@leyfoon-vm>
Subject: [GIT PULL] arch/nios2 fixes for 3.19-rc3
From: Ley Foon Tan <lftan@altera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>
Date: Wed, 31 Dec 2014 15:10:53 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(377424004)(50986999)(87936001)(99396003)(84676001)(229853001)(68736005)(110136001)(86362001)(97736003)(103116003)(62966003)(92566001)(107046002)(575784001)(64706001)(46102003)(47776003)(23676002)(105596002)(33716001)(6806004)(4396001)(106466001)(21056001)(20776003)(89996001)(31966008)(77156002)(33646002)(19580395003)(42186005)(50226001)(50466002)(120916001)(7099022)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB213;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB213;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB213;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB213;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 07:10:57.8083
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB213
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB101;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There are 2 arch/nios2 fixes for 3.19.
Please consider pulling.

Happy new year.

Regards
Ley Foon


The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.rocketboards.org/linux-socfpga-next.git tags/nios2-fixes-v3.19-rc3

for you to fetch changes up to 1b0f44923e186b2f9383b3260f6b5fbfc77b9e4a:

  nios2: Use preempt_schedule_irq (2014-12-31 11:04:58 +0800)

----------------------------------------------------------------
nios2 fixes for v3.19-rc3
- fix compilation error when enable CONFIG_PREEMPT
- initialize cpuinfo.mmu variable supplied by the device tree

----------------------------------------------------------------
Tobias Klauser (1):
      nios2: Use preempt_schedule_irq

Walter Goossens (1):
      nios2: Initialize cpuinfo.mmu

 arch/nios2/kernel/cpuinfo.c |  1 +
 arch/nios2/kernel/entry.S   | 20 ++------------------
 2 files changed, 3 insertions(+), 18 deletions(-)

