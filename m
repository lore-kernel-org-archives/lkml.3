Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaL2VIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:08:05 -0500
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:26016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752413AbaL2VID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:08:03 -0500
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues  
Thread-Topic: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues  
Thread-Index: AQHQGWxr8Go24cf6dEC+njzk0uRCrJynI8Yg
Date: Mon, 29 Dec 2014 21:07:59 +0000
Message-ID: <BY2PR0301MB0711853294B88172F1AAF24FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1418764880-11183-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 0440AC9990
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(377454003)(51704005)(13464003)(33656002)(2501002)(106116001)(77156002)(62966003)(101416001)(97736003)(54606007)(106356001)(54206007)(86362001)(2900100001)(2950100001)(2201001)(105586002)(122556002)(99396003)(102836002)(20776003)(2421001)(107046002)(4396001)(50986999)(74316001)(86612001)(31966008)(87936001)(46102003)(68736005)(66066001)(99286002)(92566001)(40100003)(76176999)(120916001)(64706001)(2561002)(19580405001)(107886001)(1511001)(2656002)(54356999)(19580395003)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2014 21:07:59.2137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, December 16, 2014 1:21 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan
> Subject: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
> 
> The first two patches in this series are a resend; these were submitted some
> months ago and as far as I know, there were no outstanding issues.
> 
> Win8 and win8 r2 hosts do support SPC-3 features but claim SPC-2
> compliance.
> This issue is fixed here as well.
> 
> K. Y. Srinivasan (4):
>   Drivers: scsi: storvsc: In responce to a scan event, scan the host
>   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
>     removed.
>   Drivers: scsi: storvsc: Fix a bug in storvsc limits
>   Drivers: scsi: storvsc: Force SPC-3 compliance on win8 and win8 r2
>     hosts

Christoph,

Should I be resending these patches.

Regards,

K. Y
> 
>  drivers/scsi/storvsc_drv.c |   71
> +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 57 insertions(+), 14 deletions(-)
> 
> --
> 1.7.4.1

