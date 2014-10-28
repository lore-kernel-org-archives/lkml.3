Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaJ1RzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:55:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58354 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaJ1RzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:55:01 -0400
Date: Tue, 28 Oct 2014 10:54:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: vfp: Fix VFPv3 hwcap detection on CPUID
 based cpus
Message-ID: <20141028175459.GE12469@codeaurora.org>
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
 <1413294539-22069-3-git-send-email-sboyd@codeaurora.org>
 <20141027103118.GA8768@arm.com>
 <544EA212.7030401@codeaurora.org>
 <20141028121154.GA12136@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028121154.GA12136@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Will Deacon wrote:
> 
> Sure. There's a spelling mistake ("arhitecture") which you should fix,
> but the code looks ok.

Ok I'll fix it up and send it off to the patch tracker if I don't
hear anything else.

> > 
> > I have an RFC for the undef handler written up, except for the
> > big/little thing. Let me post it. Is there anyone from the userspace
> > side that can be on Cc?
> 
> Off the top of my head:
> 
>   Mans Rullgard (already replied to this thread)
>   Peter Maydell <peter.maydell@linaro.org> [QEMU]
>   Jacob Bramley <jacob.bramley@arm.com> [JITs]
>   Kyrylo Tkachov <kyrylo.tkachov@arm.com> [GCC]
> 

Thanks. I'll add them to the patch for next round and add them on
Cc for the current patch on the list.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
