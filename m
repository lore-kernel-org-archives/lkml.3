Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaGHJWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:22:24 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:37834 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaGHJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <53BBB677.2010401@nod.at>
References: <20140705112238.16142.42735.stgit@zurg>
	<20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
	<CALYGNiMjL_GYqqkid4yQsubpnbydVXxTPnKW0GqJcg05x9zbHQ@mail.gmail.com>
	<CAFLxGvzxvuizdHyjQ0SjUm8jJcj=w+qS5ut-u76Xo-m2sftvvw@mail.gmail.com>
	<CALYGNiOTC8KOxWwRo+f=6JmtUYhJ=1cQNq-Us1BZbW85r4P+ug@mail.gmail.com>
	<53BBA9B4.7050609@nod.at>
	<CALYGNiNSFoW6Z_1o3JfV-cCeay1QmTptrt4kWHVegkuw+-6A8A@mail.gmail.com>
	<53BBACF4.4070800@nod.at>
	<CALYGNiND3xk4DGkM_RYApmX7BMkg=cKX2gUpyyOry0ny_DVrkA@mail.gmail.com>
	<53BBB0F2.20109@nod.at>
	<CALYGNiPakwGquDk9MVGeSrx4RmUOg21=_Zcw097Z5sGTsP=Cwg@mail.gmail.com>
	<53BBB4AF.1080507@nod.at>
	<CAMuHMdXczkVGAejZ2RnsdXYvTq-8eZAhheR-ygXmXKMmh9VsEA@mail.gmail.com>
	<53BBB677.2010401@nod.at>
Date: Tue, 8 Jul 2014 11:22:19 +0200
X-Google-Sender-Auth: Sw5U_eiq30Mrk1AUrf_VgVWKwJ8
Message-ID: <CAMuHMdVFh8N0Y3bMj8JomkXrYDBu5HkvL_FxU_et9QeShvztMg@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] checkstack: use $UTS_MACHINE as target architecture
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 11:14 AM, Richard Weinberger <richard@nod.at> wrote:
>> And that you don't need root permissions to run it.
>
> You can use KVM also without being root.
> It depends on the rights of /dev/kvm.

Which are controlled by... root.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
