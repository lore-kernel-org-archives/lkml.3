Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3IYI47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:56:59 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43930 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IYI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <1380099255-25559-1-git-send-email-geert@linux-m68k.org>
References: <1380099255-25559-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 25 Sep 2013 10:56:57 +0200
X-Google-Sender-Auth: aqdiQFvfxH7rXO14OD38_wTsgw4
Message-ID: <CAMuHMdUBaFWH6rmUMpr=fJ2J_bXjnK2CqdZaCWxqqQFXutuEGQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.12-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:54 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.12-rc2 to v3.12-rc1[3], the summaries are:
>   - build errors: +15/-11

  + error: arch/powerpc/kernel/entry_32.S: undefined reference to
`uprobe_post_sstep_notifier':  => .text+0x10570)
  + error: arch/powerpc/kernel/entry_32.S: undefined reference to
`uprobe_pre_sstep_notifier':  => .text+0x10564)
  + error: fork.c: undefined reference to `uprobe_clear_state':  => .text+0xff4)
  + error: fork.c: undefined reference to `uprobe_copy_process':  =>
.text+0x1974)
  + error: fork.c: undefined reference to `uprobe_dup_mmap':  => .text+0x5d0)
  + error: fork.c: undefined reference to `uprobe_end_dup_mmap':  =>
.text+0x890)
  + error: fork.c: undefined reference to `uprobe_start_dup_mmap':  =>
.text+0x5b4)
  + error: memory.c: undefined reference to `uprobe_munmap':  => .text+0x27c78)
  + error: trace_uprobe.c: undefined reference to `uprobe_register':
=> .text+0x9aaa0)
  + error: trace_uprobe.c: undefined reference to `uprobe_unregister':
 => .text+0x9a9fc)

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6701/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6676/ (all 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
