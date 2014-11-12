Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaKLOCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:02:36 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37389 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaKLOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:02:35 -0500
MIME-Version: 1.0
Date: Wed, 12 Nov 2014 15:02:29 +0100
X-Google-Sender-Auth: IV7rcHBG35UJB4QLyFMr3YhL2uQ
Message-ID: <CAMuHMdX1U1YQ29gcveLq2YbdGohk60+pXbjjJU1bV+AM1ZxZFg@mail.gmail.com>
Subject: [git pull] clk/shmobile updates for v3.19
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ulrich Hecht <ulrich.hecht@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

This is my first pull request from renesas-drivers.
If there's anything that can be improved, please let me know.
Thanks!

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git
div6-clk-for-3.19

for you to fetch changes up to bfadcadf03a63bc841f69ed1c47e930b2ba2273d:

  clk: shmobile: document DIV6 clock parent bindings (2014-11-12 14:24:08 +0100)

Summary:
  - clk: shmobile: DIV6 clock variable parent support (from Ulrich Hecht)

Thanks for pulling!

----------------------------------------------------------------
Ulrich Hecht (2):
      clk: shmobile: div6: support selectable-input clocks
      clk: shmobile: document DIV6 clock parent bindings

 .../bindings/clock/renesas,cpg-div6-clocks.txt     |  18 ++--
 drivers/clk/shmobile/clk-div6.c                    | 113 ++++++++++++++++++---
 2 files changed, 113 insertions(+), 18 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
