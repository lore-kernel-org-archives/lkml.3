Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3EaSig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:38:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54130 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab3EaSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:38:30 -0400
Date: Fri, 31 May 2013 11:38:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Barry Song <baohua.song@csr.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv6 07/11] ARM: PRIMA2: Divorce timer-marco from local
 timer API
Message-ID: <20130531183828.GE599@codeaurora.org>
References: <1368473175-4841-1-git-send-email-sboyd@codeaurora.org>
 <1368473175-4841-8-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368473175-4841-8-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Stephen Boyd wrote:
> Separate the marco local timers from the local timer API. This
> will allow us to remove ARM local timer support in the near future
> and gets us closer to moving this driver to drivers/clocksource.
> 
> Cc: Barry Song <baohua.song@csr.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Barry, have you been able to test this patch?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
