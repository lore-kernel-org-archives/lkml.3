Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaFWDDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:03:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35999 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaFWDDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:03:39 -0400
Message-ID: <53A79905.9020007@gmail.com>
Date: Mon, 23 Jun 2014 11:03:33 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com> <53A6669B.1010701@roeck-us.net> <53A66A92.9040106@gmail.com> <53A6EDF6.2030203@roeck-us.net> <53A6EFEC.1020207@roeck-us.net>
In-Reply-To: <53A6EFEC.1020207@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 11:02 PM, Guenter Roeck wrote:
> On 06/22/2014 07:53 AM, Guenter Roeck wrote:
>> I did that, and managed to build gcc.
>>
>> However, when trying to compile score defconfig, I get internal
>> compiler errors in cc1
>> when compiling drivers/tty/tty_mutex.o and block/elevator.o.
>>
>>   CC      block/elevator.o
>> score-elf-gcc: internal compiler error: Segmentation fault (program cc1)
>> 0x40c073 execute
>>      ../../gcc/gcc/gcc.c:2848
>> Please submit a full bug report,
>> with preprocessed source if appropriate.
>> Please include the complete backtrace with any bug report.
>> See <http://gcc.gnu.org/bugs.html> for instructions.
>> make[1]: *** [block/elevator.o] Error 4
>> make: *** [block/elevator.o] Error 2
>>
>> Do you see that as well ?
>>
>> This is with
>>
>> GNU assembler version 2.24.51 (score-elf) using BFD version (GNU
>> Binutils) 2.24.51.20140622
>>
>> and gcc configured with:
>>
>> Configured with: ../gcc/configure --prefix=/opt/kernel/score
>> --program-prefix=score-elf- \
>> --target=score-elf --without-header --disable-nls --enable-languages=c
>> --disable-threads \
>> --disable-shared --enable-werror=no
>> target_configargs=enable_vtable_verify=yes \
>> --enable-obsolete --disable-libssp --disable-libquadmath
>>
>> Tip of gcc source is commit d8686b0aa945a, tip of binutils source is
>> commit d17c74c1d41.
>> Your assembler fix is included in this version of binutils.
>>
> 
> Never mind, turns out I get score:defconfig to compile when using the
> tip of the gcc 4.9 branch.
> 
> Guenter
> 

OK, I shall try defconfig for it (originally, I try allmodconfig, not
find this issue), and try to solve it, hope (although I am not quite
sure), I can finish within this month (2014-06-30).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
