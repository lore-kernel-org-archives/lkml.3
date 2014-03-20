Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaCTH6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 03:58:30 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64614 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaCTH62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 03:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <1395282105.8649.55.camel@joe-AO722>
References: <1744772.yf52reTAmC@vostro.rjw.lan>
	<1395282105.8649.55.camel@joe-AO722>
Date: Thu, 20 Mar 2014 08:58:28 +0100
X-Google-Sender-Auth: WMaV41ARZS0O9D6-DOzvZ3-6MAQ
Message-ID: <CAMuHMdXFkf0g15vY=PkeMgxhr4G2=tWhK+jd8ejiqT0bJVaxQQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Reorder maintainer addresses for PM and ACPI
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Mar 20, 2014 at 3:21 AM, Joe Perches <joe@perches.com> wrote:
>>  SUSPEND TO RAM
>> +M:   Rafael J. Wysocki <rjw@rjwysocki.net>
>> -M:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
>
> Please keep the quotes around your name.
>
> It makes it easier for some systems to accept
> names with periods via copy/paste.

While for "git send-email", it's easier if I don't have to remove the one in
the middle manually...

Anyway, scripts/get_maintainer.pl re-adds them.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
