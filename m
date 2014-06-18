Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbaFRJxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:53:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35486 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756481AbaFRJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:53:44 -0400
Date: Wed, 18 Jun 2014 10:53:29 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Message-ID: <20140618095329.GE11973@arm.com>
References: <1402092436-2144-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402092436-2144-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:07:16PM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> Arm64 does not define dma_get_required_mask() function.
> Therefore, it should not define the ARCH_HAS_DMA_GET_REQUIRED_MASK.
> This causes build errors in some device drivers (e.g. mpt2sas)
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Applied. Thanks.

-- 
Catalin
