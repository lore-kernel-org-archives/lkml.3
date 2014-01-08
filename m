Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaAHQql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:46:41 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55054 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaAHQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:46:37 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1401081724440.31628@pobox.suse.cz>
References: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4QrPAJ7zNdN51PGQD5tkD_gTYfRoHOg7=zwVvnu-xOR0g@mail.gmail.com>
	<alpine.LNX.2.00.1312202335300.11949@pobox.suse.cz>
	<CANq1E4R4H5U6Hqv4ZWWj8cznf6gAbnScs9Cd61BGnH=Mtg1kpA@mail.gmail.com>
	<alpine.LNX.2.00.1401081724440.31628@pobox.suse.cz>
Date: Wed, 8 Jan 2014 17:46:36 +0100
Message-ID: <CANq1E4TAa=e0PCGdxp-dP7bG3zt42xMzcAJ=hUW1800=LocSSg@mail.gmail.com>
Subject: Re: [PATCH] HID: input: fix input sysfs path for hid devices
From: David Herrmann <dh.herrmann@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Jan 8, 2014 at 5:26 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 8 Jan 2014, David Herrmann wrote:
>
>> >> > I think this is valuable because it will give a better understanding of the
>> >> > actual mapping hardware/inputs. Like a touchscreen with pen + touch will have
>> >> > the same hid parent, and I expect X/Wayland to be able to detect this at some
>> >> > point to keep the mapping correctly between the two input devices and the screen.
>> >> >
>> >> > I also need that for hid-replay, so that I can be sure which input is attached
>> >> > to which uhid device, and give up the heuristics I currently use.
>> >>
>> >> I was just wondering where we have multiple HID devices on a single
>> >> parent, but yeah, uhid is a good example. I actually have no
>> >> objections to this patch and it looks fine. But I cannot tell whether
>> >> anyone relies on this.
>> >>
>> >> I'd say we should give it a try.
>> >
>> > Agreed, let's take it for 3.14, and if anyone complains about breakage
>> > caused by this (which I don't expect), we'll revert to the previous state.
>>
>> You dropped the "Reviewed-by:" part in your commit-msg:
>> http://git.kernel.org/cgit/linux/kernel/git/jikos/hid.git/commit/?h=for-next&id=bbe3175408cde792fbaa5bd1e41e430ea9e4fb4f
>>
>> Not sure, whether you sometimes rebase your tree. If you do, you might
>> wanna fix it, otherwise, I don't care. Just wanted to point it out.
>
> Gah, sorry for that. No idea what in my process ate the tag.
>
> I am really trying to make the tree non-rebasing. If you don't mind, I
> wouldn't take this as a reson to rebase.
>
> I can put you twice to some patch later to balance this out :p
>
> Thanks for understanding,

Haha, don't worry, just saw it during post-review and wanted to let you know.

Cheers
David
