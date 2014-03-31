Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaCaTvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaCaTvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:51:12 -0400
Date: Mon, 31 Mar 2014 21:52:52 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 0/2] block: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140331195139.GA19867@dhcp-26-207.brq.redhat.com>
References: <cover.1393404496.git.agordeev@redhat.com>
 <20140313041231.GC26657@google.com>
 <5321CE94.5070506@kernel.dk>
 <20140313173656.GA4939@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313173656.GA4939@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 06:36:56PM +0100, Alexander Gordeev wrote:
> Oh-oh, cciss patch #2 requires commit 3ce4e86 ("PCI/MSI: Add
> pci_enable_msi_exact() and pci_enable_msix_exact()") which was
> pulled to 3.14-rc4 only. Sorry for failing to clarify that :(
> 
> And I also notice 3111cc3 ("skd: Use pci_enable_msix_exact() instead
> of pci_enable_msix_range()") in your tree also should not compile :(

Hi Jens,

3.14 contains prerequisite commits for the patches above.
Would you pull them or do you want me to resend the two?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
