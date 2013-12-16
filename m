Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3LPQjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:39:55 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37822 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131216150514.GN18769@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
	<20131216082556.GE18769@lee--X1>
	<CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
	<20131216150514.GN18769@lee--X1>
Date: Mon, 16 Dec 2013 16:39:52 +0000
X-Google-Sender-Auth: nkzAGTMieBjZGUd7mqtoDzOl5Ac
Message-ID: <CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
Subject: Re: Simple MFD driver example
From: Laszlo Papp <lpapp@kde.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 3:05 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Please refrain from top posting.
>
> Responses should appear under quoted lines, which they reference.

I intentionally did not reply to a specific quote, but to the email as a whole!

>> >> I have been trying to write about 50-100 LOC for 1-2 weeks now. I have
>> >> a fairly simple use case for MFD where I need to have gpio and hwmon
>> >> functionality for a GPIO.
>> >>
>> >> I read the mfd drivers inside and out by now, but it looks a bit
>> >> inconsistent to me. I am not sure what to follow etc. The
>> >> documentation seems to be virtually missing which makes my life and
>> >> involvement even more difficult. :(
>> >>
>> >> May I ask for some pointer how to do all this? It would be nice to see
>> >> a minimal example where the parent does not do anything else than just
>> >> enumerating the sub-device drivers. Is that possible with an empty
>> >> probe callback?
>> >>
>> >> If I understand the regmap correctly (again, it is possible I do not),
>> >> then I would not need this. But in general, it is really hard to deal
>> >> with the linux kernel in this regard when basic documentations are
>> >> missing.
>> >>
>> >> I hope this would change over time for the posterity. It is a pity
>> >> that contributors do not join probably due to this. It is a bit
>> >> chaotic, but I hope it can be changed in the future.
>> >>
>> >> Apologies for my frustration...
>> >
>> > Due to the nature of the MFD subsystem, there isn't a simple use-case
>> > which you can use as a template. It's completely dependent on the
>> > device you are trying to enable. There are lots of well written
>> > drivers in the subsystem that you can use as good examples though.
>
>> Well, if you ask me the MFD subsystem is underdocumented, and there is
>> some inconsistency between the drivers. It is hard to take any of them
>> as a starting point, at least for me.
>
> Feel free to write some. I'm always happy to take helpful patches.

I am not the right person for documentating everything here,
especially when I do not even understand basics... I am just trying to
figure out my way here. It was more like a hint that this area could
take some love. At least, I would personally appreciate it a lot. It
is currently somewhat difficult to get involved.
