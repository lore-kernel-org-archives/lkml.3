Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaLETy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:54:28 -0500
Received: from mail-by2on0085.outbound.protection.outlook.com ([207.46.100.85]:43552
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbaLETyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:54:25 -0500
From: Graham Moore <grmoore@opensource.altera.com>
To: <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Graham Moore <grmoore@opensource.altera.com>
Subject: [PATCH 0/2]  mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller
Date: Fri, 5 Dec 2014 13:35:31 -0600
Message-ID: <1417808133-20719-1-git-send-email-grmoore@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR12CA0038.namprd12.prod.outlook.com (25.160.121.48) To
 BLUPR03MB437.namprd03.prod.outlook.com (10.141.78.147)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB437;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BLUPR03MB437;
X-Forefront-PRVS: 04163EF38A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(199003)(189002)(105586002)(106356001)(110136001)(81156004)(107046002)(229853001)(77156002)(21056001)(4396001)(50466002)(48376002)(50226001)(2351001)(40100003)(97736003)(122386002)(46102003)(69596002)(68736005)(77096005)(31966008)(101416001)(19580395003)(33646002)(64706001)(20776003)(47776003)(99396003)(66066001)(62966003)(120916001)(42186005)(86362001)(87976001)(53416004)(89996001)(50986999)(92566001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB437;H:lava-test-server.altera.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB437;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides a driver for the Cadence Quad SPI Flash Controller.
This controller is used on SOCFPGA systems.

The driver was tested on Altera's Cyclone5 and Arria5 dev kits, with
Micron n25q00 and n25q512 flash parts.

Comments from Ezequiel Garcia were incorporated.

Graham Moore (2):
  mtd: spi-nor: Bindings for Cadence Quad SPI Flash Controller driver.
  mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller.

 .../devicetree/bindings/mtd/cadence_quadspi.txt    |   50 +
 drivers/mtd/spi-nor/Kconfig                        |    6 +
 drivers/mtd/spi-nor/Makefile                       |    1 +
 drivers/mtd/spi-nor/cadence-quadspi.c              | 1281 ++++++++++++++++++++
 4 files changed, 1338 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/cadence_quadspi.txt
 create mode 100644 drivers/mtd/spi-nor/cadence-quadspi.c

-- 
1.7.9.5

