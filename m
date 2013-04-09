Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936459Ab3DIOtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:49:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55813 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933797Ab3DIOtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:49:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="37055779"
Message-ID: <51642A70.9060302@codeaurora.org>
Date: Tue, 09 Apr 2013 07:49:20 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH 3/4] clocksource: arch_timer: Push the read/write wrappers
 deeper
References: <1365474623-29181-1-git-send-email-sboyd@codeaurora.org> <1365474623-29181-4-git-send-email-sboyd@codeaurora.org> <20130409093855.GU23725@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130409093855.GU23725@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 02:38, Mark Rutland wrote:
> On Tue, Apr 09, 2013 at 03:30:22AM +0100, Stephen Boyd wrote:
>> -static inline u32 arch_timer_reg_read(const int access, const int reg)
>> +static inline u32 __arch_timer_reg_read(const int access, const int reg)
> Rather than prefixing all of these with "__", why not add "cp15" to the names?
>
> I think that'd make the end result more consistent and clearer, as we'd have a
> _mem version and a _cp15 version of each function.

Sounds fair. I'll make the change.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

