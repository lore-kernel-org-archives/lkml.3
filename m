Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab3K1JFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:05:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48753 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3K1JEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:04:55 -0500
Message-ID: <529707B9.1090809@gmail.com>
Date: Thu, 28 Nov 2013 17:07:05 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vineet:

hexagon meets the same issue, could you help send related patch for it?

If you have no time, please let me know, I should send it within next
month.

BTW: I assume hexagon need not support VGA_CONSOLE, either, if it is
incorrect, please let me know thanks.


> On 10/24/2013 07:50 PM, Vineet Gupta wrote:
>> On 10/24/2013 04:56 PM, Chen Gang wrote:
>>> If what you said is correct, could you help to send related patch for
>>> it? if I send this kind of patches, it will be easily redirected to
>>> "/dev/null".
>> 
>> Geert has explained the state of things quite nicely. Please send your patch to
>> introduce HAVE_xxx. I'm sure maintainers will respond to it as it is the correct
>> thing to do. But I don't want to add bloat to kernel for a random defconfig
>> failure which no one will really use for ARC.
>> 
>> If you think u can't/won't do it - let me know and I'll send the patches instead.
>> 
>
> Please help send.
> 
> Thanks. :-)
>

-- 
Chen Gang
