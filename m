Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3GIHdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:33:51 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61384 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3GIHdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Tue, 9 Jul 2013 09:33:49 +0200
X-Google-Sender-Auth: 2thD8xhHKy5zG8yctuzxrwAmXNU
Message-ID: <CAMuHMdVm_G6GuMnROosQb94rk3fokiOaz70T-HZ79amV3Cyx4A@mail.gmail.com>
Subject: Re: [PATCH 0/3] cris: cleanup Kconfig files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Woodhouse, David" <David.Woodhouse@intel.com>,
        artem.bityutskiy@linux.intel.com, Cris <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jul 8, 2013 at 8:04 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This set of patches removes kernel configuration parameters for the
> CRIS architecture, which are used nowhere in the kernel source
> code and makefiles.
>
> Michael Opdenacker (3):
>   cris: cleanup arch-v10/drivers/Kconfig
>   cris: cleanup arch-v32/drivers/Kconfig
>   cris: cleanup Kconfig
>
>  arch/cris/Kconfig                  |   9 --
>  arch/cris/arch-v10/drivers/Kconfig |  79 ---------------
>  arch/cris/arch-v32/drivers/Kconfig | 197 -------------------------------------
>  3 files changed, 285 deletions(-)

(At least) Some of these have been in cris/for-next for a few months,
courtesy of
Paul Bolle.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
