Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaFZPPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:15:00 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48154 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaFZPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:14:58 -0400
MIME-Version: 1.0
In-Reply-To: <CABkLObrMGzF11Pi2vgp9V2f34FnTmY4DtSirQSZc0gVC0fnM5A@mail.gmail.com>
References: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
	<53AAEC38.1030506@samsung.com>
	<CAMwGMjwAkKidt-B_aenConMbtsk6uSAcfJqXw0r6X2vyADo7Wg@mail.gmail.com>
	<CAMwGMjw6gxKSJ1dH=jx0htV9r=HDtYwqbx3OyZz2gWbt_f-4sQ@mail.gmail.com>
	<CABkLObrMGzF11Pi2vgp9V2f34FnTmY4DtSirQSZc0gVC0fnM5A@mail.gmail.com>
Date: Thu, 26 Jun 2014 11:14:57 -0400
X-Google-Sender-Auth: SxJpikSpY5UvChjJwfENiJ3ql3k
Message-ID: <CAMwGMjypdT8cjtzuRT9Gip4sy58MRomCQ9++0Cu=0DYvjWKbAQ@mail.gmail.com>
Subject: Re: USB_MUSB_DA8XX with g_multi.ko
From: Jon Ringle <jon@ringle.org>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 2:29 AM, Christian Riesch
<christian.riesch@omicron.at> wrote:
> Hi Jon,
>
> On Thu, Jun 26, 2014 at 4:46 AM, Jon Ringle <jon@ringle.org> wrote:
>> The only thing I needed to do was to remove the
>> BROKEN dependency on USB_MUSB_DA8XX. Is there anything else I would
>> have to do besides just removing BROKEN to get this accepted back into
>> the kernel source tree?
>
> I tried to remove the BROKEN dependency in [1], but without success.
> See Felipe's response to my patch for more info. There was also
> another discussion about this, see [2].
> Christian
>
> [1] http://marc.info/?t=139402222600001&r=1&w=2
> [2] http://marc.info/?t=139525767500007&r=1&w=2

Thanks for the additional info.
Since my primary interest is in getting this working on the 3.12 tree,
and the drivers/phy/ source directory had not been added yet at this
point in the history, I am not motivated enough to implement Felipe's
suggestion of moving phy_on()/phy_off() to a drivers/usb/phy-da8xx.c.
If sometime down the road, we decided to move to a newer kernel
release, and the work hasn't been done yet, then I'll have a greater
motivation to implement something along those lines. For now I will
live with just removing BROKEN from our local kernel tree.

Jon
