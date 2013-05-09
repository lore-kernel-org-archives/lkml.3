Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3EIDuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 23:50:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58381 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3EIDuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 23:50:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="45604574"
Message-ID: <518B1D00.5030700@codeaurora.org>
Date: Wed, 08 May 2013 20:50:24 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <518AE16D.5060501@codeaurora.org>
In-Reply-To: <518AE16D.5060501@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:36 PM, Stephen Boyd wrote:
> On 04/19/13 09:28, James Hogan wrote:
>> This patchset adds support for automatic selection of the best parent
>> for a clock mux, i.e. the one which can provide the closest clock rate
>> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
>> so that it doesn't happen unless explicitly allowed.
>>
>> This works by way of adding a new op, determine_rate, similar to
>> round_rate but with an extra parameter to allow the clock driver to
>> optionally select a different parent clock. This is used in
>> clk_calc_new_rates to decide whether to initiate a set_parent operation.
>
> Which tree is this based on? I get failures with git am on patch 2.
>

Mike's clk-for-3.10 branch.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
