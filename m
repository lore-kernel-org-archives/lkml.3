Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaDUNqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaDUNqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:46:10 -0400
Date: Mon, 21 Apr 2014 14:36:05 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] ioat: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140421133604.GB25116@dhcp-26-169.brq.redhat.com>
References: <cover.1394128952.git.agordeev@redhat.com>
 <2ba22558b5db90740d5833c35570c3e7cc1e359e.1394128952.git.agordeev@redhat.com>
 <CAPcyv4jW19zxApviDdbofbXB1OvvN2sCriL3Paszfk9o3T8x0w@mail.gmail.com>
 <20140306214356.GA16376@dhcp-26-207.brq.redhat.com>
 <CAPcyv4ivvxHvyT_5oybVvRJAUKABQQ1ZH4Eua-1KVDeri5kpkA@mail.gmail.com>
 <20140307074932.GC2670@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307074932.GC2670@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 08:49:32AM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Function pci_enable_msix() returns a tri-state value while
> pci_enable_msi_exact() is a canonical zero/-errno variant.
> The former is being phased out in favor of the latter.
> In case of 'ioat' there (should be) no difference.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Hi Dan,

Would you pick this patch, please?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
