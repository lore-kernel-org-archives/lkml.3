Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaIXSHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:07:40 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:39767 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140924165739.GA31578@roeck-us.net>
References: <cover.1409161615.git.andreas.werner@men.de> <20140924144829.GK32069@lee--X1>
 <20140924154503.GA12403@roeck-us.net> <20140924161837.GA7113@lee--X1>
 <CAK5ve-+79oMf0vD-_gzWLPbvFi4ygd1q9pzTCHzzpsXVkjqP9Q@mail.gmail.com> <20140924165739.GA31578@roeck-us.net>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 24 Sep 2014 11:07:15 -0700
Message-ID: <CAK5ve-Jm0xv3eL5y8WHsfchnpDyJYw9BiyW49mrMyN-y+g0maA@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Introduce MEN 14F021P00 BMC driver series
To: Guenter Roeck <linux@roeck-us.net>
Cc: Lee Jones <lee.jones@linaro.org>, Andreas Werner <andreas.werner@men.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:57 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Wed, Sep 24, 2014 at 09:33:32AM -0700, Bryan Wu wrote:
>> On Wed, Sep 24, 2014 at 9:18 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > On Wed, 24 Sep 2014, Guenter Roeck wrote:
>> >
>> >> On Wed, Sep 24, 2014 at 03:48:29PM +0100, Lee Jones wrote:
>> >> > Guenter, Bryan, Wim,
>> >> >
>> >> > The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:
>> >> >
>> >> >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
>> >> >
>> >> > are available in the git repository at:
>> >> >
>> >> >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-hwmon-leds-watchdog-v3.18
>> >> >
>> >> > for you to fetch changes up to 964356938fcd3c0001a786f55b9f0a0fbe47656a:
>> >> >
>> >> >   hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver (2014-09-24 15:36:33 +0100)
>> >> >
>> >> > ----------------------------------------------------------------
>> >> > Immutable branch between MFD, HWMON, LEDs and Watchdog for v3.18
>> >> >
>> >> I assume you'll push it all through mfd, correct ?
>> >
>> > The idea is for all the affected Maintainers to pull this branch in to
>> > their own trees.  If you guys don't, there will be a good chance of
>> > conflict during the merge-window, which will subsequently upset Linus.
>> >
>> > So in answer to your question; yes I'll be taking this, but so should
>> > each of you.
>> >
>>
>> Thanks for this, man. What am I going to do here? Need I pull in all
>> the patches here into my LED tree or just one LED patch? I think if
>> you push this for Linus through MFD tree, I don't need to pull it into
>> my tree, right?
>>
> I did
>
> git remote add mfd git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
> git fetch --tags mfd
> git merge mfd-hwmon-leds-watchdog-v3.18
>
> in both my hwmon-next and watchdog-next branches. Both are currently building,
> and already pushed into to my repository at kernel.org.
>
> So, effectively, when I send my pull request to Linus, all patches from
> mfd-hwmon-leds-watchdog-v3.18 will be included, ie the entire series.
> The same will happen when Lee sends his pull request, and Wim, and you.
> I believe that is what Lee is asking for.
>

Great, thanks a lot. I just did the same thing for my leds tree.

-Bryan
