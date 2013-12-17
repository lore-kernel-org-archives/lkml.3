Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3LQJOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:14:42 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54333 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3LQJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <1387226379-25919-1-git-send-email-geert@linux-m68k.org>
References: <1387226379-25919-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 17 Dec 2013 10:14:39 +0100
X-Google-Sender-Auth: u3Z0UnkGLwoB2ifiS2a-k66VIxU
Message-ID: <CAMuHMdUiLoVfOzffofbcZTM3ibWSXiVQiPrHzc_zYPDFhAnC=g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 9:39 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.13-rc4[1]  to v3.13-rc3[3], the summaries are:
>   - build errors: +2/-8

Nothing serious or not yet known:

  + /scratch/kisskb/src/drivers/regulator/s2mps11.c: error: 'struct
sec_pmic_dev' has no member named 'regmap':  => 441:23

cris-allyesconfig, sh-allyesconfig, s390-allyesconfig, powerpc-allyesconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6993/ (118 out of 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6964/ (119 out of 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
