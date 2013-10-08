Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3JHQg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:36:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34932 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3JHQg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131007165344.GA10162@logfs.org>
References: <524C4CF5.7060601@nsn.com>
	<20131007174943.GB23337@ld-irv-0074.broadcom.com>
	<20131007165344.GA10162@logfs.org>
Date: Tue, 8 Oct 2013 18:36:26 +0200
X-Google-Sender-Auth: ny-L2A6WyvUqmg32RFL_Sndc__A
Message-ID: <CAMuHMdUbQBUg_FgGu_xzmznbjkk4qpHiL=LbOhPGZ1FZ2rP0qA@mail.gmail.com>
Subject: Re: [PATCH] mtd: phram: Make phram 64-bit compatible
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Joern Engel <joern@lazybastard.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 6:53 PM, Jörn Engel <joern@logfs.org> wrote:
> One possible solution would be to have three suffixes.  Ki for
> base-1024, Kd for base-1000 and K for "I don't care, you decide for
> me".  But I am sure that would simply cause another round of
> flamewars.

Indeed. Why deviate from SI with "Kd" (a new invention)??
That should just be "k".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
