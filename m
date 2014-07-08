Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaGHHPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:15:38 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:36070 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGHHP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <1404780343-32188-1-git-send-email-lauraa@codeaurora.org>
References: <1404780343-32188-1-git-send-email-lauraa@codeaurora.org>
Date: Tue, 8 Jul 2014 09:15:27 +0200
X-Google-Sender-Auth: bQPjakfxqpDpohgzaT8v-VCyINs
Message-ID: <CAMuHMdX0Bab6XZsujiNcCfaPLGn7-hDdcoJFYUB1UO+HNPUFww@mail.gmail.com>
Subject: Re: [PATCH] of: Use proper types for checking memory overflow
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@linaro.org>, Nicolas Pitre <nico@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 2:45 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
> Commit a67a6ed15513541579d38bcbd127e7be170710e5
> (of: Check for phys_addr_t overflows in early_init_dt_add_memory_arch)
> corrected early_init_dt_add_memory_arch to account for overflows
> but did so in an unclean way using ULONG_MAX. There is no
> guarantee that sizeof(unsigned long) == sizeof(phys_addr_t).
> Check against phys_addr_t instead.

Thanks!

> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
