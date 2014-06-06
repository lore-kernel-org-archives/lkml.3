Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaFFQBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:01:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaFFQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:01:10 -0400
Date: Fri, 6 Jun 2014 09:01:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, devel@driverdev.osuosl.org,
        Shuah Khan <shuah.kh@samsung.com>, discuss@x86-64.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140606160103.GG15110@kroah.com>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
 <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org>
 <20140604141211.GC23880@8bytes.org>
 <20140604141416.GD5004@htj.dyndns.org>
 <538F3548.4050101@gmail.com>
 <20140604212525.GE23880@8bytes.org>
 <5391A9C2.3040602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5391A9C2.3040602@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:45:06PM +0300, Eli Billauer wrote:
> Hello Joerg.
> 
> 
> On 05/06/14 00:25, Joerg Roedel wrote:
> >
> >What you are trying to do should work with dma_alloc_noncoherent(). The
> >API allows partial syncs on this memory, so you should be fine.
> Please try to put yourself in my position: I have a driver that I care
> about, which works fine for a few years. It's based upon dma_map_single(),
> which seems to be the common way to get non-coherent memory, even for the
> driver's entire lifespan. I realize that dma_alloc_* was the intended way to
> do it, but fact is that dma_map_* has become the common choice.

Is your driver in the kernel tree?  If not, you really are on your own :(

greg k-h
