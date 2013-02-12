Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3BLJU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:20:26 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:41928 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445Ab3BLJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130211091109.GA3890@osiris>
References: <1360432485-25726-1-git-send-email-geert@linux-m68k.org>
	<20130211091109.GA3890@osiris>
Date: Tue, 12 Feb 2013 10:20:22 +0100
X-Google-Sender-Auth: nV7TGyBCaOrHnY-xY8Qcm9F_OME
Message-ID: <CAMuHMdWm+VfBFN8fqL+Nkt7h5-+xv5EeeknhtkroAk4FhiRMnA@mail.gmail.com>
Subject: Re: [PATCH] s390: Add missing PAGE_SHARED as an alias for PAGE_RW
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Mon, Feb 11, 2013 at 10:11 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> Thanks Geert. A similar patch however is already in linux-next, together
> with a whole bunch of other patches which try to make s390's allmodconfig
> compile again after PCI, HAS_DMA and HAS_IOMEM got enabled by our new PCI
> code.

Cool!

Will you select HAVE_GENERIC_HARDIRQS soon, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
