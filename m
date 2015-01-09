Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbbAIU6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:58:13 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:56192
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969AbbAIU6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:58:10 -0500
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
Thread-Topic: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
 cleanup
Thread-Index: AQHQK1x/tCd9OkBR1UOzHdq/Kg2aapy2cxPwgAHRMoCAAAKyEA==
Date: Fri, 9 Jan 2015 20:58:08 +0000
Message-ID: <BY2PR0301MB0711EFA0AF6FACCB46341AB8A0440@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E9B62F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87lhmfhna7.fsf@vitty.brq.redhat.com> <20141210144829.GB17184@kroah.com>
 <BY2PR0301MB071102AF97B27F11EF91F89CA0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <877fwxqn08.fsf@vitty.brq.redhat.com>
 <BN1PR0301MB0707072CBA0483E06C6FE6E1A0470@BN1PR0301MB0707.namprd03.prod.outlook.com>
 <20150109204735.GA1194@kroah.com>
In-Reply-To: <20150109204735.GA1194@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::4]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 04519BA941
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(24454002)(43544003)(51914003)(57704003)(189002)(377454003)(51704005)(199003)(106356001)(106116001)(105586002)(110136001)(2501002)(97736003)(2351001)(99286002)(93886004)(92566002)(102836002)(2900100001)(122556002)(68736005)(2950100001)(76576001)(40100003)(19580405001)(46102003)(19580395003)(87936001)(2656002)(86612001)(62966003)(74316001)(77156002)(54206007)(64706001)(54606007)(101416001)(50986999)(33656002)(86362001)(54356999)(76176999)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2015 20:58:08.2857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, January 9, 2015 12:48 PM
> To: KY Srinivasan
> Cc: Vitaly Kuznetsov; devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
> cleanup
> 
> On Thu, Jan 08, 2015 at 05:04:20PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> > > Sent: Thursday, January 8, 2015 8:02 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; devel@linuxdriverproject.org;
> > > Haiyang Zhang; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do
> > > minor cleanup
> > >
> > > KY Srinivasan <kys@microsoft.com> writes:
> > >
> > > >> -----Original Message-----
> > > >> From: devel
> > > >> [mailto:driverdev-devel-bounces@linuxdriverproject.org]
> > > >> On Behalf Of gregkh@linuxfoundation.org
> > > >> Sent: Wednesday, December 10, 2014 6:48 AM
> > > >> To: Vitaly Kuznetsov
> > > >> Cc: devel@linuxdriverproject.org; Haiyang Zhang; linux-
> > > >> kernel@vger.kernel.org
> > > >> Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do
> > > >> minor cleanup
> > > >>
> > > >> On Wed, Dec 10, 2014 at 10:22:40AM +0100, Vitaly Kuznetsov wrote:
> > > >> > Dexuan Cui <decui@microsoft.com> writes:
> > > >> >
> > > >> > >> -----Original Message-----
> > > >> > >> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> > > >> > >> Sent: Tuesday, December 9, 2014 23:48 PM
> > > >> > >> To: KY Srinivasan
> > > >> > >> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> > > >> > >> kernel@vger.kernel.org; Dexuan Cui
> > > >> > >> Subject: [PATCH 0/5] Tools: hv: fix compiler warnings and do
> > > >> > >> minor cleanup
> > > >> > >>
> > > >> > >> When someone does 'make' in tools/hv/ issues appear:
> > > >> > >> - hv_fcopy_daemon is not being built;
> > > >> > >> - lots of compiler warnings.
> > > >> > >>
> > > >> > >> This is just a cleanup. Compile-tested by myself on top of
> > > >> > >> linux-
> > > >> next/master.
> > > >> > >>
> > > >> > >> Piggyback this series and send "[PATCH 5/5] Tools: hv: do
> > > >> > >> not add redundant '/'
> > > >> > >>  in hv_start_fcopy()"
> > > >> > >>
> > > >> > >> Vitaly Kuznetsov (5):
> > > >> > >>   Tools: hv: add mising fcopyd to the Makefile
> > > >> > >>   Tools: hv: remove unused bytes_written from
> kvp_update_file()
> > > >> > >>   Tools: hv: address compiler warnings for hv_kvp_daemon.c
> > > >> > >>   Tools: hv: address compiler warnings for hv_fcopy_daemon.c
> > > >> > >>   Tools: hv: do not add redundant '/' in hv_start_fcopy()
> > > >> > >>
> > > >> > >>  tools/hv/Makefile          |  4 ++--
> > > >> > >>  tools/hv/hv_fcopy_daemon.c | 10 ++--------
> > > >> > >>  tools/hv/hv_kvp_daemon.c   | 29 +++++++++++++----------------
> > > >> > >>  3 files changed, 17 insertions(+), 26 deletions(-)
> > > >> > >>
> > > >> > >> --
> > > >> > >> 1.9.3
> > > >> > >
> > > >> > > Hi Vitaly,
> > > >> > > Thanks for the patchset!
> > > >> > >
> > > >> > > Acked-by: Dexuan Cui <decui@microsoft.com>
> > > >> > >
> > > >> > > PS, I added Greg into the TO list.
> > > >> > > The hv code in drivers/hv/ and tools/hv/ usually has to go
> > > >> > > into Greg's tree first.
> > > >> >
> > > >> > Well, I don't mind spamming Greg but he's not on the
> > > >> > scripts/get_maintainer.pl output. In case he's not monitoring
> > > >> > the list for patches by some other tool (patchwork?) a patch
> > > >> > adding him to MAINTAINERS would do the job.
> > > >> >
> > > >> > Greg, do you want to become an official Hyper-V maintainer in
> > > >> > MAINTAINERS? I can send a patch then :-)
> > > >>
> > > >> No.  It's up to the "real" maintainers to take the patches and
> > > >> then forward them on to me for inclusion in the kernel tree.  KY knows
> this...
> > > >
> > > > I will take care of this.
> > > >
> > >
> > > Hi KY,
> > >
> > > I just found out these patches never made it to any repo, at least I
> > > can't see them in char-misc-next. Do I need to resend?
> >
> > Greg,
> >
> > I have signed off on these patches. Do you want us to resend them. On
> > a different note, I too have a Few patches that I sent some weeks ago.
> Should I be resending them as well.
> 
> Please resend everything, there has been a mess of different patches and
> discussions and I can't figure out what should be applied and what should
> not.  I'll guess at a few easy ones, but getting the "correct"
> ones from you is the best thing.
Will do. Vitaly, could you please resend the patches. 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
