Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3J3U1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:27:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56235 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3J3U1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:27:31 -0400
Date: Wed, 30 Oct 2013 13:27:29 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ARM: dts: msm: Add Krait CPU/L2 nodes
Message-ID: <20131030202729.GA21945@codeaurora.org>
References: <1383164736-1849-1-git-send-email-sboyd@codeaurora.org>
 <1383164736-1849-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1383164736-1849-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:25:36PM -0700, Stephen Boyd wrote:
>This allows us to probe the krait-edac driver.
>
>Cc: David Brown <davidb@codeaurora.org>
>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> arch/arm/boot/dts/qcom-msm8974.dtsi | 37 +++++++++++++++++++++++++++++++++++++
> 1 file changed, 37 insertions(+)

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
