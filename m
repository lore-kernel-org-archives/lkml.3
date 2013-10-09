Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3JIHIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:08:20 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45696 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3JIHIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:08:19 -0400
Message-ID: <525500DD.8050204@gmail.com>
Date: Wed, 09 Oct 2013 09:08:13 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Dinh Nguyen <dinguyen@altera.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/8] ARM: add initial support for Marvell Berlin SoCs
References: <1381235073-17134-1-git-send-email-sebastian.hesselbarth@gmail.com> <1381235073-17134-9-git-send-email-sebastian.hesselbarth@gmail.com> <1381274699.5184.2.camel@linux-builds1>
In-Reply-To: <1381274699.5184.2.camel@linux-builds1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 01:24 AM, Dinh Nguyen wrote:
> Hi Sebastian,
>
> On Tue, 2013-10-08 at 14:24 +0200, Sebastian Hesselbarth wrote:
>> This adds initial support for the Marvell Berlin (88DE3xxx) SoC family
>> and basic machine setup for Armada 1500 (88DE3100) SoCs.
[...]
>> +config MACH_MV88DE3100
>> +	bool "Marvell 88DE3100 (Armada 1500)"
>> +	select ARM_GIC
>> +	select CACHE_L2X0
>> +	select CPU_PJ4B
>> +	select HAVE_ARM_TWD if LOCAL_TIMERS
>> +	select HAVE_SMP
>> +	select LOCAL_TIMERS if SMP
>
> I think because of commit:
>
> a894fcc2d [ARM: smp_twd: Divorce smp_twd from local timer API]
>
> you can remove the LOCAL_TIMERS for HAVE_ARM_TWD.

Thanks, Dinh, I will have a look at this.


