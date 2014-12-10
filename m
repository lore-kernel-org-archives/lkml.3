Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaLJWsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:48:25 -0500
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:2476
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933041AbaLJWsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:48:24 -0500
From: Long Li <longli@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Topic: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Thread-Index: AQHQFEr1l6JEzjzL40qd8o/Vn6giApyJT08AgAAZ6lA=
Date: Wed, 10 Dec 2014 22:33:26 +0000
Message-ID: <BL2PR03MB132331596398113A8F15B45CE620@BL2PR03MB132.namprd03.prod.outlook.com>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <20141210205746.GB1209@sucs.org>
In-Reply-To: <20141210205746.GB1209@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0720;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0720;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(13464003)(377454003)(199003)(51704005)(92566001)(76576001)(62966003)(77156002)(86362001)(120916001)(31966008)(86612001)(99396003)(122556002)(101416001)(40100003)(4396001)(68736005)(97736003)(15975445007)(102836002)(99286002)(87936001)(105586002)(64706001)(19580405001)(50986999)(21056001)(54206007)(54606007)(15395725005)(1411001)(107046002)(76176999)(46102003)(33656002)(110136001)(106116001)(20776003)(2656002)(106356001)(54356999)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0720;H:BL2PR03MB132.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, December 10, 2014 12:58 PM
> To: Long Li
> Cc: KY Srinivasan; Haiyang Zhang; JBottomley@parallels.com; linux-
> scsi@vger.kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
> 
> On Wed, Dec 10, 2014 at 12:38:25AM -0800, Long Li wrote:
> > MSFT targets currently claim SPC-2 compliance while they implement
> > post SPC-2 features. With this patch we can correctly handle
> > WRITE_SAME_16 issues.
> >
> > This patch fixes an issue where the flag is setup too late in drive
> > initialization process.
> 
> Li, is this a fix for the issue I keep whinging about over in
> https://lkml.org/lkml/2014/10/21/23 ?
> 
> If is the same issue you may want to CC Martin on this...

This is only for fixing WRITE_SAME_16. The rest of the thin provisioning (e.g. UNMAP) is still broken on SPC-2.

> 
> --
> Sitsofe | http://sucs.org/~sits/
