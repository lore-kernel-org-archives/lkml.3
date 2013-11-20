Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3KTQVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:21:23 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:46003 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3KTQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:21:18 -0500
Date: Wed, 20 Nov 2013 11:21:14 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 10/29] PCI/MSI: Get rid of
 pci_enable_msi_block_auto() interface
Message-ID: <20131120162114.GJ28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <246d1586c10fc8c787935e6d14c80f7fc268cd00.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <246d1586c10fc8c787935e6d14c80f7fc268cd00.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:12:10PM +0200, Alexander Gordeev wrote:
> As result of introduction of pci_get_msi_cap() interface
> pci_enable_msi_block_auto() function became superflous.
> 
> To enable maximum possible number of MSIs drivers will
> first obtain that number from pci_get_msi_cap() function
> and then call pci_enable_msi_block() interface.

It'd be nice to mention that _auto has been introduced recently and
has only single user in ahci which is updated by this patch.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Bjorn, please feel free to route this through pci branch.

Thanks.

-- 
tejun
