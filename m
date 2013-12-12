Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3LLQLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:11:21 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:61268 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LLQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:11:19 -0500
Date: Thu, 12 Dec 2013 11:11:07 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 11/11] PCI/MSI: Introduce pcim_enable_msi*() family
 helpers
Message-ID: <20131212161107.GI32683@htj.dyndns.org>
References: <cover.1385399393.git.agordeev@redhat.com>
 <086bc30b22688c629911d02e230d1bc876fb946f.1385399393.git.agordeev@redhat.com>
 <20131210231602.GH4699@google.com>
 <20131212161100.GB14655@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212161100.GB14655@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:11:01PM +0100, Alexander Gordeev wrote:
> On Tue, Dec 10, 2013 at 04:16:02PM -0700, Bjorn Helgaas wrote:
> > What's the reason for using the "pcim_" prefix?  To me, that suggests that
> > this is a "managed" interface in the sense described in
> > Documentation/driver-model/devres.txt, where resources are automatically
> > deallocated when the driver detaches.  But I don't see anything like that
> > happening in this patch.
> 
> Oh.. right. What about pci_auto_ prefix to indicate automatic fallback
> logic? Or may be even pcia_ ?

I'd vote for pci_auto, one-off single char pre/postfixes usually get
pretty confusing.

Thanks.

-- 
tejun
