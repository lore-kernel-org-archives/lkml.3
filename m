Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3KFQdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:33:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3KFQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:32:59 -0500
Message-ID: <527A6F36.7030300@gmail.com>
Date: Thu, 07 Nov 2013 00:32:54 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 5/7] arm64, jump label: detect %c support for ARM64
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com> <1382109602-27432-6-git-send-email-liuj97@gmail.com> <20131030004927.GD25346@mudshark.cambridge.arm.com>
In-Reply-To: <20131030004927.GD25346@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 08:49 AM, Will Deacon wrote:
> On Fri, Oct 18, 2013 at 04:19:59PM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> As commit a9468f30b5eac6 "ARM: 7333/2: jump label: detect %c
>> support for ARM", this patch detects the same thing for ARM64
>> because some ARM64 GCC versions have the same issue.
>>
>> Some versions of ARM64 GCC which do support asm goto, do not
>> support the %c specifier. Since we need the %c to support jump
>> labels on ARM64, detect that too in the asm goto detection script
>> to avoid build errors with these versions.
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> The toolchain is being fixed upstream for this, but we should have the check
> for older versions.
> 
> Will
> 
Thanks for review!

