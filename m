Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaIEKUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:20:41 -0400
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:38336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756010AbaIEKUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:20:40 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 06:20:40 EDT
From: "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Rajeev Kumar <rajeev_kumar@mentor.com>
CC: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        Martin Walch <walch.martin@web.de>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2] ARM: spear: Remove references to PLAT_SPEAR_SINGLE
Thread-Topic: [PATCH v2] ARM: spear: Remove references to PLAT_SPEAR_SINGLE
Thread-Index: AQHPyOwnqWsIEwndxEKf7wfIEMzP+ZvySJgAgAABzBA=
Date: Fri, 5 Sep 2014 09:46:46 +0000
Message-ID: <67e78606ffe94782aa09439f42fef837@BN1PR03MB220.namprd03.prod.outlook.com>
References: <1392153676.14317.8.camel@x220> <1397550407.1985.12.camel@x220>
 <534CFB45.9070704@st.com> <1402919387.30599.4.camel@x220>
 <1409909229.5546.146.camel@x220> <1409909940.5546.154.camel@x220>
In-Reply-To: <1409909940.5546.154.camel@x220>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019016)(6009001)(41574002)(377454003)(189002)(199003)(377424004)(24454002)(51704005)(13464003)(66066001)(77096002)(80022001)(81342001)(33646002)(15202345003)(108616004)(64706001)(20776003)(15975445006)(76482001)(79102001)(77982001)(2656002)(83072002)(46102001)(74316001)(85852003)(99396002)(86362001)(90102001)(19580405001)(19580395003)(83322001)(92566001)(31966008)(81542001)(105586002)(106356001)(85306004)(21056001)(95666004)(106116001)(76576001)(93886004)(107046002)(74502001)(87936001)(74662001)(4396001)(54356999)(101416001)(76176999)(50986999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB220;H:BN1PR03MB220.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-
> bounces@lists.infradead.org] On Behalf Of Paul Bolle
> Sent: Friday, September 05, 2014 3:09 PM
> To: Viresh Kumar; Shiraz Hashim
> Cc: Russell King; Richard Weinberger; Martin Walch; spear-
> devel@list.st.com; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2] ARM: spear: Remove references to
> PLAT_SPEAR_SINGLE
> 
> On Fri, 2014-09-05 at 11:27 +0200, Paul Bolle wrote:
> > On Mon, 2014-06-16 at 13:49 +0200, Paul Bolle wrote:
> > > On Tue, 2014-04-15 at 14:56 +0530, Rajeev kumar wrote:
> > > > Reviewed-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> > >
> > > Thanks!
> > >
> > > This can still be seen in v3.16-rc1 and in today's linux-next (ie,
> > > next-20140616). Is this trivial patch queued somewhere?
> >
> > Ditto for v3.17-rc3 and next-20140904. Could someone please pix this
> up?
> 
> And now Rajeev's address bounces. Has Rajeev left ST?
> 
> 

Copying Rajeev' new id.


Regards,
Bhupesh

> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
