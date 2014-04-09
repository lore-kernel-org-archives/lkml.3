Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbaDINU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:20:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbaDINUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:20:53 -0400
Date: Wed, 9 Apr 2014 15:22:40 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: Re: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140409132239.GA4474@dhcp-26-207.brq.redhat.com>
References: <cover.1392733151.git.agordeev@redhat.com>
 <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
 <32E1700B9017364D9B60AED9960492BC211F62DC@FMSMSX107.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211F62DC@FMSMSX107.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:11:39PM +0000, Marciniszyn, Mike wrote:
> > Subject: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
> > pci_enable_msix()
> > 
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these two
> > interfaces need to be updated to use the new pci_enable_msi_range() and
> > pci_enable_msix_range() interfaces.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> 
> This worked fine!
> 
> Roland, can you fix up the subject to change qib to IB/qib when you merge it?
> 
> Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Hi Roland,

Do you want me to repost these patches?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
