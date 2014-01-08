Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaAHQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:26:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbaAHQ0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:26:19 -0500
Date: Wed, 8 Jan 2014 17:26:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: input: fix input sysfs path for hid devices
In-Reply-To: <CANq1E4R4H5U6Hqv4ZWWj8cznf6gAbnScs9Cd61BGnH=Mtg1kpA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1401081724440.31628@pobox.suse.cz>
References: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com> <CANq1E4QrPAJ7zNdN51PGQD5tkD_gTYfRoHOg7=zwVvnu-xOR0g@mail.gmail.com> <alpine.LNX.2.00.1312202335300.11949@pobox.suse.cz>
 <CANq1E4R4H5U6Hqv4ZWWj8cznf6gAbnScs9Cd61BGnH=Mtg1kpA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, David Herrmann wrote:

> >> > I think this is valuable because it will give a better understanding of the
> >> > actual mapping hardware/inputs. Like a touchscreen with pen + touch will have
> >> > the same hid parent, and I expect X/Wayland to be able to detect this at some
> >> > point to keep the mapping correctly between the two input devices and the screen.
> >> >
> >> > I also need that for hid-replay, so that I can be sure which input is attached
> >> > to which uhid device, and give up the heuristics I currently use.
> >>
> >> I was just wondering where we have multiple HID devices on a single
> >> parent, but yeah, uhid is a good example. I actually have no
> >> objections to this patch and it looks fine. But I cannot tell whether
> >> anyone relies on this.
> >>
> >> I'd say we should give it a try.
> >
> > Agreed, let's take it for 3.14, and if anyone complains about breakage
> > caused by this (which I don't expect), we'll revert to the previous state.
> 
> You dropped the "Reviewed-by:" part in your commit-msg:
> http://git.kernel.org/cgit/linux/kernel/git/jikos/hid.git/commit/?h=for-next&id=bbe3175408cde792fbaa5bd1e41e430ea9e4fb4f
> 
> Not sure, whether you sometimes rebase your tree. If you do, you might
> wanna fix it, otherwise, I don't care. Just wanted to point it out.

Gah, sorry for that. No idea what in my process ate the tag.

I am really trying to make the tree non-rebasing. If you don't mind, I 
wouldn't take this as a reson to rebase.

I can put you twice to some patch later to balance this out :p

Thanks for understanding,

-- 
Jiri Kosina
SUSE Labs
