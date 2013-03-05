Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab3CETE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:04:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43568 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3CETE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:04:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355126400"; 
   d="scan'208";a="27786757"
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 5/8] ARM: MSM: Divorce msm_timer from local timer API
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
	<1361518039-16663-6-git-send-email-sboyd@codeaurora.org>
Date: Tue, 05 Mar 2013 11:04:57 -0800
In-Reply-To: <1361518039-16663-6-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 21 Feb 2013 23:27:16 -0800")
Message-ID: <8yad2vd1xd2.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> Separate the msm_timer from the local timer API. This will allow
> us to remove ARM local timer support in the near future and gets
> us closer to moving this driver to drivers/clocksource.
>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/timer.c | 125 +++++++++++++++++++++++++---------------------

Acked-by: David Brown <davidb@codeaurora.org>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
