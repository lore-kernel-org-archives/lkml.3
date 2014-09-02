Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaIBWBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:01:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaIBWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:01:17 -0400
Message-ID: <54063E2B.6090403@codeaurora.org>
Date: Tue, 02 Sep 2014 15:01:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH] clk: qcom: Fix sdc 144kHz frequency entry
References: <1409341766-24366-1-git-send-email-sboyd@codeaurora.org> <20140902214402.5251.75274@quantum>
In-Reply-To: <20140902214402.5251.75274@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/14 14:44, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-08-29 12:49:26)
>> The pre-divider for the sdc clocks only has 2 bits in it, so we
>> can't possibly divide by anything larger than 4 here.
>> Furthermore, we program the value of ~(n - m) and the n value is
>> larger than 8 bits (max of 256). Replace this entry with 200kHz
>> which is close enough to 144kHz to be usable.
>>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Andy Gross <agross@codeaurora.org>
>> Fixes: 24d8fba44af3 "clk: qcom: Add support for IPQ8064's global clock controller (GCC)"
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Do you need this pulled into a 3.17-rc?
>

Yes that would be helpful since this fixes a driver introduced into 3.17.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

