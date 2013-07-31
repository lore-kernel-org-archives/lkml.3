Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3GaHFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:05:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3GaHFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:05:09 -0400
Date: Wed, 31 Jul 2013 00:05:07 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Abhimanyu Kapur <abhimany@codeaurora.org>
Cc: Anton Vorontsov <anton@enomsg.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: power: reset: add msm restart support
Message-ID: <20130731070507.GH8868@codeaurora.org>
References: <1375229128-32226-1-git-send-email-abhimany@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375229128-32226-1-git-send-email-abhimany@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Abhimanyu Kapur wrote:
> Add support for restart and poweroff functionality present on MSM
> chipsets with the MPM2 ps-hold hardware.
> 
> Signed-off-by: Abhimanyu Kapur <abhimany@codeaurora.org>
> ---

Thanks, this version looks good. Feel free to add my reviewed-by:

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
