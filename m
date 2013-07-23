Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab3GWQ4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:56:01 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:48065
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932705Ab3GWQz7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:55:59 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC102.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(377454003)(24454002)(13464003)(199002)(189002)(164054003)(51704005)(74316001)(51856001)(19580395003)(74706001)(83322001)(66066001)(16406001)(19580405001)(81342001)(69226001)(76796001)(76786001)(77982001)(63696002)(46102001)(76576001)(47736001)(59766001)(74876001)(47976001)(74366001)(77096001)(54316002)(47446002)(56816003)(81542001)(80022001)(53806001)(74502001)(65816001)(74662001)(49866001)(4396001)(83072001)(79102001)(31966008)(33646001)(50986001)(54356001)(76482001)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kay@vrfy.org" <kay@vrfy.org>
Subject: RE: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Thread-Topic: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Thread-Index: AQHOhLBUexA6H+ozR02R0nup8ZuRHJlycooAgAAOoHA=
Date: Tue, 23 Jul 2013 16:54:50 +0000
Message-ID: <84917bea4f304a649eaf640f8926f09b@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130723160158.GC27054@kroah.com>
In-Reply-To: <20130723160158.GC27054@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0916FC3A18
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VRFY.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, July 23, 2013 12:02 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-
> mm@kvack.org; kamezawa.hiroyuki@gmail.com; mhocko@suse.cz;
> hannes@cmpxchg.org; yinghan@google.com; jasowang@redhat.com;
> kay@vrfy.org
> Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
> memory blocks
> 
> On Fri, Jul 19, 2013 at 12:23:05PM -0700, K. Y. Srinivasan wrote:
> > The current machinery for hot-adding memory requires having udev
> > rules to bring the memory segments online. Export the necessary functionality
> > to to bring the memory segment online without involving user space code.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/base/memory.c  |    5 ++++-
> >  include/linux/memory.h |    4 ++++
> >  2 files changed, 8 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> > index 2b7813e..a8204ac 100644
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -328,7 +328,7 @@ static int
> __memory_block_change_state_uevent(struct memory_block *mem,
> >  	return ret;
> >  }
> >
> > -static int memory_block_change_state(struct memory_block *mem,
> > +int memory_block_change_state(struct memory_block *mem,
> >  		unsigned long to_state, unsigned long from_state_req,
> >  		int online_type)
> >  {
> > @@ -341,6 +341,8 @@ static int memory_block_change_state(struct
> memory_block *mem,
> >
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(memory_block_change_state);
> 
> EXPORT_SYMBOL_GPL() for all of these please.

Will do.
> 
> And as others have pointed out, I can't export symbols without a user of
> those symbols going into the tree at the same time.  So I'll drop this
> patch for now and wait for your consumer of these symbols to be
> submitted.

I will submit the consumer as well.

Thanks,

K. Y
 
> greg k-h
> 
> 



