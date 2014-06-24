Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaFXVQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:16:54 -0400
Received: from [207.46.163.186] ([207.46.163.186]:59095 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082AbaFXVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:16:51 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alex.williamson@redhat.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/3] iommu/fsl: Fix the device domain attach condition.
Date: Tue, 24 Jun 2014 19:27:16 +0530
Message-ID: <1403618237-26248-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(31966008)(50226001)(62966002)(102836001)(621065002)(85306003)(74502001)(73894003)(77156001)(74662001)(44976005)(4396001)(92726001)(92566001)(68736004)(104166001)(76482001)(104016002)(77982001)(6806004)(50466002)(79102001)(50986999)(89996001)(2201001)(46102001)(87936001)(48376002)(95666004)(87286001)(88136002)(105606002)(84676001)(81542001)(64706001)(83322001)(93916002)(86362001)(36756003)(81342001)(47776003)(106466001)(97736001)(21056001)(20776003)(83072002)(26826002)(99396002)(85852003)(80022001)(76176999)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB476;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Varun.Sethi@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


