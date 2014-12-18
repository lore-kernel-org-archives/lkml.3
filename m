Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaLRF7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:59:30 -0500
Received: from mail-by2on0069.outbound.protection.outlook.com ([207.46.100.69]:19040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbaLRF72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:59:28 -0500
Message-ID: <1418882361.3907.1.camel@leyfoon-vm>
Subject: [GIT PULL] arch/nios2 fixes for 3.19
From: Ley Foon Tan <lftan@altera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <lftan.linux@gmail.com>
Date: Thu, 18 Dec 2014 13:59:21 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(377424004)(199003)(46102003)(86362001)(33646002)(89996001)(87936001)(120916001)(20776003)(47776003)(50466002)(64706001)(31966008)(42186005)(92566001)(50226001)(575784001)(4396001)(106466001)(107046002)(229853001)(68736005)(23676002)(84676001)(110136001)(77156002)(97736003)(50986999)(33716001)(99396003)(6806004)(62966003)(103116003)(105596002)(19580395003)(21056001)(7099022)(99106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB211;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2014 05:59:25.4699
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB211
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB579;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

There are 3 arch/nios2 fixes for 3.19.
Please consider pulling.

Regards
Ley Foon

The following changes since commit 603ba7e41bf5d405aba22294af5d075d8898176d:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2014-12-16 15:53:03 -0800)

are available in the git repository at:


  git://git.rocketboards.org/linux-socfpga-next.git tags/nios2-fixes-v3.19

for you to fetch changes up to f1f2eac9124bf0dc82b652871f9a596bce2d3e10:

  nios2/uaccess: fix sparse errors (2014-12-17 13:53:41 +0800)

----------------------------------------------------------------
nios2 fixes for v3.19
- add definition of ioremap_wc to io.h to fix build error from make allmodconfig
- fix make defconfig
- fix sparse error
----------------------------------------------------------------
Guenter Roeck (1):
      nios2: add definition of ioremap_wc to io.h

Ley Foon Tan (1):
      nios2/uaccess: fix sparse errors

Paul Bolle (1):
      nios2: enable "make defconfig"

 arch/nios2/Makefile              | 2 ++
 arch/nios2/include/asm/io.h      | 2 ++
 arch/nios2/include/asm/uaccess.h | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

