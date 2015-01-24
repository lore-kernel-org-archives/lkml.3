Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbbAXWyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 17:54:13 -0500
Received: from ozlabs.org ([103.22.144.67]:43518 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbbAXWyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 17:54:11 -0500
Date: Sun, 25 Jan 2015 09:54:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-audit@redhat.com,
        rgb@redhat.com, sd@queasysnail.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Message-ID: <20150125095403.65aad289@canb.auug.org.au>
In-Reply-To: <CA+icZUWOkW-ujARrnT4T3wsZh0EbkHR+p2q2c1-zJYKtP46hfA@mail.gmail.com>
References: <20150122045303.1347.98054.stgit@localhost>
	<20150122075429.GV29656@ZenIV.linux.org.uk>
	<4011794.crgx99Gu8a@sifl>
	<25860171.h6aocaXFeh@sifl>
	<20150122212902.GW29656@ZenIV.linux.org.uk>
	<20150122214000.GX29656@ZenIV.linux.org.uk>
	<20150123053056.GC29656@ZenIV.linux.org.uk>
	<CA+icZUWOkW-ujARrnT4T3wsZh0EbkHR+p2q2c1-zJYKtP46hfA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d53UL_POC.o3gD+o_+bpZ1v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d53UL_POC.o3gD+o_+bpZ1v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Sat, 24 Jan 2015 10:03:06 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
>
> AFAICS, a new linux-next will be available on Monday (2015-01-26).
> I try to retest with this.

Actually, Tuesday - Monday is a holiday here.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/d53UL_POC.o3gD+o_+bpZ1v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxCKQAAoJEMDTa8Ir7ZwVVb0P/jUTjrvta2O/u5WZ5gMd/8Z6
aAMj7iV4Xb/ISaCuXhjLlINv9cENzoZg3oazE7D5sIt85oXiNRiqr5uym4OcvsW+
69rPVp8mZGdMVtWGKofuom0jjkr1NjaT+J6iLKAF74W8bLucYWZTNatvPQSkAZUx
4PjqLDM89lylb89R+fcPZDqe+hdGy2NfZXS0TXdOFDftGUlnbLW0hXqSNW9L5/sE
vaomr57pDEGZoku8GOGmQ2a2x8Z0Hl8aBAXw5VJFs2FScKBYnbiUXsujiwB8fZAW
PKffWhuLTTp3jRa+q5/6fNV3XyZpbWKnYMyMduNuddgawr0ibLgwZHNHBQqpF/hu
GeT5gJCXqIM8SVovRAqdoVppHbVZPoLPO+mrnI/L0E9WkTqx2VH2DVfyHiW3zI9q
YuEGoE+WoQwjCg30ADfxqDXQ+TQRtV0qoicXX0J1rZ/P2TpE1sIeAohXz4iyKylV
6zCMocMxpEM6rpDnLNW5kQ5c5Hm9wjabDcQiujN8UF0oPaEWDj51/yu92xpLNUL7
kB2VoBTxW4N2JaU+jL9xPDwht3G9T+TP0vwdVypXjT1bZWPuERkiWd6zmqy1UWen
uGp8U72kB1Bry9quDbHILySrLLP2vZ2XIhGYJEvfnxw+0RbQn2A+KtUw8qEyvPRJ
WYimTOZprnxdGu71vZOU
=iAoe
-----END PGP SIGNATURE-----

--Sig_/d53UL_POC.o3gD+o_+bpZ1v--
