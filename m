Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3B1NWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:22:17 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:55239 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3B1NWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:22:14 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4QoutxRkuBj3p2vaw2U4-GN0Gz4ueopKkDavX_ZmgMC-w@mail.gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
	<CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
	<CANq1E4TTB-Lp+eVRPpzOMnS7XNbzHJRTicwCcwXw3AUs11XFMw@mail.gmail.com>
	<CAPM=9tzDXLqUG3c6VsMjaJ_1997h7f+_3kB0C0N2imuQcXsD6Q@mail.gmail.com>
	<CANq1E4QoutxRkuBj3p2vaw2U4-GN0Gz4ueopKkDavX_ZmgMC-w@mail.gmail.com>
Date: Thu, 28 Feb 2013 14:22:14 +0100
X-Google-Sender-Auth: _aXSedtE95XfbuQ6PF_0ro_Duow
Message-ID: <CAMuHMdUfyOe_ySL0gB_FQLjz2ACQhk6cPWi_ty5pMb6=zZduSA@mail.gmail.com>
Subject: Re: [PATCH 0/9] System Framebuffer Bus (sysfb)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 1:20 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> We currently have different drivers that can make use of "system
> framebuffers" (as I call them for now):
>  - vgacon
>  - fbdev
>  - DRM
> (- vgalog) (similar to fblog/drmlog but using vga/VBE)

offb

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
