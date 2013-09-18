Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3IRDm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:42:56 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:40849 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3IRDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAF0htA5UCN=KOPXgX4Tq5S_7jUkkb_2yDbbLNBSkpHwmTZSeSA@mail.gmail.com>
References: <CAF0htA5QzKiodZyG-mE3mgMHHDkVDz=_D8oW3Gd03NEUrY67MA@mail.gmail.com>
	<20130916050659.GA26457@roeck-us.net>
	<CAF0htA5UCN=KOPXgX4Tq5S_7jUkkb_2yDbbLNBSkpHwmTZSeSA@mail.gmail.com>
Date: Wed, 18 Sep 2013 11:42:54 +0800
Message-ID: <CAF0htA4=+XSxpTumgWEmK8KXjY=+0eNBxkt8i0mi9gVkO56T7g@mail.gmail.com>
Subject: Re: [GIT PULL] S+core Architecture : fix bugs for compiling and
 support necessary functions
From: Lennox Wu <lennox.wu@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, liqin.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,
What does the "e-mail is not signed" mean? I try to search some
information, but I still do not understand what you say.

Best,
Lennox

2013/9/16 Lennox Wu <lennox.wu@gmail.com>:
> OK, thanks for your reminding, most the format is referenced from
> other git pull requests, however, I still miss something, I will fix
> them.
>
> How detailed content shold a summary have? I indeed have made some
> summary in the commits. Could you give me an example?
>
> About why I didn't send a copy to Linus. Because the document
> SubmittingPatches has no this rule. I indeed notice that  many git
> pull requests sent a copy to Linus, but I think I should follow the
> documented rule. If it is a new rule, thanks for telling me the rule
> ,and maybe the document should be added this rule.
> Adopt this rule...
> "
> 5) Select e-mail destination.
> Look through the MAINTAINERS file and the source code, and determine
> if your change applies to a specific subsystem of the kernel, with
> an assigned maintainer.  If so, e-mail that person.  The script
> scripts/get_maintainer.pl can be very useful at this step.
> If no maintainer is listed, or the maintainer does not respond, send
> your patch to the primary Linux kernel developer's mailing list,
> linux-kernel@vger.kernel.org.  Most kernel developers monitor this
> e-mail list, and can comment on your changes.
>
> Do not send more than 15 patches at once to the vger mailing lists!!!
>
> Linus Torvalds is the final arbiter of all changes accepted into the
> Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
> He gets a lot of e-mail, so typically you should do your best to -avoid-
> sending him e-mail.
> "
>
> Anyway, I appreciate your notifiction and I will fix this errors.
>
> Best,
> Lennox
>
>
> 2013/9/16 Guenter Roeck <linux@roeck-us.net>:
>> On Sat, Sep 14, 2013 at 05:42:07PM +0800, Lennox Wu wrote:
>>> Hi Linus,
>>> Please pull these updates for S+core architecture. These updates include
>>> updating information of maintainers, fix some trivial errors, and add
>>> a necessary function for supporting ipv6.
>>>
>>> The following changes since commit bdbdfdef5766c2a60185e946df242f1bc0d37c09
>>>
>>> Merge tag 'hwmon-for-linus' of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
>>> (Fri Sep 13 10:58:41 2013 -0700)
>>>
>>> on
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>
>>>
>>> For you to fetch changes up to 969f99168b9dff2f6cc07cdf14255178d4397c4f
>>>
>>> git@github.com:sctscore/official-linux.git tags/branch-linus-20130914
>>>
>>> Best,
>>> Lennox Wu
>>>
>> Your e-mail is not signed. You don't even have a pgp key as far as
>> I can see, at least not one associated with your e-mail address.
>> How do you expect anyone to establish your identity ?
>>
>> In addition to that, the tag in your repository is not signed and
>> does not contain a summary of your changes. Your patches do not
>> have a Signed-off-by: tag. The pull message below appears to be
>> hand-edited and does not match an auto-generated pull request
>> (which should have given you a hint that the commit logs have
>> a problem).
>>
>> You did not even copy Linus on this e-mail. Do you really think
>> he would even notice your pull request, much less apply it ?
>>
>> Guenter
>>
>>> -----------------------------------------------
>>> Summary these commits:
>>> 1. Fix some trivial errors for successfully compiling the latest
>>> version Linux kernel.
>>> 2. Provide necessary function for support IPV6.
>>> 3. Update the information of maintainers.
>>> ------------------------------------------------
>>> Lennox Wu (8):
>>> score : Update the information of Score maintainers
>>> score : Implement the function csum_ipv6_magic
>>> score : arch/score/kernel/entry.S: fix wrong instructions
>>> score : arch/score/kernel/process.c : fix some typos
>>> score : Modify the MAKEFILE of Score
>>>
>>>  MAINTAINERS                       |    4 +-
>>>  arch/score/Kconfig                |    4 ++
>>>  arch/score/Makefile               |    4 +-
>>>  arch/score/include/asm/checksum.h |   93 ++++++++++++++++++++-----------------
>>>  arch/score/include/asm/io.h       |    1 -
>>>  arch/score/include/asm/pgalloc.h  |    2 +-
>>>  arch/score/kernel/entry.S         |    4 +-
>>>  arch/score/kernel/process.c       |    4 +-
>>>  8 files changed, 64 insertions(+), 52 deletions(-)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
