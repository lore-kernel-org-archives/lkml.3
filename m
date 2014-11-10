Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaKJTY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:24:59 -0500
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:28919
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752143AbaKJTY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:24:57 -0500
X-WSS-ID: 0NEU8LB-08-XPN-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <bhelgaas@google.com>
CC: <liviu.dudau@arm.com>, <lorenzo.pieralisi@arm.com>, <will.deacon@arm.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2] PCI: generic: Assiging msi-controller to PCI hostbridge
Date: Mon, 10 Nov 2014 13:24:38 -0600
Message-ID: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50986999)(50226001)(99396003)(84676001)(106466001)(4396001)(101416001)(105586002)(19580395003)(44976005)(19580405001)(102836001)(87286001)(87936001)(110136001)(86362001)(93916002)(89996001)(68736004)(46102003)(31966008)(33646002)(2351001)(107046002)(88136002)(86152002)(92726001)(92566001)(53416004)(120916001)(104166001)(48376002)(47776003)(62966003)(77096003)(21056001)(95666004)(229853001)(77156002)(50466002)(36756003)(20776003)(64706001)(97736003)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces a new callback function to allow PCI host drivers
to specify MSI controller to be used for the child buses / devices.

This is reabased from:
    git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/host-generic

Suravee Suthikulpanit (2):
  PCI: Add new pci_ops for setting MSI parent for PCI bus
  PCI: generic: Add set_msi_parent callback

 drivers/pci/host/pci-host-generic.c | 14 ++++++++++++++
 drivers/pci/probe.c                 |  3 +++
 include/linux/pci.h                 |  1 +
 3 files changed, 18 insertions(+)

-- 
1.9.3

