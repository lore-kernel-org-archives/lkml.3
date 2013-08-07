Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3HGVII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:08:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59859 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab3HGVIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:08:06 -0400
Date: Wed, 7 Aug 2013 14:08:04 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] ARM: msm: fix compilation error in gpiomux
Message-ID: <20130807210804.GB14845@codeaurora.org>
References: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
 <20130807174053.GA17551@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807174053.GA17551@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, David Brown wrote:
> On Wed, Aug 07, 2013 at 08:34:39AM +0200, Krzysztof Kozlowski wrote:
> >Fix compilation error in gpiomux (CONFIG_MSM_GPIOMUX=y):
> >arch/arm/mach-msm/gpiomux.c:24:13: error: static declaration of
> >	???__msm_gpiomux_write??? follows non-static declaration
> >arch/arm/mach-msm/gpiomux.h:85:6: note: previous declaration of
> >	???__msm_gpiomux_write??? was here
> >
> >Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Thanks, I'll pull this in.
> 
>  <https://patchwork.kernel.org/patch/2839921/>
> 

I believe this is fixed by Rohit's patch that has already been
taken in a pull request?

https://lkml.org/lkml/2013/7/26/608

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
