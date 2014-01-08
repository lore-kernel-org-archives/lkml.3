Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaAHRbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:31:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51466 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaAHRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140108172240.GD14575@lee--X1>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<20140107090938.GF3182@lee--X1>
	<CAOMwXhMqwC9zx6GKY+QXzy7s+u4ZapyPyLBz-ANgS8qMTDNyhg@mail.gmail.com>
	<CAOMwXhN7JzCZZVtNTHPAhrdFkM4z10J634ctBPR2u+tRUOtSqw@mail.gmail.com>
	<20140108172240.GD14575@lee--X1>
Date: Wed, 8 Jan 2014 17:31:45 +0000
X-Google-Sender-Auth: XwdOCZY7yTyhN7x_tb6moULKw8o
Message-ID: <CAOMwXhMVkk5Lbuh6EHtmUqm3QCNbqRbHRPf5RKEQcWuTM7ScOg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add GPIO support for the MAX6650/6651 ICs
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 5:22 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Wed, 08 Jan 2014, Laszlo Papp wrote:
>
>> In other words, I really do not know what format you prefer for design review.
>>
>> Apparently, not as previously requested, so please tell me what format
>> one _should_ submit design reviews in.
>>
>> I personally still think that submitting "pseudo-code" is a good way
>> of it if it is clearly marked so like in my case, so that it does not
>> mislead anyone that I accidentally submit a clearly broken change for
>> an integration candidate.
>>
>> I hope it is understood that I am asking about design reviews before
>> the lengthy implementation to potentially avoid a lot of additional
>> work on both sides with writing and reviewing an implementation with a
>> "wrong" approach...
>
> The correct way to do this is to submit RFC patches. If you start your
> $SUBJECT line with [PATCH RFC x/x], then we know that they're
> development patches and we can treat them as such.
>
> If you're submitting code, in form, which are you in this case, they
> should still abide by the submission rules. I you'd like us to review
> them, then they need to be in an easy to read format. Submitting
> patches with lots of whitespace variation is off-putting and hard to
> review. If you want people to put aside their time to help you, then
> the least you can do is make it easy for them to read. Conforming to
> the 3 documentation files (I know how much you love documentation)
> will ensure you're giving yourself a snowball's chance in Hell of
> 'winning' the response you desire.
>
> All this toing and froing is wasting everyone's time. Just submit
> nice patches for us to review and you will receive the help you
> crave.

Please let me know an automatized way for fixing up style issues for
the kernel. Should I use a separate editor profile for Linux kernel
development? What is the best practice out there?

I can say that from practice that Lindent and others things made the
code even messier than it had been. It is not as simple as you may
think for a newcomer than me. I would rather _not_ spend time with
stylistic issues when the main point is clearly not styling, but
design review.

My conclusion from your email is that, I will not submit code then
because it is just a waste of time for design discussion unless there
is a simple and automated way of taking care of the style stuff.

Cheers again ...
