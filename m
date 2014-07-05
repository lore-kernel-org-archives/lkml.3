Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaGEV4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 17:56:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaGEV4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 17:56:24 -0400
Date: Sat, 5 Jul 2014 23:56:20 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Add bridge DMA alias quirk for Intel 82801
Message-ID: <20140705215620.GA27261@suse.de>
References: <20140623223530.13445.94886.stgit@gimli.home>
 <20140705163143.GB6247@google.com>
 <20140705212629.GF28871@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140705212629.GF28871@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 03:26:29PM -0600, Bjorn Helgaas wrote:
> I saw that Joerg applied those iommu changes to his core branch, which I
> assume will be merged for v3.17.  So I'll move this to a pci/iommu branch,
> to be merged during the v3.17 merge window.

Yes, these changes are queued for v3.17.


	Joerg

