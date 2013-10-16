Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab3JPWAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:00:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49745 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3JPWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:00:19 -0400
Date: Wed, 16 Oct 2013 15:00:16 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: debug: Create CONFIG_DEBUG_MSM_UART and
 re-organize the selects for MSM
Message-ID: <20131016220016.GA6326@codeaurora.org>
References: <1380841557-2673-1-git-send-email-rvaswani@codeaurora.org>
 <1380841557-2673-2-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1380841557-2673-2-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 04:05:54PM -0700, Rohit Vaswani wrote:
>Create the hidden config DEBUG_MSM_UART and clean-up the default selection
>for CONFIG_DEBUG_LL_INCLUDE.
>
>Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
