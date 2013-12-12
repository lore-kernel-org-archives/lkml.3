Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3LLQEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:04:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab3LLQE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:04:28 -0500
Date: Thu, 12 Dec 2013 17:06:13 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 10/11] PCI/MSI: Convert pci_msix_table_size() to a
 public interface
Message-ID: <20131212160612.GA14655@dhcp-26-207.brq.redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
 <4c879b0928ded8b4c9d2fab3fc413b98d34d8c7c.1385399393.git.agordeev@redhat.com>
 <20131210230847.GG4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210230847.GG4699@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 04:08:47PM -0700, Bjorn Helgaas wrote:
> If pci_msix_table_size() is a counterpart to pci_get_msi_cap(), can we make
> the names similar?

Tejun also pointed this out. What about pci_get_msi_vec_count() and
pci_get_msix_vec_count()?

Nevertheless, the existing names are more informative for me, since they
hint where the MSI/MSI-X vector count comes from. Up to you.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
