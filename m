Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbaFRKNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:13:32 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41511 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965039AbaFRKNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:13:31 -0400
Date: Wed, 18 Jun 2014 11:13:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: remove define of ARCH_HAS_DMA_GET_REQUIRED_MASK
Message-ID: <20140618101326.GB14680@arm.com>
References: <1403024823-2180-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403024823-2180-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 06:07:03PM +0100, Mark Salter wrote:
> Arm64 defines ARCH_HAS_DMA_GET_REQUIRED_MASK but provides
> no dma_get_required_mask() function. This leads to a link
> error in drivers using dma_get_required_mask(). Remove the
> define so the default dma_get_required_mask() is available.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

I already got a similar patch to push in -rc2.

Thanks.

-- 
Catalin
