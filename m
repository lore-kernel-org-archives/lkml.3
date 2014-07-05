Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaGETo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:44:59 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38908 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaGETo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140705192317.GD25934@mwanda>
References: <1404564507-21718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140705192317.GD25934@mwanda>
Date: Sat, 5 Jul 2014 21:44:56 +0200
X-Google-Sender-Auth: 0hYtFyeDK8CjRAo8RIx9qgCXnWY
Message-ID: <CAMuHMdVNgCFZ1Nu77ds62COtqMPRYw4p_fifoZnAQKjq_D+kOQ@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: sis: init.c: Cleaning up variable that is
 never used
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2014 at 9:23 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, Jul 05, 2014 at 02:48:27PM +0200, Rickard Strandqvist wrote:
>> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
>
> These for lines are for when you are sending on someone else's behalf.

Or for when you are sending the patches from a different email address
than the one that should be recorded in git.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
