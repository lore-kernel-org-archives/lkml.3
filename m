Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaDGV5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:57:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41276 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaDGV5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:57:46 -0400
Date: Mon, 7 Apr 2014 14:57:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: Remove MSM_SCM
Message-ID: <20140407215744.GI9985@codeaurora.org>
References: <1396778225.30640.12.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396778225.30640.12.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Paul Bolle wrote:
> Commit 8fc1b0f87d9f ("ARM: qcom: Split Qualcomm support into legacy and
> multiplatform") removed all users of Kconfig symbol MSM_SCM. Remove that
> symbol too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
