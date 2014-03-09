Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaCIFdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:33:41 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:52350 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaCIFdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <1394312534.2040.18.camel@x220>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
	<CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
	<1394308828.431.5.camel@x220>
	<CAF0htA7TeuKjQzU9EE5_RWUkznf+Xp=CsGd=TA6qB0COQxUYQg@mail.gmail.com>
	<1394312534.2040.18.camel@x220>
Date: Sun, 9 Mar 2014 13:33:37 +0800
Message-ID: <CAF0htA6qmNaqCpHLu4patPhDzBwgD9OLssVRE=8K=R_UvtjGBQ@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig parameter
From: Lennox Wu <lennox.wu@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, people I don't want to brother are guys intergrate all
patches on the maillist.
There are too many patches whaic are waiting they to process.
I will check the development progress of the another Score and
consider if we should remove the config.
Thanks for your suggestion.

Best,
Lennox

2014-03-09 5:02 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
> On Sun, 2014-03-09 at 04:27 +0800, Lennox Wu wrote:
>> 2014-03-09 4:00 GMT+08:00 Paul Bolle <pebolle@tiscali.nl>:
>> > In https://lkml.org/lkml/2011/11/12/76 I already reported that this
>> > Kconfig symbol was unused. Why can't it be dropped and re-added when
>> > code is added to the tree that actually uses it?
>>
>> Because I don't think droping it is meaningful, since it will be used.
>
> But, again, it isn't used now and hasn't actually been used in years.
>
>> Moreover, the symbol never affect other architectures or subsystems.
>> I feel that is not good to brother people to process the unimportant patch.
>
> Sure, this is just a small cleanup. But the scripts people use to see
> whether more serious Kconfig related issues have entered the tree will
> likely notice CPU_SCORE7. (And those people will have to investigate why
> that symbol is unused - which might take quite a bit of work - to
> determine what needs to be done about it.) So whenever someone, not
> following this thread, runs a script like that the score maintainers
> might receive a similar patch again.
>
> And I don't believe that handling a single cleanup patch is particularly
> burdensome for the score maintainers.
>
>
> Paul Bolle
>
