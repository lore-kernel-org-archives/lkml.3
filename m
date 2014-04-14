Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaDNQcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:32:18 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64072 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaDNQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
Date: Mon, 14 Apr 2014 18:32:14 +0200
X-Google-Sender-Auth: 55bh9q2MAFSgnj6MQdbnLseCq5g
Message-ID: <CAMuHMdVRUyo+PAQ8XUXuhZn1jk7T645aC=E274OjUOgNktBEJw@mail.gmail.com>
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

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> This series wires up the recently added renameat2 syscall for archs that are
> up-to-date in the sense that they appear to support the latest syscalls.  I
> haven't touched the rest of them..
>
> Plus three NR_syscalls miscalculation fixes.

Do you plan to collect acks, and ask Linus to pull this series later, or
do you want each arch maintainer to take the patches for his/her pet
architecture?

Note that I don't plan to send another pull request for 3.15 for m68k,
unless Something Really Bad happens.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
