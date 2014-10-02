Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaJBK5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:57:51 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40480 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJBK5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:57:48 -0400
Date: Thu, 2 Oct 2014 11:57:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sean Paul <seanpaul@chromium.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "ritesh.harjani@gmail.com" <ritesh.harjani@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH v2] arm64: Use DMA_ERROR_CODE to denote failed allocation
Message-ID: <20141002105732.GB32147@e104818-lin.cambridge.arm.com>
References: <20141001135248.GQ5182@n2100.arm.linux.org.uk>
 <1412177510-26310-1-git-send-email-seanpaul@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412177510-26310-1-git-send-email-seanpaul@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 04:31:50PM +0100, Sean Paul wrote:
> This patch replaces the static assignment of ~0 to dma_handle with
> DMA_ERROR_CODE to be consistent with other platforms.
> 
> Signed-off-by: Sean Paul <seanpaul@chromium.org>

Applied. Thanks.

-- 
Catalin
