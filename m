Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3HVK7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:59:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43203 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3HVK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbKxcQCq8XdYakG5Dg8F_G8NunQjca-TyZbn4q0v3okaqw@mail.gmail.com>
References: <20130820224032.GA20491@kroah.com>
	<521504D7.7090204@wwwdotorg.org>
	<CA+55aFxMkQoJAJd2=XyJu0NX2dG3mX=obx=YL6YXatLg4S=-Vw@mail.gmail.com>
	<20130821200034.GA10671@nazgul.tnic>
	<CA+8MBbKxcQCq8XdYakG5Dg8F_G8NunQjca-TyZbn4q0v3okaqw@mail.gmail.com>
Date: Thu, 22 Aug 2013 12:59:47 +0200
X-Google-Sender-Auth: lDViAnhnK9FAtr6azvd8IILz75U
Message-ID: <CAMuHMdX_rWQRKBLA0VywpuYa_o75YkxP6fmrh4deV1egc5Ggcg@mail.gmail.com>
Subject: Re: Proposed stable release changes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:54 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Running daily git snapshots can be "exciting" during the merge window. But
> I rarely see problems running a random build after -rc1.  If you are still

Indeed.

> running that ancient 3.11-rc6 released on Sunday - then you are missing out
> on 28 commits worth of goodness since then :-)

Yeah, that's why I almost started debugging the non-appearance of my
shiny new procfs entry. Still running 3.11-rc6 :-(
Then I remembered the proc_readdir() issues...

Perhaps -rc7 should have been released immediately after those fixes ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
