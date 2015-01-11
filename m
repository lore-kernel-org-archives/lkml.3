Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbbAKVFC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:05:02 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62754 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAKVE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:04:56 -0500
MIME-Version: 1.0
In-Reply-To: <s5h8uh94nce.wl-tiwai@suse.de>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
	<s5h8uh94nce.wl-tiwai@suse.de>
Date: Sun, 11 Jan 2015 15:04:55 -0600
X-Google-Sender-Auth: u5LXe-oqRWFa4ZLynSuQfGkgFx4
Message-ID: <CAEUsAPaDdXO_0z0sWp_M_sYV69N44+Ea7eqm1VvPA2mONUerag@mail.gmail.com>
Subject: Re: [PATCH 00/25] line6usb cleanup
From: Chris Rorvick <chris@rorvick.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?Q?L=2E_Alberto_Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At Fri,  9 Jan 2015 23:35:46 -0600,
> Chris Rorvick wrote:
>>
>> I have a TonePort UX2 that I've used for testing, meaning that some of
>> this is really only compile-tested.
>
> If anyone is responsible for testing with real hardware, I'll happily
> review.

To be clear, the TonePort UX2 is real hardware.  But this driver
basically supports four classes of Line 6 devices and I'm only covering
one of them.

So this series is a first step in trying to address this.  Having this
as a single driver probably made sense when it was a separate project,
but now that it is in-tree it seems like the POD, PODHD, TonePort, and
Variax pieces should each be separate drivers that each depend on a core
Line 6 driver.  I think the cleanup in this series will make that
easier.  None of this is my area of expertise, though, so advice and
feedback is very welcome.

> are there any active developers for this driver?

I intended to do further work.  I know there is quite a bit of mundane
checkpatch cleanup that would need to get done before this could get
promoted, and I believe I read that it's using sysfs for stuff that
would normally be done via an ALSA interface, and the sysfs interface
has not been documented nor has it been justified.  All stuff I thought
I might look into.

But I'm just doing this for fun so I can't promise anything.  :-)

Chris
