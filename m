Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbbA0Tnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:43:50 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46086 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbbA0Tns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:43:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Stephen Boyd" <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1421684985-12397-1-git-send-email-geert+renesas@glider.be>
Cc: "Simon Horman" <horms+renesas@verge.net.au>,
        "Magnus Damm" <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1421684985-12397-1-git-send-email-geert+renesas@glider.be>
Message-ID: <20150127194333.22722.39548@quantum>
User-Agent: alot/0.3.5
Subject: Re: [git pull] clk/shmobile updates for v3.20
Date: Tue, 27 Jan 2015 11:43:33 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Geert Uytterhoeven (2015-01-19 08:29:45)
>         Hi Mike,
> 
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git clk-shmobile-for-3.20

Pulled.

Regards,
Mike

> 
> for you to fetch changes up to 1484276119fb5083a3a8cb0293e763363c317661:
> 
>   clk: shmobile: Add R-Car Gen2 ADSP clock support (2015-01-08 16:14:31 +0100)
> 
> Summary:
>   - A bug fix needed on sh73a0,
>   - r8a7793 support,
>   - r8a73a4 CCF implementation and documentation,
>   - R-Car Gen2 CAN and ADSP clock support.
> 
> Thanks for pulling!
> 
> ----------------------------------------------------------------
> Geert Uytterhoeven (1):
>       clk: shmobile: div6: Avoid changing divisor in .disable()
> 
> Hisashi Nakamura (1):
>       clk: shmobile: Add r8a7793 support
> 
> Sergei Shtylyov (2):
>       clk: shmobile: Add R-Car Gen2 RCAN clock support
>       clk: shmobile: Add R-Car Gen2 ADSP clock support
> 
> Ulrich Hecht (2):
>       clk: shmobile: r8a73a4 common clock framework implementation
>       clk: shmobile: Add r8a73a4 SoC to MSTP bindings
> 
> Yoshihiro Kaneko (1):
>       clk: shmobile: r8a7793: document CPG clock support
> 
>  .../bindings/clock/renesas,cpg-mstp-clocks.txt     |   1 +
>  .../bindings/clock/renesas,r8a73a4-cpg-clocks.txt  |  33 +++
>  .../clock/renesas,rcar-gen2-cpg-clocks.txt         |  12 +-
>  drivers/clk/shmobile/Makefile                      |   2 +
>  drivers/clk/shmobile/clk-div6.c                    |  15 +-
>  drivers/clk/shmobile/clk-r8a73a4.c                 | 241 +++++++++++++++++++++
>  drivers/clk/shmobile/clk-rcar-gen2.c               |  88 ++++++++
>  7 files changed, 384 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/renesas,r8a73a4-cpg-clocks.txt
>  create mode 100644 drivers/clk/shmobile/clk-r8a73a4.c
> 
> Gr{oetje,eeting}s,
> 
>                                                 Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                             -- Linus Torvalds
