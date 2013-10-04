Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3JDJT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:19:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab3JDJTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:19:55 -0400
Date: Fri, 4 Oct 2013 11:21:09 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-mips@linux-mips.org,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-nvme@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-s390@vger.kernel.org,
        Andy King <acking@vmware.com>, linux-scsi@vger.kernel.org,
        linux-rdma@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-pci@vger.kernel.org,
        iss_storagedev@hp.com, linux-driver@qlogic.com,
        Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jon Mason <jon.mason@intel.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, e1000-devel@lists.sourceforge.net,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
Message-ID: <20131004092108.GB4536@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
 <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7371@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7371@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:31:49AM +0100, David Laight wrote:
> > Mmmm.. I am not sure I am getting it. Could you please rephrase?
> 
> One possibility is for drivers than can use a lot of interrupts to
> request a minimum number initially and then request the additional
> ones much later on.
> That would make it less likely that none will be available for
> devices/drivers that need them but are initialised later.

It sounds as a whole new topic for me. Isn't it?

Anyway, what prevents the above from being done with pci_enable_msix(nvec1) -
pci_disable_msix() - pci_enable_msix(nvec2) where nvec1 < nvec2?

> 	David

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
