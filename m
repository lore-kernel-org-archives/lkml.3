Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbbALJZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:25:17 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47638 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbALJZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:25:08 -0500
MIME-Version: 1.0
In-Reply-To: <1420857290-8373-14-git-send-email-robh@kernel.org>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
	<1420857290-8373-14-git-send-email-robh@kernel.org>
Date: Mon, 12 Jan 2015 10:25:06 +0100
X-Google-Sender-Auth: XfYAeZnaVylw5i6aW9_gyDyJbQQ
Message-ID: <CAMuHMdX0om4EjS35YKUxo+-W-YLXQ0uJRyr-PLC9VYm=Jcu+TQ@mail.gmail.com>
Subject: Re: [PATCH 13/16] pci/host: rcar-gen2: convert to use generic config accesses
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Simon Horman <horms@verge.net.au>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Valentine <valentine.barshak@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 3:34 AM, Rob Herring <robh@kernel.org> wrote:
> Convert the rcar-gen2 host PCI driver to use the generic config access
> functions.
>
> This changes the i/o accessors from io(read|write)X to readX/writeX
> variants which are equivalent on ARM.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-sh@vger.kernel.org

Thanks, look OK to me.

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
