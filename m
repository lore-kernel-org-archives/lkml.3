Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3EHUZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:25:13 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36041 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab3EHUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:25:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130505231451.GO4563@zurbaran>
References: <20130505231451.GO4563@zurbaran>
Date: Wed, 8 May 2013 22:25:09 +0200
X-Google-Sender-Auth: hfOokqQlRqAYYXFkeybfpt2O3aM
Message-ID: <CAMuHMdUMc4WKbai_aLrwbqp7EJ0HdD8zRJr7QQ+g-h=Kqt-KZQ@mail.gmail.com>
Subject: Re: [GIT] [3.10] MFD pull request
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 1:14 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> mfd: si476x: Don't use 0bNNN (2013-04-26 17:23:30 +0200)

> Andrew Morton (1):
>      mfd: si476x: Don't use 0bNNN

This only covers the header file, not the other files. Patch sent.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
