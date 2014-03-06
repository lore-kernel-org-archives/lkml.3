Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaCFLVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:21:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59670 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaCFLTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:19:02 -0500
MIME-Version: 1.0
In-Reply-To: <1394104657-8495-1-git-send-email-geert@linux-m68k.org>
References: <1394104657-8495-1-git-send-email-geert@linux-m68k.org>
Date: Thu, 6 Mar 2014 12:19:01 +0100
X-Google-Sender-Auth: fDQ1uohtU5jBKwYWeX2HQz-5-Mo
Message-ID: <CAMuHMdUJ_2ixNuEQrYy7uCCEoKkADw5ueUcGMH=jNsi0JOuFHQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 12:17 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc5[1]  to v3.14-rc4[3], the summaries are:
>   - build errors: +2/-3

  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A

i386-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7236/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7212/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
