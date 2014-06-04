Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaFDKze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:55:34 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:55129 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaFDKzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406041148590.2441@hadrien>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
	<CAMuHMdXsoFUXj4jLMWN6NY7Um19KwWO9Rhx=9=gqWu_K5Ev2kQ@mail.gmail.com>
	<alpine.DEB.2.10.1406041137270.2441@hadrien>
	<063D6719AE5E284EB5DD2968C1650D6D1725705F@AcuExch.aculab.com>
	<alpine.DEB.2.10.1406041148590.2441@hadrien>
Date: Wed, 4 Jun 2014 12:55:29 +0200
X-Google-Sender-Auth: x-uv0bJo4lG43HsNtXWjKo4TO5M
Message-ID: <CAMuHMdXPBQTYA0c=1hkC7943-_J59TVSFaEKsfY1F2ogV=Ld+A@mail.gmail.com>
Subject: Re: [PATCH 0/10] use safer test on the result of find_first_zero_bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: David Laight <David.Laight@aculab.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        scsi <linux-scsi@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Wed, Jun 4, 2014 at 11:52 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> Maybe the documented return code should be changed to allow for the
>> existing behaviour.
>
> Sorry, I'm not sure to understand what you suggest here.

include/asm-generic/bitops/find.h:

| /**
|  * find_first_zero_bit - find the first cleared bit in a memory region
|  * @addr: The address to start the search at
|  * @size: The maximum number of bits to search
|  *
|  * Returns the bit number of the first cleared bit.
|  * If no bits are zero, returns @size.

"If no bits are zero, returns @size or a number larger than @size."

|  */
| extern unsigned long find_first_zero_bit(const unsigned long *addr,
|                                          unsigned long size);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
