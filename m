Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3EFSBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:01:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15672 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3EFSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:01:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,623,1363158000"; 
   d="scan'208";a="44708309"
Message-ID: <5187EFF3.6010005@codeaurora.org>
Date: Mon, 06 May 2013 14:01:23 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] ARM: Remove any correlation between IPC and BogoMips
 value
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1367602547-19322-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 05/03/2013 01:35 PM, Will Deacon wrote:
> Hi all,
> 
> This small patch set may look a little over a month late, but there is a
> serious reason for posting it.
> 
> When I moved the ARM delay loop over to using the architected timers
> rather than the CPU spinning loop (which has all the problems associated
> with cpu frequency scaling and what-not) I thought I was doing something
> useful for the port. However, it turns out that a surprising number of
> people have complained, and continue to complain, about the drop in
> their `BogoMIPs score'.

Have you considered adding the old code back in, but in a form that's not at
all referenced by the delay loop code and just calculates CPU-based bogomips?

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
