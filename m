Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaFZLgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:36:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38304 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaFZLgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:36:10 -0400
Message-ID: <53AC05C4.2030104@arm.com>
Date: Thu, 26 Jun 2014 12:36:36 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/9] ARM: kernel: add support for cpu cache information
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1403717444-23559-9-git-send-email-sudeep.holla@arm.com> <53AB6700.2060807@codeaurora.org>
In-Reply-To: <53AB6700.2060807@codeaurora.org>
X-OriginalArrivalTime: 26 Jun 2014 11:35:56.0949 (UTC) FILETIME=[CBBB8450:01CF9132]
X-MC-Unique: 114062612360902801
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 26/06/14 01:19, Stephen Boyd wrote:
> On 06/25/14 10:30, Sudeep Holla wrote:
>> +
>> +/*
>> + * Which cache CCSIDR represents depends on CSSELR value
>> + * Make sure no one else changes CSSELR during this
>> + * smp_call_function_single prevents preemption for us
>> + */
>
> Where's the smp_call_function_single() or preemption disable happening?
>

init_cache_level is called using smp_call_function_single in
drivers/base/cacheinfo.c(PATCH 2/9)

Regards,
Sudeep

