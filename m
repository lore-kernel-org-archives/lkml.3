Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaLEVkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:40:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59374 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaLEVkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:40:04 -0500
Date: Fri, 5 Dec 2014 15:40:02 -0600
From: Andy Gross <agross@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: qcom: Correct IPQ tlmm interrupt
Message-ID: <20141205214002.GB14438@qualcomm.com>
References: <1417812813-12804-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417812813-12804-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 12:53:33PM -0800, Stephen Boyd wrote:
> The interrupt is 16, not 32 (which it would be if we include PPIs
> in the count of interrupts).
> 
> Cc: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

This fixed my issue!

Reviewed-by: Andy Gross <agross@codeaurora.org>
Tested-by: Andy Gross <agross@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

