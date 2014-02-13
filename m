Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaBMNTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:19:12 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40662 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaBMNTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:19:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140213135731.139b23aa@endymion.delvare>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
	<20140213095817.GD32508@lee--X1>
	<20140213111530.2a2b4982@endymion.delvare>
	<CAOMwXhML8LvDCzmk1ZVT+7cARj9C3VtxERWBgOPM9vTc6qQXZQ@mail.gmail.com>
	<CAOMwXhOv-as1W69wcSno49jEXsXWZZ7odnu8og-vgnDwRTJ4sA@mail.gmail.com>
	<20140213113313.GL32508@lee--X1>
	<CAOMwXhMNHqXnzR0YHF9rx710JbaL3YFn=3cLf_WdNkCx7hbZug@mail.gmail.com>
	<20140213135731.139b23aa@endymion.delvare>
Date: Thu, 13 Feb 2014 13:19:09 +0000
X-Google-Sender-Auth: L4-5zTwWym9JwrZx4FrGlhNUl7g
Message-ID: <CAOMwXhNdua==HtUGXYsciA4rOb-Z5Jd8zKudwMic8d6sgKb7jg@mail.gmail.com>
Subject: Re: [lm-sensors] [RFC PATCH] hwmon: (max6650) Convert to be a
 platform driver
From: Laszlo Papp <lpapp@kde.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:57 PM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Laszlo,
>
> On Thu, 13 Feb 2014 12:27:28 +0000, Laszlo Papp wrote:
>> On Thu, Feb 13, 2014 at 11:33 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > Right, I've had enough. I'm removing your patch from the MFD tree.
>> >
>> > I've asked too many people to give you a second chance and asked you
>> > privately to behave yourself and treat others with respect. So far I
>> > haven't seen an ounce of self control or depomacy from you.
>> >
>> > This is how it's going to work from now on:
>> >
>> >  - You submit a patch
>> >  - It gets reviewed                            <----\
>> >  - You fix up the review comments as requested -----/
>> >  - Non-compliance or arguments with the _experts_ results in:
>> >     `$INTEREST > /dev/null || \
>> >       grep "From: Laszio Papp" ~/.mail | xargs rm -rf`
>>
>> http://comments.gmane.org/gmane.linux.kernel/1645251
>>
>> Step 2 did not happen. I did not get any review for my change. I
>> literally submitted that within a couple of hours after the request.
>
> Yes, twice even, and broken each time. And without a changelog on v2
> (despite Documentation/SubmittingPatches explaining this is a good
> practice - see section 15.)
>
>> Could you please tell me what was wrong with that change, and why I
>> did not get any respect not to "xargs rm -rf" my work in that area? I
>> believe I was ignored instead of improving the change, and someone
>> else tried to address the same thing. There was no argument in that
>> thread. It was a technical change. I personally do not feel happy
>> about it.
>
> The change itself was so wrong that I don't even know where to start.
>
> But the main problem really was you. You had pissed me (and I suspect,
> everybody else) off so much that day that I really didn't want to deal
> with your rants or code any longer. As you can imagine, I have more
> than enough on my plate, so I just moved on to another task.
>
> Then by the time I may have been willing to give you another chance and
> review your code, Guenter wrote a more complete, better patch set. So I
> thought I'd just review that one. And it was good, and it took me less
> time to review and test it than to (attempt to) teach you how to behave.
>
> Working with Guenter is a pleasure. Working with you is a pain, really.
> And guess what, I get to choose who I'm working with.
>
> If people no longer want to work with you, well, blame it on yourself.

I think the question was more addressed to Guenter because he did not
try to help me to get involved with that patch. I did not mean to say
that I would have expected reviews within a week, but I would have
hoped for being more inclusive, i.e. trying to tell me what I am
doing, why, even if it is clearly broken. Please forgive me my
technical shortcoming. I am sure this would improve over time, just
like for anyone else here.

Currently, I am not there mentally to submit the patch set requested
by Lee because this situation is making me being afraid of a newbie
and submitting patches with issues. An expert may just come and
rewrite it, and then my effort is going again to "/dev/null". I guess
I will need some time and break to get over this...

That being said, I hope I will come back with peace of mind after the break.

PS.: I have submitted a patch set in December by the way, and got no
review from the hwmon maintainers for the hwmon parts. That patch is
still valid, and review would still be very welcome. The current
submission is pretty much just a direct port of it on top of the
latest mfd and upstream changes.
