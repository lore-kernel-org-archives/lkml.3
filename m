Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaB0WVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:21:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53765 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB0WU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:20:59 -0500
Date: Thu, 27 Feb 2014 14:14:58 -0800
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: config: Update msm_defconfig
Message-ID: <20140227221458.GA5334@codeaurora.org>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
 <1393467394-10907-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1393467394-10907-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:16:34PM -0800, Stephen Boyd wrote:
>Now that DT based platforms are split out of mach-msm into
>mach-qcom, put back a non-DT based SoC into the msm_defconfig and
>stop selecting unsupported drivers.
>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> arch/arm/configs/msm_defconfig | 25 +++----------------------
> 1 file changed, 3 insertions(+), 22 deletions(-)

Acked-by: David Brown <davidb@codeaurora.org>

Kumar, can you just pull this in with the other qcom changes from
Sephen?

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
