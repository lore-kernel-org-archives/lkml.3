Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3FDWyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:54:47 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:1685
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754963Ab3FDWym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:54:42 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: 0
X-BigFish: PS0(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh17ej9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>, Fengguang Wu <fengguang.wu@intel.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0 bytes,
 default 64
Thread-Topic: [hv] BUG: kernel freezes after [   13.356381] PCI: CLS 0
 bytes, default 64
Thread-Index: AQHOYS5/WRdBXqmqq0S3b2N5KDpZCZkmJ8IAgAABlmA=
Date: Tue, 4 Jun 2013 22:52:45 +0000
Message-ID: <004626f8493844e1a1f0a573226183ae@SN2PR03MB061.namprd03.prod.outlook.com>
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
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KROAH.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(377454002)(24454002)(13464003)(51704005)(50466002)(20776003)(69226001)(23726002)(77982001)(74502001)(79102001)(76786001)(56776001)(74366001)(81542001)(50986001)(76796001)(74706001)(47976001)(81342001)(51856001)(53806001)(47446002)(49866001)(46102001)(59766001)(6806003)(80022001)(74662001)(76576001)(54356001)(16676001)(33646001)(47736001)(31966008)(4396001)(63696002)(74876001)(74316001)(65816001)(76482001)(44976003)(54316002)(56816003)(47776003)(46406003)(77096001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB016;H:TK5EX14MLTC104.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

Greg,

I am looking into this. 

Regards,

K. Y
> 
> thanks,
> 
> greg k-h
> 


