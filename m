Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3CXNtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:49:53 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:39846 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3CXNtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:49:52 -0400
MIME-Version: 1.0
In-Reply-To: <514EFC08.1000509@blueyonder.co.uk>
References: <514EFC08.1000509@blueyonder.co.uk>
Date: Sun, 24 Mar 2013 14:49:51 +0100
X-Google-Sender-Auth: d1RJETrGVAj17psWGSYo-yXzpdk
Message-ID: <CAMuHMdXyn+rCkBJg29CFW-kzCM+AbvhsEVfNueXXfyFs8FFqtg@mail.gmail.com>
Subject: Re: 3.9-rc4 Makefile EXTRAVERSION still -rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 2:13 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> Using git pull or git clone this field in the Makefile remains unchanged.

Not for me:

$ git show v3.9-rc4
tag v3.9-rc4
Tagger: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Mar 23 16:52:52 2013 -0700

Linux 3.9-rc4
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRTkBaAAoJEHm+PkMAQRiGnK8H/iAtbU3o8th651xsVY/X1lTy
uzFmZpfjwfM+OB5n69qcZL+V9I0b54ZKOa98OAtWlMPXifTWdznDNStqvQeRmodr
Eet/W9MwgsaBDw+/vaJKuBf5ny3msayPSA1jkVAjb1VfpheH5zvLXNo1857FoSfi
cl9jrD3tIrM6EmNwR+EWANjb1xYtJfnbtnF6xHpcEG64bcidEv8ZC7V48KNL16Dt
Duy5+ZIsGoHsMj45y35KP032NtBpPvCmmXOjkO8fwwAwK+IvyivKJFfo3UlvmVdr
seHQ5RgI/g0SCupLx6N4fBUNfYi/7yNn/ZAiNO06g0ErmOSs38KlRFDg63tLZ+g=
=yJhy
-----END PGP SIGNATURE-----

commit 8bb9660418e05bb1845ac1a2428444d78e322cc7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Mar 23 16:52:44 2013 -0700

    Linux 3.9-rc4

diff --git a/Makefile b/Makefile
index 22113a7..54d2b2a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 9
 SUBLEVEL = 0
-EXTRAVERSION = -rc3
+EXTRAVERSION = -rc4
 NAME = Unicycling Gorilla

 # *DOCUMENTATION*
$

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
