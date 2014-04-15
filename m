Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaDOHpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:45:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55233 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDOHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:45:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpeguwO_vkqHzk-UDooDdanGZoB3sr0pmJD5hGh2VAW1S5Dw@mail.gmail.com>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<CAMuHMdVRUyo+PAQ8XUXuhZn1jk7T645aC=E274OjUOgNktBEJw@mail.gmail.com>
	<CAJfpeguwO_vkqHzk-UDooDdanGZoB3sr0pmJD5hGh2VAW1S5Dw@mail.gmail.com>
Date: Tue, 15 Apr 2014 09:45:38 +0200
X-Google-Sender-Auth: AlHZhU6loIoZArAD6Y4vtKb-bJY
Message-ID: <CAMuHMdVAR5he=PkMSQwSgJtT_u0XPP4j0dBeJxF-buFFhfv9iw@mail.gmail.com>
Subject: Re: [PATCH 00/15] wire up renameat2 syscall for various archs
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Mon, Apr 14, 2014 at 10:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Apr 14, 2014 at 6:32 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> This series wires up the recently added renameat2 syscall for archs that are
>>> up-to-date in the sense that they appear to support the latest syscalls.  I
>>> haven't touched the rest of them..
>>>
>>> Plus three NR_syscalls miscalculation fixes.
>>
>> Do you plan to collect acks, and ask Linus to pull this series later, or
>> do you want each arch maintainer to take the patches for his/her pet
>> architecture?
>
> Whichever works best for you.
>
>> Note that I don't plan to send another pull request for 3.15 for m68k,
>> unless Something Really Bad happens.
>
> So, if that's okay, I'll send it off to Linus sometime later.

That's fine for me!

Thanks, it's been a while someone went through the hard work of adding
a syscall to all architectures ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
