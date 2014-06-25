Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaFYKmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:42:55 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:58951
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbaFYKmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:42:53 -0400
Date: Wed, 25 Jun 2014 16:08:11 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [PATCH][SCSI]mpt3sas: Description Patch
Message-ID: <20140625103811.GA12983@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481665709003185;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(6806004)(76506005)(19580395003)(19580405001)(97756001)(99396002)(85306003)(83506001)(50986999)(21056001)(83322001)(44976005)(36756003)(54356999)(77096002)(46406003)(47776003)(20776003)(81342001)(80022001)(64706001)(79102001)(50466002)(81542001)(74662001)(16796002)(74502001)(77982001)(46102001)(76482001)(31966008)(92726001)(102836001)(92566001)(87936001)(33656002)(83072002)(85852003)(86362001)(26826002)(57986006)(107046001)(106466001)(4396001)(95666004)(23726002)(105596002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB019;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just resending below set of patches which I have sent on 14th March 2014.
And I have removed below subjected patch since we have already have the
module parameter port_mask to disable EEDP support.
[PATCH 1/9][SCSI]mpt3sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---

[RESEND][PATCH 1/8][SCSI]mpt3sas: MPI2.5 Rev G (2.5.2) specifications.
[RESEND][PATCH 2/8][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[RESEND][PATCH 3/8][SCSI]mpt3sas: Bump mpt3sas driver version to 03.100.00.00.
[RESEND][PATCH 4/8][SCSI]mpt3sas: MPI2.5 Rev H (2.5.3) specifications.
[RESEND][PATCH 5/8][SCSI]mpt3sas: Copyright in driver sources is updated for year the 2014.
[RESEND][PATCH 6/8][SCSI]mpt3sas: Added OEM branding Strings.
[RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00.
