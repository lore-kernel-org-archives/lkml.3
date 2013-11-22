Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3KVSw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:52:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab3KVSwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:52:55 -0500
Date: Fri, 22 Nov 2013 19:54:45 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131122185445.GI8401@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
 <20131120171526.GL28946@htj.dyndns.org>
 <20131122184429.GG8401@dhcp-26-207.brq.redhat.com>
 <20131122184447.GB8981@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122184447.GB8981@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:44:47PM -0500, Tejun Heo wrote:
> +int pcim_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
> +                         unsigned int nvec, unsigned int minvec)
> +
> +This variation on pci_enable_msi_block() call allows a device driver to
> +request any number of MSIs within specified range minvec to nvec. Whenever
> +possible device drivers are encouraged to use this function rather than
> +explicit request loop calling pci_enable_msi_block().
> 
> e.g. shouldn't that @nvec be @maxvec?

Right, it should. May be even in different order.

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
