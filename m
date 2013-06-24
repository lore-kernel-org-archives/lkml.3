Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab3FXUHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:07:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49413 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3FXUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:07:51 -0400
Message-ID: <51C8A716.8050005@codeaurora.org>
Date: Mon, 24 Jun 2013 13:07:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, arm@kernel.org,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over global
 devices
References: <51B0A6E8.20909@linaro.org> <20130606180425.GQ599@codeaurora.org> <51B10D85.1060507@linaro.org> <20130606223848.GR599@codeaurora.org> <20130612214435.GE10823@codeaurora.org> <51B991EF.70800@linaro.org> <alpine.LFD.2.02.1306131331430.22970@ionos> <20130613183950.GA32061@codeaurora.org> <20130618102257.GH6809@e106331-lin.cambridge.arm.com> <20130619163043.GA6300@codeaurora.org> <20130621170755.GB14575@codeaurora.org>
In-Reply-To: <20130621170755.GB14575@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 10:07, Stephen Boyd wrote:
> On 06/19, Stephen Boyd wrote:
>> Can you pick up the first two patches in this series please? And
>> preferably make a stable branch that can be pulled into arm-soc?
>> Then I can send the rest through the arm-soc tree.
>>
> ping?
>

Thomas, please apply these first two patches.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

