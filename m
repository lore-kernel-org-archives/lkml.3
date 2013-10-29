Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3J2FFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:05:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53342 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2FFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:05:50 -0400
Date: Mon, 28 Oct 2013 22:05:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] ARM: Add Krait L2 accessor functions
Message-ID: <20131029050548.GB21983@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-4-git-send-email-sboyd@codeaurora.org>
 <20131029011942.GG4763@kartoffel>
 <526F0DB5.8050800@codeaurora.org>
 <20131029013230.GI4763@kartoffel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029013230.GI4763@kartoffel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Mark Rutland wrote:
> On Tue, Oct 29, 2013 at 01:21:57AM +0000, Stephen Boyd wrote:
> > On 10/28/13 18:19, Mark Rutland wrote:
> > > It might be worth commmenting inline as to what register each of these is
> > > accessing. Inevitably the commit message will become harder to find and
> > > associate with the code over time.
> > >
> > > Similarly for get_l2_indirect_reg.
> > 
> > Do you mean with the "@" syntax in the assembly? The 80-character limit
> > is out to get me.
> 
> I probably didn't mean inline :)
> 
> How about a block comment above the first asm block like:
> 
> /*
>  * Select the L2 window by poking l2cpselr, then write to the window via
>  * l2cpdr.
>  */
> 

Ok sure.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
