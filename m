Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3J1Q2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:28:03 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:50036 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab3J1Q2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:28:00 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 12:28:00 EDT
From: Konstantin Tokarev <annulen@yandex.ru>
To: Yann Collet <yann.collet.73@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brent Taylor <motobud@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <106621382627723@web13g.yandex.ru>
References: <55541379679397@web20h.yandex.ru>
 <CAP+RiCAVuUEfyjg02+ZjeFXgUuaRW+fuMB490Ce2Hq_4qHBL=A@mail.gmail.com>
 <loom.20131023T201657-894@post.gmane.org> <237221382623942@web21m.yandex.ru> <106621382627723@web13g.yandex.ru>
Subject: Re: lz4hc compression in UBIFS?
MIME-Version: 1.0
Message-Id: <3901382977358@web14h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 28 Oct 2013 20:22:38 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



24.10.2013, 19:15, "Konstantin Tokarev" <annulen@yandex.ru>:
> Attached patch to crypto API wrapper for lz4hc seems to fix the issue. I can save
> and read files on LZ4HC-compressed volume, and I'm running on LZ4HC-compressed rootfs,
> flashed from mkfs.ubifs generated image (patch by Elie De Brauwer). My software
> works correctly.
>
> Unfortunately, on my board LZ4HC-compressed UBIFS volume performs noticeable worse
> than LZO, while still faster than zlib. I guess the reason is that CPU is no longer a
> bottleneck for my system, but NAND speed.
>
> Thank you all for your help!

Can anyone review the correctness of my patch? Looks like API of LZ4 decompressor is
used wrong way in crypto API.

-- 
Regards,
Konstantin
