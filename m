Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaLHNex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:34:53 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52166 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbaLHNev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:34:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141208141837.752a9968@frodo>
References: <20141208132720.16356743@frodo> <4066664.BgJJnCmQ3h@wuerfel> <20141208141837.752a9968@frodo>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 8 Dec 2014 13:34:20 +0000
Message-ID: <CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
Subject: Re: [PATCH] misc: ioc4: fix variable may be used uninitialized warning
To: Richard Leitner <dev@g0hl1n.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 1:18 PM, Richard Leitner <dev@g0hl1n.net> wrote:
> On Mon, 08 Dec 2014 13:42:47 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Monday 08 December 2014 13:27:20 Richard Leitner wrote:
>> >
>> > As far as I can tell 'start' cannot really be used uninitialized
>> > here, but for the sanity of gcc output explicitly initialize it.
>> > Same goes for the 'end' variable.
>>
>> Prabhakar Lad also sent a patch for this already, which was lacking
>> a good patch description. Your patch does this slightly better but
>> still fails to explain how you concluded it was safe and you don't
>> really explain why you initialize the 'end' variable that we don't
>> even get a warning about.
>
> Oops, I'm sorry, I haven't seen the patch and the answers to it.
>
> According to the comments by Andrew a simplification of this code
> section would be nice. I think it should be possible to do this in a
> way that the initialize-to-zero won't be needed anymore.
>
> Prabhakar Lad, are you working on this already?
> If not I'll take a look at it.
>
Definitely you can go ahead, I am busy with other stuff.

Thanks,
--Prabhakar Lad
