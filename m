Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3KTHNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:13:34 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38851 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab3KTHNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:13:30 -0500
Date: Wed, 20 Nov 2013 15:13:02 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>,
        linux-pci@vger.kernel.org, Amos Kong <kongjianjun@gmail.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH v2 0/3] PCIe Capability accessor fixes [stable backports]
Message-ID: <20131120071302.GE3821@adam-laptop>
References: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:35:37PM -0700, Bjorn Helgaas wrote:
> The following patches fix issues reported by Yuval Mintz
> <yuvalmin@broadcom.com> and Myron Stowe <myron.stowe@redhat.com>.
> 
> These fix pcie_capability_read_dword() and related accessors, which first
> appeared in v3.7.  I backported these to v3.10.19 because that appears to
> be the oldest maintained stable kernel that is affected.
> 
> These patches replace the ones I posted yesterday at [1], because Myron
> pointed out that an additional patch, "Remove PCIe Capability version
> checks," is needed to fix the issue he found [2].
> 
> ---
> Bjorn Helgaas (3):
>       PCI: Allow PCIe Capability link-related register access for switches
>       PCI: Remove PCIe Capability version checks
>       PCI: Support PCIe Capability Slot registers only for ports with slots
> 
>  drivers/pci/access.c |   19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

Fixed a booting hang on some Lenovo laptops.

Tested-by: Adam Lee <adam.lee@canonical.com>

-- 
Adam Lee
