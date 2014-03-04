Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaCDAf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:35:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaCDAfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:35:54 -0500
Message-ID: <53151FE8.70703@codeaurora.org>
Date: Mon, 03 Mar 2014 16:35:52 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM / devfreq: Rewrite devfreq_update_status() to fix
 multiple bugs
References: <1393558737-24037-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1393558737-24037-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 07:38 PM, Saravana Kannan wrote:
> The current devfreq_update_status() has the following bugs:
> - If previous frequency doesn't have a valid level, it does an out of bounds
>    access into the trans_table and causes memory corruption.
> - When the new frequency doesn't have a valid level, the time spent in the
>    new frequency is counted towards the next valid frequency switch instead of
>    being ignored.
> - The time spent on the previous frequency is added to the new frequency's
>    stats instead of the previous frequency's stats.
>
> This patch fixes all of this.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---

MyungJoo/Kyungmin,

Can you please take a look and let me know if this looks ok? Any 
possibility of getting this into 3.14?

Thanks,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
