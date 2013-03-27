Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3C0PlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:41:05 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43737 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3C0PlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:41:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130327143447.GB1771@quack.suse.cz>
References: <514EC323.7050002@gmail.com>
	<20130326211520.GF2082@quack.suse.cz>
	<CANGUGtD9BNQO9pvO+yeKHc0qojk61fKYDgKm8kfWzu8pCk=YJw@mail.gmail.com>
	<20130327143447.GB1771@quack.suse.cz>
Date: Wed, 27 Mar 2013 16:41:02 +0100
Message-ID: <CANGUGtDdhbS-7GJ4HDRTN3H-bHvNLGg6tdNsqgZbMGBCxmjjcw@mail.gmail.com>
Subject: Re: [RFC] fsfreeze: moving from uniterruptible to killable
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/27 Jan Kara <jack@suse.cz>:
> On Wed 27-03-13 12:39:10, Marco Stornelli wrote:
>> 2013/3/26 Jan Kara <jack@suse.cz>:
>> > On Sun 24-03-13 10:10:59, Marco Stornelli wrote:
>> >> When a fs is frozen, a process can hang because we wait in
>> >> uniterruptible state. We give the user the possibility to kill the process.
>> >   Yes, but it needs slightly more work as you probably know... (bailing out
>> > properly when the signal arrives).
>> >
>> >                                                                 Honza
>> >
>>
>> Of course, indeed, it was only an RFC to start a discussion, not a
>> patch :) The point was: is this kind of change a behaviour that can
>> break user-space in some way? IMHO no, but I'd like to have a
>> discussion about that before to start coding. What do you think?
>   Killable wait is almost always safe WRT to userspace breakage. In this
> case I cannot see how it could matter. That's why I agree it's a good thing
> to do.
>
>                                                                 Honza

Yes, I quite agree. I'll try to look at it in a deeply way.

Regards,

Marco
