Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3JNN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:58:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63041 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab3JNN6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:58:49 -0400
Message-ID: <525BF88C.4070608@gmail.com>
Date: Mon, 14 Oct 2013 21:58:36 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 1/4] arm64: fix possible invalid FPSIMD initialization
 state
References: <1381674029-430-1-git-send-email-liuj97@gmail.com> <20131014135457.GE7682@arm.com>
In-Reply-To: <20131014135457.GE7682@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 09:54 PM, Catalin Marinas wrote:
> On Sun, Oct 13, 2013 at 03:20:17PM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> If context switching happens during executing fpsimd_flush_thread(),
>> stale value in FPSIMD registers will be saved into current thread's
>> fpsimd_state by fpsimd_thread_switch(). That may cause invalid
>> initialization state for the new process, so disable preemption
>> when executing fpsimd_flush_thread().
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jiang Liu <liuj97@gmail.com>
> 
> That's already in mainline (3.12-rc4).
> 

Hi Catalin,
	I haven't noticed that yet, sorry for the noise:)
Thanks!
Gerry
