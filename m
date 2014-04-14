Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaDNQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:44:26 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:47756 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaDNQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:44:22 -0400
Message-ID: <1397493858.31076.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: hpsa driver bug crack kernel down!
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Date: Mon, 14 Apr 2014 09:44:18 -0700
In-Reply-To: <534C0AA9.5080909@linux.intel.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
		 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
		 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
		 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
		 <1397087425.9519.67.camel@dabdike>
		 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
		 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
		 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
		 <20140410071535.GX13491@8bytes.org>
		 <1397119587.19944.14.camel@shinybook.infradead.org>
		 <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
		 <1397207932.19944.58.camel@shinybook.infradead.org>
	 <1397490358.31076.6.camel@buesod1.americas.hpqcorp.net>
	 <534C0AA9.5080909@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 00:19 +0800, Jiang Liu wrote:
> Hi Davidlohr,
> 	Thanks for providing the DMAR table. According to the DMAR
> table, one bug in the iommu driver fails to handle this entry:
> [1D2h 0466   1]      Device Scope Entry Type : 01
> [1D3h 0467   1]                 Entry Length : 0A
> [1D4h 0468   2]                     Reserved : 0000
> [1D6h 0470   1]               Enumeration ID : 00
> [1D7h 0471   1]               PCI Bus Number : 00
> [1D8h 0472   2]                     PCI Path : 1C,04
> [1DAh 0474   2]                     PCI Path : 00,02
> 
> 	And the patch sent out by me should fix this bug. Could you please help
> to have a try?

Sorry, I am unable to find any patches from you regarding this issue...
I must be missing something. Could you please point me to the lkml link?

Thanks.

