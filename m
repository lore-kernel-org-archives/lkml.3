Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3EITsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:48:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12588 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3EITsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:48:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,642,1363158000"; 
   d="scan'208";a="45847438"
Message-ID: <518BFD99.2010208@codeaurora.org>
Date: Thu, 09 May 2013 12:48:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <518AE16D.5060501@codeaurora.org> <518B663D.60806@imgtec.com>
In-Reply-To: <518B663D.60806@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/13 02:02, James Hogan wrote:
> On 09/05/13 00:36, Stephen Boyd wrote:
>> On 04/19/13 09:28, James Hogan wrote:
>>> This patchset adds support for automatic selection of the best parent
>>> for a clock mux, i.e. the one which can provide the closest clock rate
>>> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
>>> so that it doesn't happen unless explicitly allowed.
>>>
>>> This works by way of adding a new op, determine_rate, similar to
>>> round_rate but with an extra parameter to allow the clock driver to
>>> optionally select a different parent clock. This is used in
>>> clk_calc_new_rates to decide whether to initiate a set_parent operation.
>> Which tree is this based on? I get failures with git am on patch 2.
>>
> It was based on v3.9-rc4.
>

Thanks. Would it be possible for you to update to Mike's for-next
branch? I've done the rebase myself for now and it seems to work well
enough. I'll need to add the set_rate_and_parent() op on top.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

