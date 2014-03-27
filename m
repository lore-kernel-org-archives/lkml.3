Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaC0PYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:24:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43396 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaC0PYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:24:46 -0400
Message-ID: <533442B9.80900@gmail.com>
Date: Thu, 27 Mar 2014 16:24:41 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Chris Ball <chris@printf.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/5] mmc: dove: prepare new Dove DT Kconfig variable
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com> <1393662801-17950-4-git-send-email-sebastian.hesselbarth@gmail.com> <20140304040357.GH1872@titan.lakedaemon.net>
In-Reply-To: <20140304040357.GH1872@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 05:03 AM, Jason Cooper wrote:
> On Sat, Mar 01, 2014 at 09:33:20AM +0100, Sebastian Hesselbarth wrote:
>> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
>> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
>> DT-only MACH_DOVE Kconfig.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Chris,
>>
>> Mark Brown requested to take the corresponding ASoC patch through
>> his tree. Therefore, I have split the former patch into individual subsystem
>> patches.
>>
>> Cc: Chris Ball <chris@printf.net>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/mmc/host/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

Ping. Chris, can you please take it in for v3.15-rc1?

Sebastian

