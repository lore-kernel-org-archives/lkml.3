Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3ERIaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 04:30:23 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:53343 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3ERIaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 04:30:21 -0400
Message-ID: <51973C1D.2080404@prisktech.co.nz>
Date: Sat, 18 May 2013 20:30:21 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Alexey Charkov <alchark@gmail.com>
CC: VT8500/WM8505 Linux Kernel 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] MAINTAINERS: vt8500: Add clk-vt8500.c to MAINTAINERS
 file
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz> <1368825532-30917-5-git-send-email-linux@prisktech.co.nz> <CABjd4Yw2LbnaUbQFW_bd_6WRGTA34-Vp_tUC2b4Jczj-MM8x1w@mail.gmail.com>
In-Reply-To: <CABjd4Yw2LbnaUbQFW_bd_6WRGTA34-Vp_tUC2b4Jczj-MM8x1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/13 18:40, Alexey Charkov wrote:
> On 18 May 2013 01:18, "Tony Prisk" <linux@prisktech.co.nz> wrote:
>> This file has missed being added under ARM/VT8500 ARM ARCHITECTURE,
>> and is maintained along with the rest of the vt8500 arch code.
>>
>> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
>> ---
>>   MAINTAINERS |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3d7782b..5ab8ccb 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1283,6 +1283,7 @@ M:        Tony Prisk <linux@prisktech.co.nz>
>>   L:     linux-arm-kernel@lists.infradead.org (moderated for
> non-subscribers)
>>   S:     Maintained
>>   F:     arch/arm/mach-vt8500/
>> +F:     drivers/clk/vt8500-vt8500.c
> This looks like a typo (clk vs. vt8500).
>
> Best,
> Alexey
>
eeek - oops.

Mike,

Disregard this patch - I will send a more complete one through arm-soc 
as there are other files missing as well.

Regards
Tony P
