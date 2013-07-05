Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3GEIDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 04:03:17 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55094 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3GEIDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 04:03:12 -0400
Message-ID: <51D67D6C.4080603@gmail.com>
Date: Fri, 05 Jul 2013 16:01:48 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>, Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
References: <20130704011221.GA11230@kroah.com> <20130704061204.GA12148@kroah.com> <51D517A7.6030908@asianux.com> <201307041125.15083.arnd@arndb.de> <51D60D53.7050405@gmail.com> <20130705101446.48deb2694f5fcdb060f41e5b@canb.auug.org.au> <51D617E9.8080907@gmail.com>
In-Reply-To: <51D617E9.8080907@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All:

It seems 'asm-generic' dislikes 'mad users' (e.g allmodconfig,
randconfig, and me).

I guess the main reason is: 'asm-generic' thinks what mad users talk
about is useless in real world, so it is just noisy.

I can understand, at least what I talk about is not for urgent things.
(maybe 'asm-generic' also thinks it not important either, every members
have their own opinions).

Next, I still use allmodconfig/randconfig for some architectures which I
am interested in (and also for learning compilers), but I will skip all
things which are related with 'asm-generic', since it dislikes me (a mad
user).

At last, I make an apologize to 'asm-generic' for my mad discussing.

Bye !!


On 07/05/2013 08:48 AM, Chen Gang F T wrote:
> On 07/05/2013 08:14 AM, Stephen Rothwell wrote:
>> On Fri, 05 Jul 2013 08:03:31 +0800 Chen Gang F T <chen.gang.flying.transformer@gmail.com> wrote:
>>>>
>>>> When a module select "COMPILE_TEST=y" (e.g with allmodconfig), it has
>>>> right to compile under the architecture which no related HW support.
>>>>
>>>> If it can not pass compiling, at least it is not the module's issue,
>>>> neither the architecture's issue.
>>>>
>>>> We have to look for who has duty on it. At least now, it seems only
>>>> 'asm-generic' can be qualified to play this unlucky role.
>> You keep saying this, but others have told you that this is not the
>> problem.
>>
> 
> In real world, it is not the problem.
> 
> But for 'mad users' (e.g. allmodconfig, randconfig, and me too), they
> have not provided enough reason for it (prove that is not a problem for
> 'mad users').
> 
> 
>>>> Could you provide your suggestions or completions for this issue ?
>> If something doesn't build for a particular config, then either it needs
>> to be fixed or excluded from building in that particular config.
> 
> I agree with you, if get rid of 'COMPILE_TEST'.
> 
> Thanks.
> 


-- 
Chen Gang
