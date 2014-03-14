Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaCNPiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:38:02 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:49186
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755906AbaCNPh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:37:57 -0400
Date: Fri, 14 Mar 2014 21:03:12 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH][SCSI]mpt2sas: Description Patch
Message-ID: <20140314153312.GA7904@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(4396001)(53806001)(51856001)(36756003)(57986002)(76786001)(49866001)(47736001)(46102001)(50986001)(47976001)(76176001)(77096001)(76796001)(83506001)(81686001)(81816001)(86362001)(33656001)(94316002)(93136001)(93516002)(74876001)(19580395003)(83322001)(19580405001)(44976005)(6806004)(74366001)(74706001)(50466002)(80976001)(92566001)(92726001)(87266001)(87936001)(85306002)(95416001)(94946001)(90146001)(56816005)(85852003)(83072002)(95666003)(46406003)(65816001)(56776001)(54316002)(69226001)(76482001)(54356001)(81342001)(81542001)(80022001)(16796002)(74502001)(47446002)(31966008)(97186001)(97336001)(97756001)(77982001)(20776003)(47776003)(23726002)(63696002)(59766001)(79102001)(74662001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR07MB073;H:COSEXCH10.lsi.com;FPR:ACDCCC57.A3C21CFF.6DD39157.10FAA541.201F2;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 01/11][SCSI]mpt2sas: Added driver module parameter max_msix_vectors.
[PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.
[PATCH 03/11][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications.
[PATCH 04/11][SCSI]mpt2sas: Copyright in driver sources is updated for year the 2014.
[PATCH 05/11][SCSI]mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[PATCH 06/11][SCSI]mpt2sas: Bump mpt2sas driver version to 17.100.00.00.
[PATCH 07/11][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive.
[PATCH 08/11][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[PATCH 09/11][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
[PATCH 10/11][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition.
[PATCH 11/11][SCSI]mpt2sas: Bump mpt2sas driver version to 18.100.00.00.

