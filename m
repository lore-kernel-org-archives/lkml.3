Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3EHXgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:36:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2375 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3EHXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:36:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,636,1363158000"; 
   d="scan'208";a="45418390"
Message-ID: <518AE16D.5060501@codeaurora.org>
Date: Wed, 08 May 2013 16:36:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/13 09:28, James Hogan wrote:
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> so that it doesn't happen unless explicitly allowed.
>
> This works by way of adding a new op, determine_rate, similar to
> round_rate but with an extra parameter to allow the clock driver to
> optionally select a different parent clock. This is used in
> clk_calc_new_rates to decide whether to initiate a set_parent operation.

Which tree is this based on? I get failures with git am on patch 2.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

