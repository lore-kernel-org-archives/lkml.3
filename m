Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab3DEKaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:30:09 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53913 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3DEKaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=wNHsV0vFhcTWg0g7=Wtbdx=g2wqpNPfidQfGhhK9Cig@mail.gmail.com>
References: <03ca6f17860d290cfc67e51969062612f0ab26ab.1364643234.git.viresh.kumar@linaro.org>
	<2835305.o7Hvg1cesG@vostro.rjw.lan>
	<CAKohpo=vorTDONBR2czcZpP64sCfv1Qa-u8zGkHys9miwQrURw@mail.gmail.com>
	<6766028.RBJyPM3lJj@vostro.rjw.lan>
	<CAKohpo=wNHsV0vFhcTWg0g7=Wtbdx=g2wqpNPfidQfGhhK9Cig@mail.gmail.com>
Date: Fri, 5 Apr 2013 16:00:04 +0530
Message-ID: <CAKohpo=jUOciKCAWWJ_bC-uSKzdk4a49r39gaOsuroVbqSRyFg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Raname index as data in cpufreq_frequency_table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Sekhar Nori <nsekhar@ti.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2013 09:16, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 31 March 2013 07:16, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Sunday, March 31, 2013 07:03:04 AM Viresh Kumar wrote:
>>> On 31 March 2013 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > Sorry, I won't apply this.  It changes too much stuff at a time and I'm not
>>> > really sure if the change being made is necessary.
>>>
>>> Hmm.. I thought it is important  as it puts the real meaning of "index" in the
>>> code.
>>
>> And what does that change, really?  What about documenting the meaning of
>> "index" instead?
>
> Probably not the logic but perception. People don't necessarily go through
> Documentation but code for writing new stuff. And so code should reflect the
> real meaning.
>
> In case we write something like following in documentation:
> "Index: This is driver specific data for each frequency. Core doesn't use it."
>
> Then "Index" looks even more wrong. Its not the right name for any such
> variable. And so it should be fixed.

Forgot reply to all earlier :(

You have any more comments on this patch? I really thought this change
would be good. I agree it touches lot of stuff but for clean/clear code.

--
viresh
