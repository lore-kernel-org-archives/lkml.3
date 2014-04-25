Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaDYPY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:24:26 -0400
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:36992
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097AbaDYPYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:24:25 -0400
From: <dinguyen@altera.com>
To: <dinh.linux@gmail.com>, <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] clk: socfpga: Clock fix for v3.15
Date: Fri, 25 Apr 2014 10:22:02 -0500
Message-ID: <1398439322-30616-1-git-send-email-dinguyen@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(164054003)(377424004)(6806004)(31966008)(80976001)(4396001)(62966002)(46102001)(50226001)(81342001)(81542001)(74502001)(36756003)(74662001)(80022001)(50986999)(77982001)(84676001)(76482001)(92566001)(86152002)(47776003)(79102001)(92726001)(77156001)(20776003)(83072002)(88136002)(85852003)(2009001)(89996001)(19580395003)(87936001)(87286001)(53416003)(48376002)(99396002)(97736001)(44976005)(83322001)(50466002)(93916002)(33646001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB012;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:E5E9006C.1C319E48.EDD80AE.FE0D2CA.20193;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0192E812EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Please consider pulling this patch for 3.15 fixes.

Thanks,

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.rocketboards.org/linux-socfpga-next.git tags/socfpga-clk-fix-for-3.15

for you to fetch changes up to 812819daf3298040833b4902730821c3441bffc7:

  clk: socfpga: fix clock driver for 3.15 (2014-04-25 10:06:14 -0500)

----------------------------------------------------------------
clk: socfpga: clock fix for v3.15

Currently on 3.15-rc1, the SOCFPGA platform is unable to boot. This patch
fixes the issue and allows the platform to boot.

----------------------------------------------------------------
Dinh Nguyen (1):
      clk: socfpga: fix clock driver for 3.15

 drivers/clk/socfpga/clk-pll.c |    7 +++++++
 drivers/clk/socfpga/clk.c     |   23 +++--------------------
 2 files changed, 10 insertions(+), 20 deletions(-)
