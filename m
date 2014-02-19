Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaBSJ70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:59:26 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63541 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaBSJ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <1392803546.27558.16.camel@x220>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	<1392803546.27558.16.camel@x220>
Date: Wed, 19 Feb 2014 10:59:19 +0100
X-Google-Sender-Auth: 6tnmhiIEQn6LOEW1RDr9rFOIV8c
Message-ID: <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
Subject: Re: [PATCH] target_core_alua: silence GCC warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 10:52 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> -               ret = core_alua_state_nonoptimized(cmd, cdb,
> -                                       nonop_delay_msecs, &alua_ascq);
> +               core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);

I suggest making core_alua_state_nonoptimized()  return void, too.
Currently it always returns zero.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
