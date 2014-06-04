Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaFDOOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:14:22 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:53374 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaFDOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:14:20 -0400
Date: Wed, 4 Jun 2014 10:14:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, Eli Billauer <eli.billauer@gmail.com>,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        discuss@x86-64.org
Subject: Re: [PATCH v2 1/4] dma-mapping: Add devm_ interface for
 dma_map_single()
Message-ID: <20140604141416.GD5004@htj.dyndns.org>
References: <1401606077-1739-1-git-send-email-eli.billauer@gmail.com>
 <1401606077-1739-2-git-send-email-eli.billauer@gmail.com>
 <538E3D04.9060808@samsung.com>
 <20140603233907.GB23880@8bytes.org>
 <20140604140408.GC5004@htj.dyndns.org>
 <20140604141211.GC23880@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604141211.GC23880@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 04, 2014 at 04:12:11PM +0200, Joerg Roedel wrote:
> Yes, but those drivers usually get DMA buffers at init time with the
> dma_alloc_* interfaces. The dma_map_* interfaces discussed here belong
> to the streaming DMA-API, so they are usually used for only one DMA
> transaction before dma_unmap_* is called on them.
> 
> A devm interface for the dma_alloc_* family of functions would
> actually make sense, but not for the dma_map_* functions.

Ah, okay.  Fair enough.

Thanks.

-- 
tejun
