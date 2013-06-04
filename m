Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3FDXhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:37:01 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:43674
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883Ab3FDXg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:36:59 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>, Fengguang Wu <fengguang.wu@intel.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0 bytes,
 default 64
Thread-Topic: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0
 bytes, default 64
Thread-Index: AQHOYS5/WRdBXqmqq0S3b2N5KDpZCZkmJ8IAgAAHKZA=
Date: Tue, 4 Jun 2013 23:36:23 +0000
Message-ID: <e4b859d1ac994528ab04e1f5d6a335ae@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130604141536.GA13324@localhost>
 <20130604224424.GB533@kroah.com>
In-Reply-To: <20130604224424.GB533@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:0:fff:0:5efe:10.83.117.54]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KROAH.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454002)(24454002)(13464003)(199002)(189002)(51704005)(47446002)(63696002)(47776003)(59766001)(56776001)(53806001)(33646001)(51856001)(46102001)(50986001)(23726002)(76482001)(74502001)(76786001)(47736001)(54316002)(69226001)(79102001)(65816001)(20776003)(74366001)(80022001)(74706001)(81542001)(47976001)(6806003)(50466002)(4396001)(77982001)(81342001)(54356001)(74316001)(49866001)(74876001)(16676001)(74662001)(31966008)(46406003)(56816003)(76796001)(44976003)(76576001)(77096001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB021;H:TK5EX14HUBC106.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0867F4F1AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, June 04, 2013 6:44 PM
> To: Fengguang Wu
> Cc: KY Srinivasan; devel@linuxdriverproject.org; Greg Kroah-Hartman; linux-
> kernel@vger.kernel.org
> Subject: Re: [hv] BUG: kernel freezes after [ 13.356381] PCI: CLS 0 bytes, default
> 64
> 
> On Tue, Jun 04, 2013 at 10:15:36PM +0800, Fengguang Wu wrote:
> > Greetings,
> >
> > I got the below dmesg (kernel freezes at the end of it) and the first bad commit
> is
> >
> > commit cf6a2eacbcb2593b5b91d0817915c4f0464bb534
> > Author: K. Y. Srinivasan <kys@microsoft.com>
> > Date:   Thu Dec 1 09:59:34 2011 -0800
> >
> >     drivers: hv: Don't OOPS when you cannot init vmbus
> >
> >     The hv vmbus driver was causing an OOPS since it was trying to register
> drivers
> >     on top of the bus even if initialization of the bus has failed for some
> >     reason (such as the odd chance someone would run a hv enabled kernel in a
> >     non-hv environment).
> >
> >     Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> >     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >     Cc: stable <stable@vger.kernel.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > [   13.356381] PCI: CLS 0 bytes, default 64
> 
> Ick, not good.  K.Y., any reason why I shouldn't just revert this?

I have asked Wu for details. Examining the relevant VMBUS code, I cannot see
how this patch could be responsible for the freeze. For what it is worth looking at dmesg, it appears that
we are not running on a Hypervisor.

There was a bug in this patch and that was fixed a few days later:  

commit 8f257a142fc3868d69de3f996b95d7bdbc509560
Author: K. Y. Srinivasan <kys@microsoft.com>
Date:   Tue Dec 27 13:49:37 2011 -0800

    Drivers:hv: Fix a bug in vmbus_driver_unregister()

    The function vmbus_exists() was introduced recently to deal with cases where
    the vmbus driver failed to initialize and yet other Hyper-V drivers attempted
    to register with the vmbus bus driver. This patch introduced a bug where
    vmbus_driver_unregister() would fail to unregister the driver. This patch
    fixes the problem.

    Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
    Signed-off-by: Fuzhou Chen <fuzhouch@microsoft.com>
    Cc: Sasha Levin <levinsasha928@gmail.com>
    Cc: stable <stable@vger.kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Regards,

K. Y
 
> 
> thanks,
> 
> greg k-h
> 


