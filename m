Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3DVRAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:00:45 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:41998 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3DVRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:00:43 -0400
Message-ID: <51756CB6.5060607@linaro.org>
Date: Mon, 22 Apr 2013 10:00:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] ARM 64 bit sched_clock take #2
References: <51709FD7.8050408@gmail.com> <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 05:29 PM, Stephen Boyd wrote:
> This is what I was thinking. I don't see why we can't move this to generic code and have arm64 use it too. Those patches will follow once I find an arm64
> compiler.

I think moving this to generic code sounds like a good idea. You could 
probably also prototype and test the 64bit code with x86_64, using the 
TSC counter.

thanks
-john

