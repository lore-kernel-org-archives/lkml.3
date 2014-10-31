Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaJaEy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:54:57 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55442 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaJaEy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141030143324.GA19307@kroah.com>
References: <1414617716-39377-1-git-send-email-robotboy@chromium.org>
	<20141030143324.GA19307@kroah.com>
Date: Thu, 30 Oct 2014 21:54:54 -0700
X-Google-Sender-Auth: TCG0BwKRNfw9zK_cVDYOFgRqYEk
Message-ID: <CAF6FioWwQZp2jOhkmCxfHM8AGgU2_GfQ63+zp2Pw2yC9L3M24Q@mail.gmail.com>
Subject: Re: [PATCH] USB: simple: add Google simple serial SubClass support
From: Anton Staaf <robotboy@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anton Staaf <robotboy@chromium.org>, Johan Hovold <jhovold@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:33 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 29, 2014 at 02:21:56PM -0700, Anton Staaf wrote:
> > Add support for Google devices that export simple serial
> > interfaces using the vendor specific SubClass/Protocol pair
> > 0x50/0x01.
> >
> > Signed-off-by: Anton Staaf <robotboy@chromium.org>
> >
> > ---
> >  drivers/usb/serial/usb-serial-simple.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/drivers/usb/serial/usb-serial-simple.c b/drivers/usb/serial/usb-serial-simple.c
> > index fb79775..85bb973 100644
> > --- a/drivers/usb/serial/usb-serial-simple.c
> > +++ b/drivers/usb/serial/usb-serial-simple.c
> > @@ -8,6 +8,7 @@
> >   * Copyright (C) 2010 Zilogic Systems <code@zilogic.com>
> >   * Copyright (C) 2013 Wei Shuai <cpuwolf@gmail.com>
> >   * Copyright (C) 2013 Linux Foundation
> > + * Copyright (C) 2014 Google, Inc.
> >   *
> >   *   This program is free software; you can redistribute it and/or
> >   *   modify it under the terms of the GNU General Public License version
>
> Based on advice from my lawyer, a change this size does not warrent a
> copyright notice at the top of a file.  If your lawyers feel otherwise,
> please let me know and I will be glad to discuss it with them.
>
> So, care to resend this without this change to the file?
>
> thanks,
>
> greg k-h

Sigh, sorry for the top posted HTML junk previously, turns out the
gmail app for android doesn't "do the right thing"...

But yes, I'm happy to send along a version without copyright, I don't
see any problem with that.  Looks like it will
have to wait until Monday as I don't have things set up at home to
send the patch as robotboy@chromium.org.  :)

Thanks,
    Anton
