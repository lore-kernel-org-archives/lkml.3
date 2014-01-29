Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaA2K5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:57:55 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63183 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaA2K5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:57:54 -0500
Date: Wed, 29 Jan 2014 10:57:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: hw_breakpoint: Add ARMv8 support
Message-ID: <20140129105722.GD26622@mudshark.cambridge.arm.com>
References: <20140128183851.GK2885@mudshark.cambridge.arm.com>
 <1390935112-28465-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390935112-28465-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Tue, Jan 28, 2014 at 06:51:51PM +0000, Christopher Covington wrote:
> Add the trivial support necessary to get hardware breakpoints
> working for GDB on ARMv8 simulators running in AArch32 mode.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
> 
>  v3: assume for now that ARMv9 and later will update FSR

Please can you stick this into the patch system? I don't have any other
hw_breakpoint changes queued, so I doubt I'll send a pull for 3.15.

Cheers,

Will
