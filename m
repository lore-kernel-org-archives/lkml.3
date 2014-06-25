Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaFYN3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:29:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33026 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbaFYN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:29:22 -0400
Message-ID: <53AACEA8.3010002@suse.cz>
Date: Wed, 25 Jun 2014 15:29:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com
CC: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/111] 3.12.23-stable review
References: <cover.1403512280.git.jslaby@suse.cz> <53A83FE7.8080904@roeck-us.net>
In-Reply-To: <53A83FE7.8080904@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 04:55 PM, Guenter Roeck wrote:
> On 06/23/2014 01:32 AM, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.23 release.
>> There are 111 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed Jun 25 08:31:21 2014
>> Anything received after that time might be too late.
>>
> 
> Build results:
>     total: 144 pass: 136 skipped: 7 fail: 1
> Failed builds:
>     unicore32:defconfig
> Qemu tests all passed.
> 
> Results are as expected. Details are available at
...
> The unicore32 build now passes in mainline. To get it to pass in 3.12,
> you'd have to cherry-pick commit 1ff38c56cbd0
> (arch/unicore32/mm/alignment.c:
> include "asm/pgtable.h" to avoid compiling error) and backport commit
> fbc6c4a13bbfb
> (drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap).
> The video file was moved from drivers/video/fb-puv3.c after 3.12, which
> is why
> the patch doesn't apply directly.

Done.

On 06/23/2014 06:45 PM, Shuah Khan wrote:
> Compiled and booted on my test system. No dmesg regressions.

On 06/24/2014 12:13 AM, Satoru Takeuchi wrote:
> This kernel passed my test.

Thank you all.

-- 
js
suse labs
