Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3HJUDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:03:50 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58325 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3HJUDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAPBO7TYBWg-vyX3YocGZ94ALbiZC7E-1TWr5zndPob_xyPvqTQ@mail.gmail.com>
References: <52062353.9030800@rus.uni-stuttgart.de>
	<Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
	<CAPBO7Tbi0mjPOs7migmvm9TUyezsMfxpFrGxZMPodd2hvbXY5A@mail.gmail.com>
	<520699F2.7080808@rus.uni-stuttgart.de>
	<CAPBO7TYBWg-vyX3YocGZ94ALbiZC7E-1TWr5zndPob_xyPvqTQ@mail.gmail.com>
Date: Sat, 10 Aug 2013 22:03:48 +0200
Message-ID: <CAPBO7TautgVCT3UUq=N43=zVi0cYTwY9-3_ecW8c-oeNyh1+pw@mail.gmail.com>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
From: Josep Lladonosa <jlladono@gmail.com>
To: Thomas Richter <richter@rus.uni-stuttgart.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 21:58, Josep Lladonosa <jlladono@gmail.com> wrote:
> On 10 August 2013 21:52, Thomas Richter <richter@rus.uni-stuttgart.de> wrote:
>> Hi Josep,
>>
>>
>>> Have you tried to wait for 5 minutes? It could also be related to it
>>> what happens to my kernel 3.11.0-rc4 (and rc3) and USB
>>>
>>> I plug the drive. Only after 5 minutes of high-speed of USb bus, it
>>> mounts.

I add that some usb pendrives mount immediately and some others don't...


>>
>>
>> No, currently I don't even depend on gnome mounting it. I don't run a
>> desktop. I just mount it manually in the single user mode with "mount"
>> (eliminates variables that is). If I mount it, it first looks ok. Then I
>> write a file on it. Still looks ok. Then I call "sync". That finally locks
>> it up with the 2.6.32 kernel, not on 2.6.31. For the .32, it just sits
>> there, after probably twenty seconds, it times out, complains that it can't
>> write, then dies away. Works just nicely with the .31 kernel.
>>
>
> Perhaps both cases are related, and if you waited after those 5
> minutes of resets, your pen would work fine...
> Have you checked your /var/log/messages after insertion of pen?
>
> My automount is under XFCE, not Gnome... ;)
>
> Josep
>
>
>> Thus, at this time, I guess I would need to know more about how a write
>> reaches the ehci module, and how the configuration from there works.
>>
>> Sorry, but this isn't quite as simple as I thought.
>>
>> Thanks,
>>         Thomas
>
>
>
> --
> --
> Salutacions...Josep
> --



-- 
--
Salutacions...Josep
--
