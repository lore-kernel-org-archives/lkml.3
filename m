Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab3DJQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:14:48 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:35634
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933445Ab3DJQOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:14:47 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
 Kconfig options
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
 Kconfig options
Thread-Index: AQHONgFIqa2eusdO/ECLJzZ4butuKpjPmheAgAADVpA=
Date: Wed, 10 Apr 2013 16:12:24 +0000
Message-ID: <a3b67bf6e11c462d826c1fc4957c3da9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1365610097-10955-1-git-send-email-kys@microsoft.com>
 <20130410154957.GA13849@kroah.com>
In-Reply-To: <20130410154957.GA13849@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704002)(189002)(377454001)(13464002)(24454001)(5343635001)(20776003)(46102001)(81342001)(44976002)(16676001)(74662001)(49866001)(54316002)(77982001)(56776001)(47776003)(69226001)(6806001)(53806001)(76482001)(65816001)(46406002)(59766001)(47736001)(63696002)(31966008)(47976001)(50986001)(33646001)(74502001)(66066001)(81542001)(23726001)(56816002)(79102001)(51856001)(50466001)(54356001)(47446002)(80022001)(4396001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB012;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0812095267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, April 10, 2013 11:50 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific Kconfig
> options
> 
> On Wed, Apr 10, 2013 at 09:08:17AM -0700, K. Y. Srinivasan wrote:
> > The guest ID captures information about the guest and has room for
> > distributions to add distro specific information. Add Kconfig options
> > to support distro specific information to be managed easily.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/Kconfig        |   14 ++++++++++++++
> >  drivers/hv/hv.c           |    4 +++-
> >  drivers/hv/hyperv_vmbus.h |    2 +-
> >  3 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> > index 0403b51..d2ca9c7 100644
> > --- a/drivers/hv/Kconfig
> > +++ b/drivers/hv/Kconfig
> > @@ -19,4 +19,18 @@ config HYPERV_BALLOON
> >  	help
> >  	  Select this option to enable Hyper-V Balloon driver.
> >
> > +config HYPERV_GUEST_D1
> > +	hex "Distro specific information"
> > +	range 0x00 0xff
> > +	default 0
> > +	help
> > +	  This specifies the Distro vendor
> 
> And just what is a distro supposed to set the value here to?  For
> example, what would Arch Linux pick?  Fedora?  RHEL?  SLES?  openSUSE?
> You do know that there are more than 0xff different Linux distro
> "vendors"?  Do they all just get to pick a number that they like?

MSFT is planning to manage this space; we will assign distributions unique numbers
that they can use here.

> 
> > +config HYPERV_GUEST_D2
> > +	hex "Additional Distro specific information"
> > +	range 0x0000 0xffff
> > +	default 0
> > +	help
> > +	  Additional Distro specific kernel version information
> 
> Again, what is a distro supposed to do here?  What's wrong with the
> kernel version information that the kernel already has?  Can't you just
> use that string?


We already have the kernel version information. Distros can choose to use this
as they please. We are recommending that they use this field to track some distro specific
build number.

Regards,

K. Y


