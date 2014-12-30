Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaL3QWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:22:38 -0500
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:35008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbaL3QWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:22:36 -0500
From: KY Srinivasan <kys@microsoft.com>
To: "hch@infradead.org" <hch@infradead.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
Thread-Topic: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
Thread-Index: AQHQJBN+lPQyrE7lhUyCaOO6HaXi1JyoUSdQ
Date: Tue, 30 Dec 2014 16:22:34 +0000
Message-ID: <BY2PR0301MB07113BE58A3A3BD1960DA5A3A05E0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <BY2PR0301MB0711853294B88172F1AAF24FA0510@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20141230093210.GA6294@infradead.org>
In-Reply-To: <20141230093210.GA6294@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:fd:a46f:2754:b165:9d2c]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(377454003)(199003)(13464003)(189002)(54606007)(2351001)(21056001)(110136001)(76176999)(107046002)(77156002)(102836002)(87936001)(86612001)(2656002)(20776003)(4396001)(54356999)(62966003)(74316001)(54206007)(64706001)(105586002)(19580395003)(101416001)(106356001)(106116001)(46102003)(97736003)(50986999)(2900100001)(2501002)(76576001)(19580405001)(68736005)(86362001)(33656002)(40100003)(2950100001)(99396003)(99286002)(122556002)(120916001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 16:22:34.3392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: hch@infradead.org [mailto:hch@infradead.org]
> Sent: Tuesday, December 30, 2014 1:32 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
> 
> On Mon, Dec 29, 2014 at 09:07:59PM +0000, KY Srinivasan wrote:
> > Should I be resending these patches.
> 
> I don't need a resend, I need a review for the patches.  Note that for driver
> patches I'm also fine with a review from a co worker, as long as it's a real
> review not just a rubber stamp.

Thanks; will do.
> 
> Talking about process:  for the next submission please only use
> "storvsc:  " as the subject prefix, I had to remove "Drivers: scsi: "
> which doesn'd add useful information every time so far.
Ok.

Regards,

K. Y
