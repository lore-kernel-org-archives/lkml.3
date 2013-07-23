Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3GWPwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:52:45 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:14692
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932138Ab3GWPwn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:52:43 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377424004)(377454003)(24454002)(189002)(199002)(51704005)(74706001)(47736001)(47976001)(49866001)(74316001)(83322001)(74662001)(19580405001)(63696002)(74502001)(31966008)(66066001)(65816001)(50986001)(79102001)(51856001)(76482001)(77982001)(59766001)(4396001)(54356001)(77096001)(56776001)(81542001)(33646001)(69226001)(74876001)(46102001)(16406001)(80022001)(83072001)(47446002)(74366001)(19580395003)(81342001)(54316002)(76786001)(76796001)(56816003)(53806001)(76576001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Michal Hocko <mhocko@suse.cz>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kay@vrfy.org" <kay@vrfy.org>
Subject: RE: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Thread-Topic: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Thread-Index: AQHOhLBUexA6H+ozR02R0nup8ZuRHJlwpwQAgAGspICAABA7gIAACQlg
Date: Tue, 23 Jul 2013 15:50:52 +0000
Message-ID: <1b32d8e17e2546908d42e6d702b13cfd@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130722123716.GB24400@dhcp22.suse.cz>
 <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130723150931.GM8677@dhcp22.suse.cz>
In-Reply-To: <20130723150931.GM8677@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0916FC3A18
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VRFY.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michal Hocko [mailto:mhocko@suse.cz]
> Sent: Tuesday, July 23, 2013 11:10 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com;
> jasowang@redhat.com; kay@vrfy.org
> Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
> memory blocks
> 
> On Tue 23-07-13 14:52:36, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Michal Hocko [mailto:mhocko@suse.cz]
> > > Sent: Monday, July 22, 2013 8:37 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > > kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org;
> yinghan@google.com;
> > > jasowang@redhat.com; kay@vrfy.org
> > > Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
> > > memory blocks
> > >
> > > On Fri 19-07-13 12:23:05, K. Y. Srinivasan wrote:
> > > > The current machinery for hot-adding memory requires having udev
> > > > rules to bring the memory segments online. Export the necessary
> functionality
> > > > to to bring the memory segment online without involving user space code.
> > >
> > > Why? Who is going to use it and for what purpose?
> > > If you need to do it from the kernel cannot you use usermod helper
> > > thread?
> > >
> > > Besides that this is far from being complete. memory_block_change_state
> > > seems to depend on device_hotplug_lock and find_memory_block is
> > > currently called with mem_sysfs_mutex held. None of them is exported
> > > AFAICS.
> >
> > You are right; not all of the required symbols are exported (yet). Let
> > me answer your other questions first:
> >
> > The Hyper-V balloon driver can use this functionality. I have
> > prototyped the in-kernel "onlining" of hot added memory without
> > requiring any help from user level code that performs significantly
> > better than having user level code involved in the hot add process.
> 
> What does significantly better mean here?

Less failures than before.
> 
> > With this change, I am able to successfully hot-add and online the
> > hot-added memory even under extreme memory pressure which is what you
> > would want given that we are hot-adding memory to alleviate memory
> > pressure. The current scheme of involving user level code to close
> > this loop obviously does not perform well under high memory pressure.
> 
> Hmm, this is really unexpected. Why the high memory pressure matters
> here? Userspace only need to access sysfs file and echo a simple string
> into a file. The reset is same regardless you do it from the userspace.

Could it be that we could fail to launch the user-space thread. The host  presents
a large chunk of memory for "hot adding". Within the guest, I break this up and hot-add
128MB chunks; as I loop through this process, I wait for the onlining to occur before proceeding
with the next hotadd operation. With user space code involved in the onlining process, I would 
frequently timeout waiting for onlining to complete (under high memory load).
After I switched over to not involving the user space code, this problem does not exist since
onlining is done "in context".
  
> 
> > I can, if you prefer export all of the necessary functionality in one
> > patch.
> 
> If this turns out really a valid use case then I would prefer exporting
> a high level function which would hide all the locking and direct
> manipulation with mem blocks.

I will take a crack at defining wrappers to hide some of the details. I will also
post the Hyper-V balloon driver patch that uses this functionality.

Regards,

K. Y 



