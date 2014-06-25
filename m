Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaFYKeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:34:36 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:27345
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753613AbaFYKee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:34:34 -0400
Date: Wed, 25 Jun 2014 15:59:37 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [PATCH][SCSI]mpt2sas: Description Patch
Message-ID: <20140625102937.GA12856@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481660531399709;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77096002)(106466001)(46102001)(57986006)(85306003)(23726002)(36756003)(107046001)(76506005)(74502001)(54356999)(99396002)(80022001)(6806004)(83506001)(33656002)(50466002)(47776003)(64706001)(74662001)(31966008)(105596002)(87936001)(20776003)(16796002)(46406003)(95666004)(4396001)(85852003)(26826002)(92566001)(19580395003)(44976005)(79102001)(97756001)(19580405001)(76482001)(81542001)(77982001)(83322001)(86362001)(50986999)(21056001)(83072002)(102836001)(92726001)(81342001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB025;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
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
[PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---

[RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter max_msix_vectors.
[RESEND][PATCH 02/10][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications.
[RESEND][PATCH 03/10][SCSI]mpt2sas: Copyright in driver sources is updated for year the 2014.
[RESEND][PATCH 04/10][SCSI]mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[RESEND][PATCH 05/10][SCSI]mpt2sas: Bump mpt2sas driver version to 17.100.00.00.
[RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive.
[RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
[RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition.
[RESEND][PATCH 10/10][SCSI]mpt2sas: Bump mpt2sas driver version to 18.100.00.00.
