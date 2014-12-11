Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaLKTFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:05:51 -0500
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:39181
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757052AbaLKTFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:05:49 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: Long Li <longli@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Topic: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Index: AQHQFEr2lRl5lG262U+8PhB4FFpJLJyJU4TcgAAVCoCAABEBoIAAv1OAgACEvWA=
Date: Thu, 11 Dec 2014 18:49:58 +0000
Message-ID: <BY2PR0301MB0711C426CD05C614C655F3A2A0630@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 <BY2PR0301MB0711CF1C9FBD8EFED89B3911A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141211101945.GA25624@sucs.org>
In-Reply-To: <20141211101945.GA25624@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-forefront-prvs: 0422860ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(13464003)(24454002)(189002)(377454003)(20776003)(64706001)(92566001)(21056001)(50986999)(86362001)(54206007)(74316001)(2656002)(86612001)(15395725005)(54356999)(54606007)(68736005)(76176999)(102836002)(15975445007)(46102003)(106356001)(62966003)(105586002)(107046002)(110136001)(99396003)(122556002)(76576001)(87936001)(1411001)(31966008)(19580405001)(77156002)(99286002)(106116001)(4396001)(101416001)(40100003)(120916001)(93886004)(19580395003)(33656002)(97736003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0774;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Thursday, December 11, 2014 2:54 AM
> To: KY Srinivasan
> Cc: Long Li; Martin K. Petersen; Haiyang Zhang; JBottomley@parallels.com;
> linux-scsi@vger.kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> On Wed, Dec 10, 2014 at 11:30:30PM +0000, KY Srinivasan wrote:
> >
> > > >
> > > > +	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
> > > >
> > > > Is that version field meaningful or is it safe for us to inquire
> > > > about VPD pages without problems on older versions?
> > >
> > > This version is used in all current Hyper-V hosts: Windows 2008 R2,
> > > 2012 and
> > > 2012 R2. However it may change in future Windows releases.
> >
> > The next version of the host will be claiming conformance to SPC-3
> 
> Will the version number ("1.0") of Virtual Disks also be changed? Part of me
> hopes it will as it will mean certain quirks for virtual disks will be easier to
> apply and won't need host version (are you 2008, 2012,
> 2016) version logic...

Spoke to the folks on Windows side of the house. They currently don't have plans to
Change the version number ("1.0").

K. Y
> 
> --
> Sitsofe | http://sucs.org/~sits/
