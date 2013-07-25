Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3GYPuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:50:55 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3998
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab3GYPux convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:50:53 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(24454002)(13464003)(199002)(189002)(377454003)(51704005)(479174003)(51856001)(74706001)(46102001)(63696002)(66066001)(83322001)(69226001)(16406001)(76576001)(76796001)(31966008)(74876001)(81342001)(77982001)(74316001)(47736001)(59766001)(56776001)(47976001)(74366001)(76482001)(74502001)(53806001)(81542001)(56816003)(80022001)(50986001)(74662001)(65816001)(47446002)(54316002)(19580405001)(83072001)(49866001)(79102001)(76786001)(4396001)(33646001)(77096001)(19580395003)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Dave Hansen <dave@sr71.net>
CC: Michal Hocko <mhocko@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHOhLBUexA6H+ozR02R0nup8ZuRHJlwpwQAgAGspICAABWHgIAABmSQgAACj4CAAA/eQIABjleAgAArP0CAAB1DAIAAtuGAgAAyoQCAAESVgIAACFxw
Date: Thu, 25 Jul 2013 15:49:00 +0000
Message-ID: <828d748273884d6f9c24b658964f97c3@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130722123716.GB24400@dhcp22.suse.cz>
 <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA11D.4030007@intel.com>
 <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA89F.9070309@intel.com>
 <9f351a549e76483d9148f87535567ea0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51F00415.8070104@sr71.net>
 <d1f80c05986b439cbeef12bcd595b264@BLUPR03MB050.namprd03.prod.outlook.com>
 <51F040E8.1030507@intel <51F13E51.7040808@sr71.net>
In-Reply-To: <51F13E51.7040808@sr71.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0918748D70
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GMAIL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KVACK.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX-FOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CMPXCHG.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VRFY.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%GOOGLE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%FIRSTFLOOR.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.CZ$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SR71.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dave Hansen [mailto:dave@sr71.net]
> Sent: Thursday, July 25, 2013 11:04 AM
> To: KY Srinivasan
> Cc: Michal Hocko; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com;
> jasowang@redhat.com; kay@vrfy.org
> Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
> memory blocks
> 
> On 07/25/2013 04:14 AM, KY Srinivasan wrote:
> > As promised, I have sent out the patches for (a) an implementation of an in-
> kernel API
> > for onlining  and a consumer for this API. While I don't know the exact reason
> why the
> > user mode code is delayed (under some low memory conditions), what is the
> harm in having
> > a mechanism to online memory that has been hot added without involving user
> space code.
> 
> KY, your potential problem, not being able to online more memory because
> of a shortage of memory, is a serious one.

All I can say is that the online is not happening within the allowed time (5 seconds in
the current code).
> 
> However, this potential issue exists in long-standing code, and
> potentially affects all users of memory hotplug.  The problem has not
> been described in sufficient detail for the rest of the developers to
> tell if you are facing a new problem, or whether *any* proposed solution
> will help the problem you face.
> 
> Your propsed solution changes the semantics of existing user/kernel
> interfaces, duplicates existing functionality, and adds code complexity
> to the kernel.

How so? All I am doing is to use the existing infrastructure to online
memory. The only change I have made is to export an API that allows
onlining without involving any user space code. I don't see how  this
adds complexity to the kernel. This would be an useful extension as can
be seen from its usage in the Hyper-V balloon driver.

In my particular use case, I need to wait for the memory to be onlined before
I can proceed to hot add the next chunk. This synchronization can be completely
avoided if we can avoid the involvement of user level code. I would submit to you that
this is a valid use case that we ought to be able to support.

Regards,

K. Y



