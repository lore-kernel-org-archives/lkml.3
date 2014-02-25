Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaBYVN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:13:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46289 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBYVN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:13:57 -0500
Message-ID: <530D0794.2080405@codeaurora.org>
Date: Tue, 25 Feb 2014 13:13:56 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM / devfreq: Fix out of bounds access of transition
 table array
References: <1393226100-18428-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1393226100-18428-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 11:15 PM, Saravana Kannan wrote:
> The previous_freq value for a device could be an invalid frequency that
> results in a error value being returned from devfreq_get_freq_level().
> Check for an error value before using that to index into the transition
> table.
>
> Not doing this check will result in memory corruption when previous_freq is
> not a valid frequency.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

MyungJoo/Kyungmin,

Would either of you have some time to respond to this?

Thanks,
Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
