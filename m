Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaDYSYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 14:24:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaDYSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 14:24:48 -0400
Date: Fri, 25 Apr 2014 11:27:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] GenWQE: Use pci_enable_msi_exact() instead of
 pci_enable_msi_block()
Message-ID: <20140425182741.GB6473@kroah.com>
References: <cover.1397458024.git.agordeev@redhat.com>
 <6e4ebc84c90c5f8e49a931e915ec373576ad416a.1397458024.git.agordeev@redhat.com>
 <20140425181911.GI32246@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425181911.GI32246@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:19:11PM -0600, Bjorn Helgaas wrote:
> On Mon, Apr 14, 2014 at 09:14:06AM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range()  or pci_enable_msi_exact()
> > and pci_enable_msix_range() or pci_enable_msix_exact()
> > interfaces.
> > 
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Frank Haverkamp <haver@linux.vnet.ibm.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-pci@vger.kernel.org
> > Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> 
> Greg, since you acked this rather than saying you applied it, I applied
> this to my pci/msi branch.  If you'd rather take it yourself, just let me
> know.

Nope, through your tree is fine, I have enough other patches in my trees :)

greg k-h
