Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaCDUZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:25:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38291 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbaCDUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:25:26 -0500
Message-ID: <531636B4.1060202@codeaurora.org>
Date: Tue, 04 Mar 2014 12:25:24 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: myungjoo.ham@samsung.com
CC: =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] PM / devfreq: Rewrite devfreq_update_status() to fix
 multiple bugs
References: <8984550.302431393927576253.JavaMail.weblogic@epv6ml05>
In-Reply-To: <8984550.302431393927576253.JavaMail.weblogic@epv6ml05>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 02:06 AM, MyungJoo Ham wrote:
>> The current devfreq_update_status() has the following bugs:
>> - If previous frequency doesn't have a valid level, it does an out of bounds
>>    access into the trans_table and causes memory corruption.
>> - When the new frequency doesn't have a valid level, the time spent in the
>>    new frequency is counted towards the next valid frequency switch instead of
>>    being ignored.
>> - The time spent on the previous frequency is added to the new frequency's
>>    stats instead of the previous frequency's stats.
>>
>> This patch fixes all of this.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> 
> Merged.
> 
> It appears to be Greg's LTS material as well.
> 

Thanks!

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
