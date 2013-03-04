Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3CDCgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:36:33 -0500
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:5360
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755052Ab3CDCgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:36:32 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 1/1] mm: Export split_page().
Thread-Topic: [PATCH 1/1] mm: Export split_page().
Thread-Index: AQHOGHvemlZPo/qvy0iTzgXsO5BJg5iUySmAgAAASkCAAASPAIAAAE8g
Date: Mon, 4 Mar 2013 02:36:02 +0000
Message-ID: <b863089d05f442fb9dfc90faa158a001@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1362364075-14564-1-git-send-email-kys@microsoft.com>
 <20130304020747.GA8265@kroah.com>
 <3a362e994ab64efda79ae3c80342db95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130304022508.GA8638@kroah.com>
In-Reply-To: <20130304022508.GA8638@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(24454001)(51704002)(377454001)(189002)(199002)(23726001)(16676001)(53806001)(74662001)(46406002)(5343635001)(47776003)(74502001)(59766001)(56776001)(66066001)(77982001)(50986001)(76482001)(63696002)(5343655001)(20776003)(44976002)(47976001)(47446002)(46102001)(6806001)(54316002)(47736001)(4396001)(31966008)(33646001)(50466001)(56816002)(80022001)(51856001)(49866001)(79102001)(65816001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB010;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0775716B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, March 03, 2013 9:25 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-
> mm@kvack.org
> Subject: Re: [PATCH 1/1] mm: Export split_page().
> 
> On Mon, Mar 04, 2013 at 02:14:02AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Sunday, March 03, 2013 9:08 PM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de;
> > > apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-
> > > mm@kvack.org
> > > Subject: Re: [PATCH 1/1] mm: Export split_page().
> > >
> > > On Sun, Mar 03, 2013 at 06:27:55PM -0800, K. Y. Srinivasan wrote:
> > > > The split_page() function will be very useful for balloon drivers. On Hyper-V,
> > > > it will be very efficient to use 2M allocations in the guest as this (a) makes
> > > > the ballooning protocol with the host that much more efficient and (b)
> moving
> > > > memory in 2M chunks minimizes fragmentation in the host. Export the
> > > split_page()
> > > > function to let the guest allocations be in 2M chunks while the host is free to
> > > > return this memory at arbitrary granularity.
> > > >
> > > >
> > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > ---
> > > >  mm/page_alloc.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index 6cacfee..7e0ead6 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -1404,6 +1404,7 @@ void split_page(struct page *page, unsigned int
> order)
> > > >  	for (i = 1; i < (1 << order); i++)
> > > >  		set_page_refcounted(page + i);
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(split_page);
> > >
> > > When you export a symbol, you also need to post the code that is going
> > > to use that symbol, otherwise people don't really know how to judge this
> > > request.
> > >
> > > Can you just make this a part of your balloon driver update patch series
> > > instead?
> >
> > Fair enough; I was hoping to see how inclined the mm folks were with regards
> to
> > exporting this symbol before I went ahead and modified the balloon driver
> code to
> > leverage this. Looking at the Windows guests on Hyper-V, I am convinced 2M
> balloon
> > allocations in the Linux (Hyper-V) balloon driver will make significant difference.
> As you
> > suggest, I will post this patch as part of the balloon driver changes that use this
> exported
> > symbol. I am still hoping to get some feedback from the mm guys on this.
> 
> I guess the most obvious question about exporting this symbol is, "Why
> doesn't any of the other hypervisor balloon drivers need this?  What is
> so special about hyper-v?"

The balloon protocol that Hyper-V has specified is designed around the ability to
move 2M pages. While the protocol can handle 4k allocations, it is going to be very chatty
with 4K allocations. Furthermore, the Memory Balancer on the host is also designed to work
best with memory moving around in 2M chunks. While I have not seen the code on the Windows
host that does this memory balancing, looking at how Windows guests behave in this environment,
(relative to Linux) I have to assume that the 2M allocations that Windows guests do are a big part of
the difference we see.
 
> 
> Or can those other drivers also need/use it as well, and they were just
> too chicken to be asking for the export?  :)

The 2M balloon allocations would make sense if the host is designed accordingly.

Regards,

K. Y


