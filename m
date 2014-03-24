Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaCXPtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:49:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45520 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCXPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:49:38 -0400
MIME-Version: 1.0
In-Reply-To: <1395675399.6440.14.camel@x220>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	<1392934261.15264.22.camel@x220>
	<alpine.LRH.2.03.1402210921010.4656@AMR>
	<1393925767.3038.23.camel@x220>
	<20140324131104.GC5777@linux.intel.com>
	<20140324133154.GD5777@linux.intel.com>
	<1395675399.6440.14.camel@x220>
Date: Mon, 24 Mar 2014 16:49:37 +0100
X-Google-Sender-Auth: 56-4slkDm7C9cVQ4xmt-YPiOrwY
Message-ID: <CAMuHMdVMq30_XFLNzwjj6kXWVvasa8Ewog0MmOd1PNDQDuybqA@mail.gmail.com>
Subject: Re: [PATCH v2] NVMe: silence GCC warning on 32 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Mar 24, 2014 at 4:36 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> And as this is now unlikely to be in time for v3.14, we might decide to
> dig deeper. It won't be the first time that a rather small change (say,
> converting a variable from signed to unsigned) turns out be enough to
> make GCC understand the flow of the code.

Anything we can do with factoring out the "if (!first)" in both branches?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
