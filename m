Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937072Ab3DJRmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:42:12 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:36411
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763029Ab3DJRmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:42:10 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
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
Thread-Index: AQHONgFIqa2eusdO/ECLJzZ4butuKpjPmheAgAADVpCAAAjhAIAACDyA
Date: Wed, 10 Apr 2013 17:37:41 +0000
Message-ID: <a6d2f8d7a9bf48cda759bf7029192c4d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1365610097-10955-1-git-send-email-kys@microsoft.com>
 <20130410154957.GA13849@kroah.com>
 <a3b67bf6e11c462d826c1fc4957c3da9@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130410163340.GA21840@kroah.com>
In-Reply-To: <20130410163340.GA21840@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.124.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(24454001)(377454001)(13464002)(51704002)(189002)(199002)(54316002)(5343635001)(6806001)(79102001)(49866001)(5343655001)(63696002)(80022001)(56816002)(76482001)(65816001)(56776001)(4396001)(77982001)(31966008)(74502001)(46102001)(59766001)(81542001)(20776003)(50466001)(69226001)(47776003)(50986001)(23726001)(33646001)(46406002)(54356001)(16676001)(53806001)(47446002)(47736001)(74662001)(81342001)(51856001)(47976001)(24736002)(550254004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB013;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0812095267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, April 10, 2013 12:34 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific Kconfig
> options
> 
> On Wed, Apr 10, 2013 at 04:12:24PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Wednesday, April 10, 2013 11:50 AM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > apw@canonical.com; jasowang@redhat.com
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
> Kconfig
> > > options
> > >
> > > On Wed, Apr 10, 2013 at 09:08:17AM -0700, K. Y. Srinivasan wrote:
> > > > The guest ID captures information about the guest and has room for
> > > > distributions to add distro specific information. Add Kconfig options
> > > > to support distro specific information to be managed easily.
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > ---
> > > >  drivers/hv/Kconfig        |   14 ++++++++++++++
> > > >  drivers/hv/hv.c           |    4 +++-
> > > >  drivers/hv/hyperv_vmbus.h |    2 +-
> > > >  3 files changed, 18 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> > > > index 0403b51..d2ca9c7 100644
> > > > --- a/drivers/hv/Kconfig
> > > > +++ b/drivers/hv/Kconfig
> > > > @@ -19,4 +19,18 @@ config HYPERV_BALLOON
> > > >  	help
> > > >  	  Select this option to enable Hyper-V Balloon driver.
> > > >
> > > > +config HYPERV_GUEST_D1
> > > > +	hex "Distro specific information"
> > > > +	range 0x00 0xff
> > > > +	default 0
> > > > +	help
> > > > +	  This specifies the Distro vendor
> > >
> > > And just what is a distro supposed to set the value here to?  For
> > > example, what would Arch Linux pick?  Fedora?  RHEL?  SLES?  openSUSE?
> > > You do know that there are more than 0xff different Linux distro
> > > "vendors"?  Do they all just get to pick a number that they like?
> >
> > MSFT is planning to manage this space; we will assign distributions
> > unique numbers that they can use here.
> 
> And how will that happen?  A single line in a Kconfig file doesn't cut
> it, sorry.
> 
> What's wrong with lanana.org managing it instead?  That's who manages
> all of the rest of the kernel-limited resources.
> 
> And what happens when you have more than 256?  We already know that's
> not going to be enough numbers, why start out already with an obsolete
> range?

Greg,
You are reading more into this than there is. As it stands now (without this patch), the code
that constructs the guest OS ID has place holders for adding in some distro specific tags into
this ID. Look at the function generate_guest_id() in  hyperv_vmbus.h. Currently these values are
hard-coded to 0. All I am doing here is to present a more maintainable way of customizing these.
The default values for these are currently 0 and even with this patch, the default values will continue
to be 0. However, if a distro chooses to modify these defaults, with this patch they can do so in a more
maintainable way - they could set this config parameter on a per-tree basis.

This information will potentially be used to automate the support infrastructure. We feel that with 24 bits
between the two distro specific tags, we have enough bits to differentiate the distros that may run on 
our platform.
 
> 
> > > > +config HYPERV_GUEST_D2
> > > > +	hex "Additional Distro specific information"
> > > > +	range 0x0000 0xffff
> > > > +	default 0
> > > > +	help
> > > > +	  Additional Distro specific kernel version information
> > >
> > > Again, what is a distro supposed to do here?  What's wrong with the
> > > kernel version information that the kernel already has?  Can't you just
> > > use that string?
> >
> > We already have the kernel version information. Distros can choose to
> > use this as they please. We are recommending that they use this field
> > to track some distro specific build number.
> 
> That's in the kernel version already, why put it here again?
> 
> Again, you need _way_ more than just a single Kconfig line for new
> configuration options where you expect distros to set a value to a
> unique thing,
> 
> And lastly, you do know about /etc/os-release, the cross-distro,
> standardized way to specify distro version and build information,
> right?  Why aren't you just using that instead of creating your own
> "unique" way of defining the exact same thing?
> 
> Don't create a new standard just when we all finally picked one to
> follow, it makes it look like you don't think what the community decided
> on is valid, which isn't a wise decision.

As I said, we are not proposing any new standard here. KVP currently retrieves info
from /etc/os-release. The tooling on the Windows host uses the guest OS ID MSR to identify guest
operating systems running on the host . With what we currently have, we can detect that it is Linux based
on the information we use to construct the OS ID. This information also includes the kernel version number
as well. This patch merely makes it easy to add distro specific tags. It is entirely up to distros to decide if they want to
add these tags. The default values are 0 for both these fields and they continue to be 0.

Regards,

K. Y


