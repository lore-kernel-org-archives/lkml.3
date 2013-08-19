Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3HSKNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:13:18 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35312 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3HSKNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130819091839.GX5918@redhat.com>
References: <1376777374-17521-1-git-send-email-richard@nod.at>
	<20130819091839.GX5918@redhat.com>
Date: Mon, 19 Aug 2013 12:13:14 +0200
X-Google-Sender-Auth: fk-MBCOgd6zsBIMBTk4F0-4bYI4
Message-ID: <CAMuHMdXgGPFx6OwHdc73bY6Cb1jYHbjpEqq6e+YC9RuvJYRxDw@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] um: ubd: Add REQ_FLUSH suppport
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Mon, Aug 19, 2013 at 11:18 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> On Sun, Aug 18, 2013 at 12:09:34AM +0200, Richard Weinberger wrote:
>> UML's block device driver does not support write barriers,
>> to support this this patch adds REQ_FLUSH suppport.
>> Every time the block layer sends a REQ_FLUSH we fsync() now
>> our backing file to guarantee data consistency.
>
> This fixes the sync problem I saw before.  So:

What's the impact on your performance figures?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
