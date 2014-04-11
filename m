Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaDKGRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:17:09 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:51828
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753013AbaDKGRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:17:07 -0400
From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        DL-MegaRAID Linux <megaraidlinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
Thread-Topic: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
Thread-Index: AQHPR6Ddo9KjKvtTcUiWLOWhf54Ce5sMB5ag
Date: Fri, 11 Apr 2014 06:02:39 +0000
Message-ID: <1323d0a306474383a4d3f50db610a8ce@DM2PR07MB400.namprd07.prod.outlook.com>
References: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.19.224.250]
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(189002)(199002)(377454003)(13464003)(92566001)(74316001)(85852003)(20776003)(66066001)(99286001)(19580405001)(83322001)(19580395003)(76176999)(54356999)(50986999)(79102001)(80976001)(86362001)(4396001)(80022001)(2656002)(77982001)(33646001)(81342001)(76576001)(87936001)(74502001)(46102001)(74662001)(81542001)(76482001)(99396002)(31966008)(83072002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB398;H:DM2PR07MB400.namprd07.prod.outlook.com;FPR:78627C5C.3E17A222.40C72B21.C7A959CA.201C3;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
>Sent: Tuesday, March 25, 2014 2:07 AM
>To: Jiri Kosina
>Cc: linux-kernel@vger.kernel.org; Geert Uytterhoeven; DL-MegaRAID Linux;
>linux-scsi@vger.kernel.org
>Subject: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
>
>From: Geert Uytterhoeven <geert+renesas@glider.be>
>
>Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
>Cc: linux-scsi@vger.kernel.org
>---
> drivers/scsi/megaraid/megaraid_sas_base.c   |    2 +-
> drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3b7ad10497fe..10082678077c 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -3865,7 +3865,7 @@ fail_ready_state:
>
> /**
>  * megasas_release_mfi -	Reverses the FW initialization
>- * @intance:			Adapter soft state
>+ * @instance:			Adapter soft state
>  */
> static void megasas_release_mfi(struct megasas_instance *instance)  { diff --
>git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index f6555921fd7a..f7d68f65f974 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -2164,7 +2164,7 @@ megasas_issue_dcmd_fusion(struct
>megasas_instance *instance,
>
> /**
>  * megasas_release_fusion -	Reverses the FW initialization
>- * @intance:			Adapter soft state
>+ * @instance:			Adapter soft state
>  */
> void
> megasas_release_fusion(struct megasas_instance *instance)

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>

-Sumit
>--
>1.7.9.5
>

