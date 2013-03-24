Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3CXPpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:45:44 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:58942 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3CXPpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <514F1D9E.8020601@blueyonder.co.uk>
References: <514EFC08.1000509@blueyonder.co.uk>
	<CAMuHMdXyn+rCkBJg29CFW-kzCM+AbvhsEVfNueXXfyFs8FFqtg@mail.gmail.com>
	<514F1D9E.8020601@blueyonder.co.uk>
Date: Sun, 24 Mar 2013 16:45:40 +0100
X-Google-Sender-Auth: 3jz0_wQ9-CQ-5w3-zLejGbKYliw
Message-ID: <CAMuHMdVYKdasvv8aNqA1DWj-T3GAHPwTnBZOA5utrP5MwX9gBw@mail.gmail.com>
Subject: Re: 3.9-rc4 Makefile EXTRAVERSION still -rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 4:37 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> tindog:/usr/src/XXX/linux # git pull
> Already up-to-date.
> tindog:/usr/src/XXX/linux # git show v3.9-rc4
> fatal: ambiguous argument 'v3.9-rc4': unknown revision or path not in the
> working tree.

So you didn't have v3.9-rc4 yet. Probably the mirror was not up-to-date.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
