Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBGTNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:13:13 -0500
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:43008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387AbaBGTNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:13:12 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: Drivers/hv
Thread-Topic: Drivers/hv
Thread-Index: AQHPHQPV07dRQOxvPUWFtrQXaUUm5ZqcNHQAgA4ABrCAAAKNgP///9NQ
Date: Fri, 7 Feb 2014 19:12:56 +0000
Message-ID: <4ae52a702f95411394db921d3b86456b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1391011049-10795-1-git-send-email-kys@microsoft.com>
 <20140129211532.GA9095@kroah.com>
 <dcabbfad2fe24769a3d2ade8315fa016@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140207191223.GA8580@kroah.com>
In-Reply-To: <20140207191223.GA8580@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.206]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(13464003)(51704005)(199002)(189002)(377454003)(95416001)(86612001)(81342001)(81542001)(76576001)(93136001)(81816001)(69226001)(90146001)(77982001)(80976001)(74316001)(56816005)(74876001)(74706001)(86362001)(93516002)(59766001)(76796001)(76786001)(94946001)(63696002)(74366001)(79102001)(83072002)(85852003)(47976001)(50986001)(94316002)(80022001)(47736001)(49866001)(66066001)(65816001)(4396001)(53806001)(87936001)(87266001)(92566001)(2656002)(33646001)(85306002)(81686001)(46102001)(83322001)(51856001)(54356001)(76482001)(31966008)(56776001)(19580395003)(54316002)(19580405001)(47446002)(74502001)(74662001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.206;FPR:EECFC152.AE23D72A.51F19BB8.C4E149F8.20251;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, February 07, 2014 11:12 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: Drivers/hv
> 
> On Fri, Feb 07, 2014 at 07:06:00PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Wednesday, January 29, 2014 1:16 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > apw@canonical.com; jasowang@redhat.com
> > > Subject: Re: Drivers/hv
> > >
> > > On Wed, Jan 29, 2014 at 07:57:29AM -0800, K. Y. Srinivasan wrote:
> > > >
> > > > Greg,
> > > >
> > > > Some time back I had sent a buch of patches for
> > > > Hyper-V drivers. Are they still in the queue or should I resend
> > > > them.
> > >
> > > Which specific patches are you referring to?  I can't take anything
> > > until after 3.14-rc1 is out, and I do see a few from you in my queue, so
> > > if you want to resend, please do, but note I will not get to them until
> > > sometime late next week at the earliest.
> >
> > I saw that you committed two (hv) patches earlier today. There are still a few
> more
> > patches that are not committed yet; should I resend those?
> 
> No, I am slowly going through my backlog (over 800 patches).  I applied
> the ones that are needed for 3.14 at the moment, will catch with the
> rest later, please give me a chance...

Thanks Greg.

K. Y
