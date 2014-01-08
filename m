Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbaAHLGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:06:38 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53413 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaAHLGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:06:34 -0500
Message-ID: <52CD3132.4@gmail.com>
Date: Wed, 08 Jan 2014 19:06:26 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 6/7] arm64, jump label: optimize jump label implementation
References: <1389104234-15239-1-git-send-email-liuj97@gmail.com> <1389104234-15239-7-git-send-email-liuj97@gmail.com> <20140107154622.GA4399@mudshark.cambridge.arm.com>
In-Reply-To: <20140107154622.GA4399@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,
	Who should I send this patch set for merging?
Thanks!
Gerry
On 01/07/2014 11:46 PM, Will Deacon wrote:
> On Tue, Jan 07, 2014 at 02:17:13PM +0000, Jiang Liu wrote:
>> Optimize jump label implementation for ARM64 by dynamically patching
>> kernel text.
>>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/arm64/Kconfig                  |  1 +
>>  arch/arm64/include/asm/jump_label.h | 52 +++++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/Makefile          |  1 +
>>  arch/arm64/kernel/jump_label.c      | 58 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 112 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/jump_label.h
>>  create mode 100644 arch/arm64/kernel/jump_label.c
> 
>   Reviewed-by: Will Deacon <will.deacon@arm.com>
> 
> Thanks for sticking with this! I think this series is good for merging now.
> 
> Will
> 

