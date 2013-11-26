Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3KZVAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:00:35 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:36104 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab3KZVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:00:33 -0500
Date: Tue, 26 Nov 2013 16:00:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 00/11] Introduce pcim_enable_msi*() family helpers
Message-ID: <20131126210026.GB8588@mtj.dyndns.org>
References: <cover.1385399393.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1385399393.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 26, 2013 at 10:09:49AM +0100, Alexander Gordeev wrote:
> Tejun, due to last three changes will you keep your "Acked-By" and
> "Reviewed-by" on these patches?
>   PCI/MSI: Factor out pci_get_msi_cap() interface
>   PCI/MSI: Get rid of pci_enable_msi_block_auto() interface
>   PCI/MSI: Convert pci_msix_table_size() to a public interface
>   PCI/MSI: Introduce pcim_enable_msi*() family helpers

Sure, the whole series looks good to me.

Thanks for doing this!

-- 
tejun
