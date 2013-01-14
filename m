Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3ANSYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:24:44 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:44064 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab3ANSYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:24:42 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH 1/2] nconf:  add keybindings for vi-style menu navigation, rewrite help texts
Date: Mon, 14 Jan 2013 19:24:36 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp> <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com> <20121229223415.GB28355@mobil.systemanalysen.net>
In-Reply-To: <20121229223415.GB28355@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141924.37268.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, All,

On Saturday 29 December 2012 Roland Eggner wrote:
> On 2012-12-28 Friday at 23:40 +0400 Dmitry Voytik wrote:
> > Add alternative vi-style keys for the menu navigation:
> > <j>/<k> for down/up navigation, <C-f>/<C-b> for
> > page down/up, <g>/<G> for first/last menu item selection
> > and <l> for entering to a submenu.
> 
> Good starting point, thanks for your initial work.
> Here is completion of the work:

I'm sorry, but this patch does not apply cleanly, neither on-top of
Dmitry's patch, nor on-top of Michal's for-next branch:

$ patch -p1 --dry-run <../roland-nconf-2.patch
patching file scripts/kconfig/nconf.c
Hunk #1 FAILED at 12.
Hunk #2 FAILED at 229.
Hunk #3 FAILED at 319.
Hunk #4 FAILED at 355.
Hunk #5 succeeded at 393 with fuzz 1 (offset 1 line).
Hunk #6 succeeded at 408 (offset 1 line).
Hunk #7 succeeded at 1116 (offset 8 lines).
Hunk #8 FAILED at 1141.
Hunk #9 succeeded at 1178 (offset 8 lines).
Hunk #10 FAILED at 1302.
Hunk #11 succeeded at 1348 with fuzz 1 (offset 8 lines).
6 out of 11 hunks FAILED -- saving rejects to file scripts/kconfig/nconf.c.rej

git am does not like it either:
$ git am ../roland-nconf-2.patch
Applying: nconf: add keybindings for vi-style menu navigation, rewrite help texts
error: patch failed: scripts/kconfig/nconf.c:12
error: scripts/kconfig/nconf.c: patch does not apply

Also, the patch is line-mangled, with long lines being wrapped by your
MUA. Could you use git send-email, next time, please?

Care to resend your patch on-top of Michal's for-next branch (and on-top
of Dmitry's patch if needed) ? Or tell me what branch to apply it onto.

Thank you.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'

