Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3CERdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:33:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41573 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3CERdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:33:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,788,1355126400"; 
   d="scan'208";a="27549352"
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: Scorpion is a v7 architecture, not v6
References: <1362439159-29258-1-git-send-email-sboyd@codeaurora.org>
	<201303050831.37177.arnd@arndb.de>
Date: Tue, 05 Mar 2013 09:33:21 -0800
In-Reply-To: <201303050831.37177.arnd@arndb.de> (Arnd Bergmann's message of
	"Tue, 5 Mar 2013 08:31:36 +0000")
Message-ID: <8yappzd21lq.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 04 March 2013, Stephen Boyd wrote:
>>  config ARCH_MULTI_V6
>> -       bool "ARMv6 based platforms (ARM11, Scorpion, ...)"
>> +       bool "ARMv6 based platforms (ARM11)"
>>         select ARCH_MULTI_V6_V7
>>         select CPU_V6
>
> Sorry about that, my fault.
>
> Was there also an ARMv6 core from Qualcomm, or did you only use ARM11 at
> the time?

I believe the v6 core in the Qualcomm chips was an ARM11.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
