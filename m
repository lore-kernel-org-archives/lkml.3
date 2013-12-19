Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3LSWad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:30:33 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51574 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3LSWa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:30:29 -0500
Date: Thu, 19 Dec 2013 15:30:23 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 0/9] PCI/MSI: Introduce pci_auto_enable_msi*() family
 helpers
Message-ID: <20131219223023.GD15201@google.com>
References: <cover.1387140921.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 09:34:53AM +0100, Alexander Gordeev wrote:
> Alexander Gordeev (9):
>   PCI/MSI/s390: Fix single MSI only check
>   PCI/MSI/s390: Remove superfluous check of MSI type
>   PCI/MSI: Fix return value when populate_msi_sysfs() failed
>   PCI/MSI: Return -ENOSYS for unimplemented interfaces, not -1
>   PCI/MSI: Make pci_enable_msi/msix() 'nvec' argument type as int

I applied the patches above to pci/msi for v3.14 to get them out of the
way.

>   PCI/MSI: Factor out pci_get_msi_vec_count() interface
>   PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
>   PCI/MSI: Introduce pci_get_msix_vec_count() interface
>   PCI/MSI: Introduce pci_auto_enable_msi*() family helpers
