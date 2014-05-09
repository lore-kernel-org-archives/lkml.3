Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaEICuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:50:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaEICuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:50:07 -0400
Date: Fri, 9 May 2014 04:49:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 1/4] DMA-API: Clarify physical/bus address distinction
Message-ID: <20140509024957.GD21085@kroah.com>
References: <20140508204257.17877.4639.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140508204854.17877.59304.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508204854.17877.59304.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 02:48:54PM -0600, Bjorn Helgaas wrote:
> The DMA-API documentation sometimes refers to "physical addresses" when it
> really means "bus addresses."  Sometimes these are identical, but they may
> be different if the bridge leading to the bus performs address translation.
> Update the documentation to use "bus address" when appropriate.
> 
> Also, consistently capitalize "DMA", use parens with function names, use
> dev_printk() in examples, and reword a few sections for clarity.
> 
> No functional change; documentation changes only.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
