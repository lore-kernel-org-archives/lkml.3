Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaIGC2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 22:28:24 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33277 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIGC2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 22:28:23 -0400
Message-ID: <540BC2C3.1070509@converseincode.com>
Date: Sat, 06 Sep 2014 19:28:19 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: catalin.marinas@arm.com, will.deacon@arm.com, zhichang.yuan@linaro.org,
        Mark Charlebois <charlebm@gmail.com>, dsaxena@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are
 needed for clang
References: <1409959394-14936-1-git-send-email-behanw@converseincode.com> <2954780.2t9bpyu7ov@wuerfel>
In-Reply-To: <2954780.2t9bpyu7ov@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/14 07:16, Arnd Bergmann wrote:
> On Friday 05 September 2014 16:23:14 behanw@converseincode.com wrote:
>> --- /dev/null
>> +++ b/arch/arm64/lib/eabi.c
>> @@ -0,0 +1,32 @@
>> +/*
>> + *  linux/lib/eabi.c
> Please don't put the file names in the files themselves, it's redundant
> and in this case actually wrong.
Will fix.

>> + *  Copyright (C) 2012  Mark Charlebois
>> + */
>> +
>> +/*
>> + * EABI routines
> Does EABI specify these function names? I would think that they are
> just random libgcc (whatever that is called in clang) functions.
These specialized functions are part of the ABI for the ARM architecture 
(AEABI). They aren't random.

Memcpy and memmove *could* might be satisfied with linker magic instead. 
But memset uses the reverse parameter list.

Behan

-- 
Behan Webster
behanw@converseincode.com

