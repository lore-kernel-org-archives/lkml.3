Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbbAQBlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:41:45 -0500
Received: from mail-bl2on0127.outbound.protection.outlook.com ([65.55.169.127]:59424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbbAQBlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:41:44 -0500
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 20:41:43 EST
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>
Subject: [RFC PATCH 0/1] drivers/bus: Freescale Management Complex object allocator driver
Date: Fri, 16 Jan 2015 19:38:01 -0600
Message-ID: <1421458682-13773-1-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 2.2.2
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(339900001)(189002)(199003)(229853001)(47776003)(64706001)(77156002)(36756003)(62966003)(97736003)(104016003)(81156004)(106466001)(105606002)(92566002)(2201001)(50986999)(77096005)(6806004)(68736005)(69596002)(46102003)(85426001)(50226001)(87936001)(86362001)(48376002)(50466002)(217873001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB507;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR03MB507;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB507;
X-Forefront-PRVS: 04599F3534
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB507;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2015 01:41:40.0030
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB507
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces the object allocator driver for
the Freescale Management Complex (fsl-mc) of QorIQ Ls2 SoCs
This patch series is dependent on the patch series
"drivers/bus: Freescale Management Complex bus driver patch series"

Besides adding the object allocator functionality, this patch also
serves as an example of a driver for a child device of the fsl-mc
bus.

Patch 1 contains the object allocator driver

CHANGE HISTORY

Changes in RFC v1:
  - Initial version posted.

