Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaKLJsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:48:17 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:35238 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKLJsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <1415785566-12758-1-git-send-email-geert@linux-m68k.org>
References: <1415785566-12758-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 12 Nov 2014 10:48:14 +0100
X-Google-Sender-Auth: IWMZgSPZcgWZvL0AF1fJEkXVSZM
Message-ID: <CAMuHMdXkFo--38rRKSpGTb8U58KavPzmm7vwwdN6_SP01Zxt8w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:46 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc4[1]  to v3.18-rc3[3], the summaries are:
>   - build errors: +5/-6

  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD'
undeclared (first use in this function):  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each
undeclared identifier is reported only once:  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each
function it appears in.):  => 378

um-defconfig

  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A

i386-randconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8061/ (120 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8044/ (120 out of 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
