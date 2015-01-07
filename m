Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbbAGKit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:38:49 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:40823 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbbAGKir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:38:47 -0500
MIME-Version: 1.0
In-Reply-To: <1420558883-10131-17-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
	<1420558883-10131-17-git-send-email-mst@redhat.com>
Date: Wed, 7 Jan 2015 11:38:43 +0100
X-Google-Sender-Auth: oSEhfYwqup3TauoLfx3iMKeaU30
Message-ID: <CAMuHMdXx+LEHjOoA3q6hs2_Lm4Ma+svGRT10ux_uHgBbbzooUQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/40] m68k/uaccess: fix sparse errors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 4:44 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> virtio wants to read bitwise types from userspace using get_user.  At the
> moment this triggers sparse errors, since the value is passed through an
> integer.
>
> Fix that up using __force.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
