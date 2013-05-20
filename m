Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3ETVRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:17:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21209 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab3ETVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:17:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="scan'208";a="49068557"
Message-ID: <519A92DC.2030208@codeaurora.org>
Date: Mon, 20 May 2013 14:17:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v4 3/5] clk: add support for clock reparent on set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1369056507-32521-4-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/13 06:28, James Hogan wrote:
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index b9911c2..3110ba4 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -70,6 +70,10 @@ the operations defined in clk.h:
>  						unsigned long parent_rate);
>  		long		(*round_rate)(struct clk_hw *hw, unsigned long,
>  						unsigned long *);
> +		long		(*determine_rate)(struct clk_hw *hw,
> +						unsigned long rate,
> +						unsigned long *best_parent_rate,
> +						struct clk **best_parent_clk);
>  		int		(*set_parent)(struct clk_hw *hw, u8 index);
>  		u8		(*get_parent)(struct clk_hw *hw);
>  		int		(*set_rate)(struct clk_hw *hw, unsigned long);

Can you update the clock hardware characteristics table as well?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

