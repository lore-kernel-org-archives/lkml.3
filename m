Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbaCTTE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:04:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59910 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670AbaCTTEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:04:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140320183932.GA7528@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de>
	<20140320173106.GA19395@obsidianresearch.com>
	<532B2628.5080305@codethink.co.uk>
	<201403201929.13633.arnd@arndb.de>
	<20140320183932.GA7528@n2100.arm.linux.org.uk>
Date: Thu, 20 Mar 2014 20:04:22 +0100
X-Google-Sender-Auth: C3ybQ64I-OhR66iHI02qdQaTX68
Message-ID: <CAMuHMdX0kZhJyJFCQK7MUbv3nnKbqLkEJ2gnWMuHLSGLQvuQ2A@mail.gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Mar 20, 2014 at 7:39 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> That all said, what I find most annoying is that Ben has ignored my
> question about exactly what the nature of the limitation is on this
> platform.  My response to that is - if you're not going to do the
> curtesy of answering such a simple question, then you don't get to
> patch the kernel for this problem.

Ben did answer:
"If the window is set to 2GiB it can only access 2GiB aligned to 2GiB
 boundary, however DRAM spans a 2GiB boundary (being at 1-3GiB)"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
