Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaI2Jbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:31:34 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:38089 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaI2Jbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <1410976602-1536-1-git-send-email-balbi@ti.com>
References: <1410976602-1536-1-git-send-email-balbi@ti.com>
Date: Mon, 29 Sep 2014 11:31:30 +0200
X-Google-Sender-Auth: 5zluc6nASgRcUtHvJUr1G8sxp8w
Message-ID: <CAMuHMdX9mSv0H-fS23KKONO+=aiCtZ5fxZBvbBnhCev3DffkCQ@mail.gmail.com>
Subject: Re: [GIT PULL] USB changes for v3.18 merge window
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 7:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> Andrzej Pietrasiewicz (23):
>       usb: gadget: uvc: rename functions to avoid conflicts with host uvc

It seems not everything got renamed:

drivers/usb/gadget/function/uvc_v4l2.c:363:23: error:
'uvcg_v4l2_get_unmapped_area' undeclared here (not in a function)
make[5]: *** [drivers/usb/gadget/function/uvc_v4l2.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/12028115/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
