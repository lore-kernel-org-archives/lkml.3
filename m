Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423523Ab3FURH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:07:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49834 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423404Ab3FURH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:07:56 -0400
Date: Fri, 21 Jun 2013 10:07:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, arm@kernel.org,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over
 global devices
Message-ID: <20130621170755.GB14575@codeaurora.org>
References: <51B0A6E8.20909@linaro.org>
 <20130606180425.GQ599@codeaurora.org>
 <51B10D85.1060507@linaro.org>
 <20130606223848.GR599@codeaurora.org>
 <20130612214435.GE10823@codeaurora.org>
 <51B991EF.70800@linaro.org>
 <alpine.LFD.2.02.1306131331430.22970@ionos>
 <20130613183950.GA32061@codeaurora.org>
 <20130618102257.GH6809@e106331-lin.cambridge.arm.com>
 <20130619163043.GA6300@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619163043.GA6300@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Stephen Boyd wrote:
> 
> Can you pick up the first two patches in this series please? And
> preferably make a stable branch that can be pulled into arm-soc?
> Then I can send the rest through the arm-soc tree.
> 

ping?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
