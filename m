Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab3KZU6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:58:43 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:41494 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab3KZU6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:58:42 -0500
Date: Tue, 26 Nov 2013 15:58:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 07/11] PCI/MSI: Make pci_enable_msi/msix() 'nvec'
 argument type as int
Message-ID: <20131126205836.GA8588@mtj.dyndns.org>
References: <cover.1385399393.git.agordeev@redhat.com>
 <50fceee5c8b44c950c6082a6d73c643fa3788c81.1385399393.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50fceee5c8b44c950c6082a6d73c643fa3788c81.1385399393.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:09:56AM +0100, Alexander Gordeev wrote:
> Make pci_enable_msi_block(), pci_enable_msi_block_auto() and
> pci_enable_msix() consistent with regard to the type of 'nvec'
> argument.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
