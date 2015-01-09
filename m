Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbbAIVIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:08:15 -0500
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:11665
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751695AbbAIVIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:08:14 -0500
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
Thread-Topic: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
 cleanup
Thread-Index: AQHQK1x/tCd9OkBR1UOzHdq/Kg2aapy2cxPwgAHRMoCAAAKyEIAAAXEAgAABkQA=
Date: Fri, 9 Jan 2015 21:08:11 +0000
Message-ID: <BY2PR0301MB071128E723D649A9BD79C645A0440@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E9B62F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87lhmfhna7.fsf@vitty.brq.redhat.com> <20141210144829.GB17184@kroah.com>
 <BY2PR0301MB071102AF97B27F11EF91F89CA0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <877fwxqn08.fsf@vitty.brq.redhat.com>
 <BN1PR0301MB0707072CBA0483E06C6FE6E1A0470@BN1PR0301MB0707.namprd03.prod.outlook.com>
 <20150109204735.GA1194@kroah.com>
 <BY2PR0301MB0711EFA0AF6FACCB46341AB8A0440@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20150109210224.GA6483@kroah.com>
In-Reply-To: <20150109210224.GA6483@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::4]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0774;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0774;
x-forefront-prvs: 04519BA941
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377454003)(51704005)(199003)(24454002)(13464003)(40100003)(105586002)(2950100001)(122556002)(19580395003)(99286002)(19580405001)(93886004)(106356001)(77156002)(62966003)(54356999)(101416001)(110136001)(50986999)(2351001)(76176999)(54606007)(33656002)(54206007)(2656002)(102836002)(2900100001)(74316001)(46102003)(106116001)(64706001)(97736003)(76576001)(87936001)(68736005)(2501002)(86362001)(86612001)(92566002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0774;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2015 21:08:11.4685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, January 9, 2015 1:02 PM
> To: KY Srinivasan
> Cc: devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
> cleanup
> 
> On Fri, Jan 09, 2015 at 08:58:08PM +0000, KY Srinivasan wrote:
> > > Please resend everything, there has been a mess of different patches
> > > and discussions and I can't figure out what should be applied and
> > > what should not.  I'll guess at a few easy ones, but getting the "correct"
> > > ones from you is the best thing.
> > Will do. Vitaly, could you please resend the patches.
> 
> You are the subsystem maintainer, right?  It's your job to bundle them up
> and resend if needed.

Will do.

K. Y
> 
> thanks,
> 
> greg k-h
