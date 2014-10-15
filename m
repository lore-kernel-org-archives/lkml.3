Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaJOCH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:07:26 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:45184
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755536AbaJOCHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:07:24 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: RE: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Thread-Topic: [PATCH 2/3] scsi: add try_rc16 blacklist flag
Thread-Index: AQHP6BSOOGODzdDZ00mLXdufbKbAJ5wwaSZA
Date: Wed, 15 Oct 2014 02:07:21 +0000
Message-ID: <30375c9b3e144580b4b98cf71f64e5b0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20141010074901.GA32028@sucs.org>
	<20141010075251.GC32028@sucs.org> <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(51704005)(377454003)(189002)(46102003)(80022003)(74316001)(64706001)(19580405001)(19580395003)(86362001)(92566001)(21056001)(66066001)(31966008)(101416001)(4396001)(2656002)(122556002)(87936001)(85852003)(108616004)(85306004)(33646002)(97736003)(50986999)(77096002)(54356999)(76482002)(20776003)(120916001)(76176999)(99396003)(95666004)(76576001)(99286002)(106116001)(106356001)(105586002)(40100003)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, October 14, 2014 6:08 PM
> To: Sitsofe Wheeler
> Cc: KY Srinivasan; Haiyang Zhang; Christoph Hellwig; Hannes Reinecke; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; James E.J. Bottomley
> Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
> 
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> Microsoft Hyper-V virtual disks currently only claim SPC-2
> Sitsofe> compliance causing the kernel skip checks for features such as
> Sitsofe> thin provisioning even though the virtual disk advertises them.
> 
> Last time around we identified this as a problem with Microsoft's
> interpretation of the T10 SBC spec. And they promised that they are going to
> fix that.

It has been fixed in windows 10 and a bug has been opened for earlier hosts.

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
