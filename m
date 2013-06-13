Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3FMBfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:35:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40677 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3FMBfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:35:15 -0400
Message-ID: <51B921D2.2030700@codeaurora.org>
Date: Wed, 12 Jun 2013 18:35:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v4 0/5] clk: implement remuxing during set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/13 06:28, James Hogan wrote:
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be disabled by a new CLK_SET_RATE_NO_REPARENT
> flag (which is set for all uses of clk_register_mux().
>
> This works by way of adding a new op, determine_rate, similar to
> round_rate but with an extra parameter to allow the clock driver to
> optionally select a different parent clock. This is used in
> clk_calc_new_rates to decide whether to initiate a set_parent operation.

I'd like to see this go into 3.11. We can tackle the larger problem that
Saravana brought up later on since we're no worse off than we already
are without these patches.

Feel free to add my reviewed-by to all patches.

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

