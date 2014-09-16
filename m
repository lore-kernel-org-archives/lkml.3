Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaIPVYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:24:20 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33756 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaIPVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:24:18 -0400
Message-ID: <5418AA80.4090102@codeaurora.org>
Date: Tue, 16 Sep 2014 17:24:16 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: Sonny Rao <sonnyrao@chromium.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] arm: Handle starting up in secure mode
References: <1410901756-20694-1-git-send-email-cov@codeaurora.org>
In-Reply-To: <1410901756-20694-1-git-send-email-cov@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 05:09 PM, Christopher Covington wrote:
> ARM Linux currently has the most features available to it in hypervisor
> (HYP) mode, so switch to it when possible. This can also ensure proper
> reset of newer registers such as CNTVOFF.
> 
> The permissions on the Non-Secure Access Control Register (NSACR) are
> used to probe what the security setting currently is when in supervisor
> (SVC) mode.

Sorry, this doesn't work yet. I was misinterpreting my test results. For what
it's worth, my testing and development methodology is to run it after hacked
up versions of the semihosting bootwrapper on the simulator that corresponds
to rtsm_ve-aemv8a.dtb (AEM VE FVP these days?) and examine the instruction traces.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
