Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaFZGaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:30:00 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:52644 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaFZG37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:29:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAMwGMjw6gxKSJ1dH=jx0htV9r=HDtYwqbx3OyZz2gWbt_f-4sQ@mail.gmail.com>
References: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
	<53AAEC38.1030506@samsung.com>
	<CAMwGMjwAkKidt-B_aenConMbtsk6uSAcfJqXw0r6X2vyADo7Wg@mail.gmail.com>
	<CAMwGMjw6gxKSJ1dH=jx0htV9r=HDtYwqbx3OyZz2gWbt_f-4sQ@mail.gmail.com>
Date: Thu, 26 Jun 2014 08:29:58 +0200
X-Google-Sender-Auth: Gn0ODYxgHb29sLKQxQWbzUSfkxs
Message-ID: <CABkLObrMGzF11Pi2vgp9V2f34FnTmY4DtSirQSZc0gVC0fnM5A@mail.gmail.com>
Subject: Re: USB_MUSB_DA8XX with g_multi.ko
From: Christian Riesch <christian.riesch@omicron.at>
To: Jon Ringle <jon@ringle.org>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Thu, Jun 26, 2014 at 4:46 AM, Jon Ringle <jon@ringle.org> wrote:
> The only thing I needed to do was to remove the
> BROKEN dependency on USB_MUSB_DA8XX. Is there anything else I would
> have to do besides just removing BROKEN to get this accepted back into
> the kernel source tree?

I tried to remove the BROKEN dependency in [1], but without success.
See Felipe's response to my patch for more info. There was also
another discussion about this, see [2].
Christian

[1] http://marc.info/?t=139402222600001&r=1&w=2
[2] http://marc.info/?t=139525767500007&r=1&w=2
