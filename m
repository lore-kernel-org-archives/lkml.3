Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3KTQX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:23:29 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:64960 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3KTQX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:23:27 -0500
Date: Wed, 20 Nov 2013 11:23:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 11/29] PCI/MSI: Convert pci_msix_table_size() to a
 public interface
Message-ID: <20131120162324.GK28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <04a7098780907bd8848d4939b24a74e70e274866.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a7098780907bd8848d4939b24a74e70e274866.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 18, 2013 at 07:12:11PM +0200, Alexander Gordeev wrote:
> Make pci_msix_table_size() return error code if the device
> does not support MSI-X. This update is needed to create a
> consistent MSI-X counterpart for pci_get_msi_cap() MSI
> interface.
> 
> Device drivers can use this interface to obtain maximum number
> of MSI-X interrupts the device supports and i.e. use that number
> in a following call to pci_enable_msix() interface.

Please mention that the return value of the function has been changed
in the description.  Also, do we want to rename it to
pci_get_msix_cap() for consistency?

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
