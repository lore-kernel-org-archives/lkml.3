Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3FESdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:33:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3FESds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:33:48 -0400
Date: Wed, 5 Jun 2013 14:33:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130605183318.GE12812@phenom.dumpdata.com>
References: <CAErSpo7onNaU5mquJ_a7kwGPgzs3Q_7U89__HT9DbJFkUX4fsQ@mail.gmail.com>
 <20130529083652.GA25971@dhcp-26-207.brq.redhat.com>
 <CAErSpo4EkXX-UoFLyni+ZpXaTmCRq5sJCqZ4FCt7fywpDyVWqw@mail.gmail.com>
 <CAErSpo6bjBEK=Ta=pVzwCBMfrqfe3jB-sEfv1Kz9mt9iakdeaA@mail.gmail.com>
 <20130604131451.GA24385@dhcp-26-207.brq.redhat.com>
 <CAErSpo7DL0LeW_rZ0KL-AzBEM-crj+zaiG9n9f8SRn2Sd+6Atw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7DL0LeW_rZ0KL-AzBEM-crj+zaiG9n9f8SRn2Sd+6Atw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:18:54AM -0600, Bjorn Helgaas wrote:
> On Tue, Jun 4, 2013 at 7:14 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> > On Mon, Jun 03, 2013 at 02:46:59PM -0600, Bjorn Helgaas wrote:
> >> On Wed, May 29, 2013 at 2:58 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> I pushed these with updates to
> >> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/alexander-msi
> >>
> >> Anybody want to ack the iommu/irq_remapping.c patch?  If so, I can
> >> merge that branch into -next for v3.11.
> >
> > Konrad, Sebastian,
> >
> > Any chance to take a look and patch 2/2?

I presume you mean:
x86/MSI: Conserve interrupt resources when using multiple-MSI

? Looks good
This one:
PCI: Allocate only as many MSI vectors as requested by driver


looks OK as well.


> 
> I went out on a limb and merged this into my -next branch for v3.11.
> If anybody objects, let me know and I'll drop or rework it.
> 
> Bjorn
