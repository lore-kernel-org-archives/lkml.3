Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaCNQMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:12:30 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:9700
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbaCNQMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:12:22 -0400
Date: Fri, 14 Mar 2014 21:38:00 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH][SCSI]mpt3sas: Description Patch
Message-ID: <20140314160800.GA8328@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(46406003)(4396001)(95416001)(77982001)(93516002)(50986001)(90146001)(76786001)(76176001)(56816005)(47736001)(77096001)(83072002)(85852003)(76796001)(94316002)(59766001)(23726002)(47776003)(74706001)(63696002)(92726001)(87936001)(92566001)(47976001)(20776003)(79102001)(81816001)(94946001)(50466002)(74876001)(49866001)(87266001)(93136001)(57986002)(80022001)(19580405001)(46102001)(56776001)(19580395003)(54316002)(76482001)(69226001)(83322001)(85306002)(80976001)(74502001)(54356001)(81342001)(6806004)(97186001)(97336001)(74662001)(16796002)(31966008)(33656001)(44976005)(53806001)(47446002)(86362001)(65816001)(97756001)(81686001)(51856001)(83506001)(74366001)(95666003)(36756003)(81542001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB067;H:COSEXCH10.lsi.com;FPR:AC3E4405.A3D254CC.89D3514B.10FA2AD1.20155;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 1/9][SCSI]mpt3sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.
[PATCH 2/9][SCSI]mpt3sas: MPI2.5 Rev G (2.5.2) specifications.
[PATCH 3/9][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[PATCH 4/9][SCSI]mpt3sas: Bump mpt3sas driver version to 03.100.00.00.
[PATCH 5/9][SCSI]mpt3sas: MPI2.5 Rev H (2.5.3) specifications.
[PATCH 6/9][SCSI]mpt3sas: Copyright in driver sources is updated for year the 2014.
[PATCH 7/9][SCSI]mpt3sas: Added OEM branding Strings.
[PATCH 8/9][SCSI]mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[PATCH 9/9][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00.
