Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab3ICDxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:53:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49633 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3ICDx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:53:28 -0400
Message-ID: <52255CF1.6020700@gmail.com>
Date: Tue, 03 Sep 2013 11:52:17 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        netdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>,
        "David S. Miller" <davem@davemloft.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 0/8] Drop support for Renesas H8/300 architecture
References: <1377906694-9578-1-git-send-email-linux@roeck-us.net> <52254F11.8070601@gmail.com> <522556D8.803@roeck-us.net>
In-Reply-To: <522556D8.803@roeck-us.net>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 11:26 AM, Guenter Roeck wrote:
> On 09/02/2013 07:53 PM, Chen Gang F T wrote:
>> Hello Guenter Roeck:
>>
>>
>> I don't care about whether I am in cc mailing list, but at least,
>> please help confirm 2 things:
>>
>>    Is what I had done for h8300 just making wastes and noisy in kernel and related sub-system mailing list ?
>>
>>    and is the disccusion about h8300 between us also wastes and noisy in kernel mailing list ?
>>
> 
> It raised my awareness of the status of h8300 maintenance,
> so I would not see it as noise or waste. I might have suggested
> a different target for your efforts, but that is your choice to make,
> not mine.
> 

OK, thank you for your confirmation, I plan to scan all architectures
one by one with allmodconfig.

Hmm... if suitable, next, when I focus one of architectures, I also cc
to you, if it can be removed, please let me know in time, so can avoid
sending waste mails to mailing list.

I plan to try one of architectures within arc, hexagon, and metag. I
will begin at 2013-09-20 (or later), if some (or all) of them can be
removed, please let me know, thanks.


> On the code review side, I had suggested that you should not add new
> ifdefs into code, much less unnecessary ones. Your counter-argument
> was that you wanted to follow the existing coding style in the file
> in question. To me, that argument is along the line of "the coding
> style in this file is bad, let's do more of it".

Hmm... in fact, I will not say whether the code style is good or bad. I
mainly focus on to try to avoid multiple code styles within one file.

  extreme sample: let 'kernel code style' and 'gcc code style' in one file, that will make the code very ugly.

> That doesn't make much sense to me, so I did not bother to respond.
> Setting that aside, it is not up to me to approve or reject your patches.
> Whoever does that would be the one you have to convince.
> 

OK, I can understand, and now it seems it can be canceled, since h8300
has been removed.

> Guenter
> 


Thanks.
-- 
Chen Gang
