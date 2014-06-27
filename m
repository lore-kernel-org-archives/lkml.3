Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaF0PUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:20:04 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:41152 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaF0PT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140627081640.GC19645@lee--X1>
References: <1402953143-24681-1-git-send-email-dianders@chromium.org>
	<20140618092012.GF23945@lee--X1>
	<CAD=FV=UiA=bsvune6A=wq+zKFq1+pkem0gTa-utxmBB6tKYM=A@mail.gmail.com>
	<20140623092650.GE8847@lee--X1>
	<CAOesGMj5+28u-sVithbOg-=SXeanje9jO8H=mzgp5AEA8kCABQ@mail.gmail.com>
	<20140627081640.GC19645@lee--X1>
Date: Fri, 27 Jun 2014 08:19:58 -0700
X-Google-Sender-Auth: 3ARB2QJouwFADx32HRASugq9vCA
Message-ID: <CAD=FV=V70qpri9HJ-y2dREr9rqtd1U9Jv-p8-MxOWcKHz1OqoA@mail.gmail.com>
Subject: Re: [PATCH] mfd: cros_ec_spi: set wakeup capability
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Fri, Jun 27, 2014 at 1:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> It's great to see this on the list, because I find your workflow as a
>> maintainer to be hard to follow as a developer.
>>
>> You applying patches but taking several days to push out makes it
>> completely opaque for someone to know if you just accidentally missed
>> to apply the patch after all (it happens, I've done that myself). It's
>> pretty common to expect a "thanks, applied" patch to show up in
>> linux-next within one day or so depending on timing.
>>
>> The fact that you had already pushed out a patch that you had replied
>> to even later makes for extra confusion. So I'm sorry Lee, but I don't
>> think Doug was unreasonable in asking for status here. Sometimes
>> maintainers forget to push, which is why it's a good idea to ping a
>> few days later if the patch hasn't showed up in -next.
>
> I completely understand and even empathise with the predicament of a
> diligent developer.  What you see above isn't me being cantankerous,
> but rather an explanation how things are handed in the MFD tree.

Yup, it's reasonable.  I will say that when I first read your response
it felt a little bit like you were lecturing me, which I didn't feel
like I deserved.  ...but I also know how easy it is to misconstrue
things over email and how hard it is to convey just the right tone
when there are so many emails and so much to do.

As I said in my earlier response I think that perhaps changing the
wording just a little from "Applied, thanks" would have made me wait
longer before querying.


> Taking into consideration my current workload and time constraints,
> the work-flow used is the best I can muster currently.  Lest we forget,
> this isn't the role for what I'm employed, I do this on-top of my
> daily tasks using time accumulated by starting early and finishing
> late _every day_.
>
> Building, testing and pushing after every patch, hell even on a daily
> basis would be difficult to sustain without it impacting my _proper_
> work.  What I need to do is write some more scripts which will help to
> relieve some of the burden, but again time is notable factor here.
>
> From a personal point of view, I prefer to be on top of the patches
> as they come in and have some lead time from when they are applied
> locally to finding their way into -next (bearing in mind that this
> lead time is seldom more than 24-48hrs), rather than do what others do
> and leave patches hanging on the list for weeks, then gather enough
> time to review, collect, test and push all in one session.
>
> A quick aside; given the state of maintainership in some of the other
> subsystems, I'm surprised that we're even having this conversation
> considering how responsive we are in MFD.

Just a quick note that I am certainly very appreciative of your
responsiveness to patches.  It is very rare that a MFD patch sits
around stagnating on the list without a review and that most
definitely helps with efficiency.  It also helps keep developers like
me motivated.  There's nothing more discouraging than spending a whole
bunch of time on the patch only to have it met with absolute silence.

-Doug
