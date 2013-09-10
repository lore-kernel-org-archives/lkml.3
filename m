Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3IJAG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:06:56 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43852 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3IJAGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:06:55 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 0/3] ARM: SoC: Second round of changes for v3.12
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
	<CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
Date: Mon, 09 Sep 2013 17:06:51 -0700
In-Reply-To: <CA+55aFxNbH+G6DVQNxE9di_btA5hxFH93af_vjN2v0eH8e5W-g@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 9 Sep 2013 16:49:23 -0700")
Message-ID: <87ioy97d5w.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Sep 9, 2013 at 3:42 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>
>> The main thing of note (or of potential annoyance factor) here is the
>> handful of conflicts in PULL 2/3 coming from platform changes
>> conflicting with driver changes going in to the V4L tree.  I've listed
>> them in detail in that pull request, and we will work with the
>> platform maintainer on the workflow to avoid this in the future.
>
> Ok. I still really despise the absolute incredible sh*t that is
> non-discoverable buses, and I hope that ARM SoC hardware designers all
> die in some incredibly painful accident.  DT only does so much.

In case it helps you feel slightly better... in what some might call a
painful accident (though probably not the kind you'd like to see), most
of the designers I used to work with (at TI) were laid off in the last
year.

> So if you see any, send them my love, and possibly puncture the
> brake-lines on their car and put a little surprise in their coffee,
> ok?

Got it.  I'll be sure to send your love.

>> For future reference, when it comes to these conflicts, do you want to
>> see a summary of the suggested resolutions, a published branch with
>> the resolutions, both or neither?  Just curious.
>
> I'll basically always end up re-doing the conflict resolution by hand
> anyway unless it's just *incredibly* messy (and I think that has
> happened all of once or twice), so anything you send me ends up being
> just confirmation.
>
> In this case, for example, I didn't end up looking at your pre-merged
> stuff, because the summaries were enough for me to just say "ok, that
> confirms my resolution". In other cases, people don't write detailed
> summaries, and I end up confirming my resolution by just doing a
> separate test-merge against their pre-merged branch and comparing.
>
> And in most cases, the resolution is trivial enough that I don't
> bother with either.
>
> And in *all* cases I appreciate it when people do the preparation. It
> hopefully also makes submaintainers themselves more aware of
> development flow conflicts and more aware of possible problem issues
> (same reason I prefer doing all the resolutions by hand myself), so I
> suspect all of this is healthy even if I don't end up using it.

OK, thanks for the feedback.

> Final note: putting the conflict resolution explanation in the tag
> message is unnecessary, since it's not really worth it after-the-fact
> - so I'll just edit it away. It's not a problem, but in general I'd
> suggest the tag message just contain the "here's the highlights", and
> you do the conflict resolution notes just in the email. But I suspect
> you may find the use of the tags a convenient way to jot down the
> resolution for then sending the email later, and it's not like it
> hurts me to edit it away afterwards, so not a big deal. Whatever works
> for you.

Noted, thanks.

Kevin
