Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaHEW66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:58:58 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34207 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaHEW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <53E04DF3.40604@roeck-us.net>
References: <20140805022209.GA13813@roeck-us.net>
	<20140805131447.5cec84e5@canb.auug.org.au>
	<53E04DF3.40604@roeck-us.net>
Date: Tue, 5 Aug 2014 15:58:56 -0700
X-Google-Sender-Auth: -QLguOqlN0W3JkTuOxQjDgTawKU
Message-ID: <CA+55aFx26rhMq_y0wuBrGi+QhFH0Odtg2eof-r_J6L46opsrjA@mail.gmail.com>
Subject: Re: [GIT PULL] hwmon updates for 3.17
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 8:22 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> This branch was rewritten (but not rebased) to add 5 commits at its
>> start and 8 commits at its end since yesterday's linux-next.
>
> Yes, the start because I missed to send a bunch of fixes to Linus last week
> because I was on vacation
> and merged it all together, and the end because I missed to push out a bunch
> of patches for the same
> reason. Everything did pass my test suite, though.
>
> If that is a problem, let me know.

Please, next time, just send me *two* pull requests - one with the
missed fixes, and one with the linux-next work. No point in rewriting
the series so that all the commits are now different from the ones in
linux-next.

I've pulled it, but why rewrite history and mess up the next statistics?

             Linus
