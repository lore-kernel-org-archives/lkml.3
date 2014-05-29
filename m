Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaE2Cb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:31:56 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52144 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaE2Cby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:31:54 -0400
Date: Wed, 28 May 2014 21:31:50 -0500
From: rkuo <rkuo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hexagon: remove checks for CONFIG_PAGE_SIZE_1MB
Message-ID: <20140529023150.GA9736@codeaurora.org>
References: <1400326363.13824.8.camel@x220>
 <20140521002524.GF12698@codeaurora.org>
 <1400855845.31526.40.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400855845.31526.40.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 04:37:25PM +0200, Paul Bolle wrote:
> There are two checks for CONFIG_PAGE_SIZE_1MB in hexagon's code. But
> there is no Kconfig symbol PAGE_SIZE_1MB. Remove these unneeded checks
> and the code they hide.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> Richard preferred this over the equally trivial patch to add an entry
> for PAGE_SIZE_1MB.
> 
>  arch/hexagon/include/asm/page.h    | 5 -----
>  arch/hexagon/include/asm/pgtable.h | 4 ----
>  2 files changed, 9 deletions(-)
> 

Thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
