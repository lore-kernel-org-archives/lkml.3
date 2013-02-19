Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab3BSLeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:34:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57512 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab3BSLeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:34:23 -0500
Message-ID: <51236339.90407@ti.com>
Date: Tue, 19 Feb 2013 13:34:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <andi@etezian.org>, <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com> <511B4C60.50404@ti.com> <CAB=otbSX_O-zbHZuPWPSEU0D1s3uKfZfeatoguoRiwogS5tVHQ@mail.gmail.com> <511CAD5D.2050502@ti.com> <CAB=otbRAj41dFMe_i+LDGbi29kMV0C-tw-HXyz7iF4m4R+5R+Q@mail.gmail.com>
In-Reply-To: <CAB=otbRAj41dFMe_i+LDGbi29kMV0C-tw-HXyz7iF4m4R+5R+Q@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig492D6F5DAB0BCF265F5BC086"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig492D6F5DAB0BCF265F5BC086
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-18 16:30, Ruslan Bilovol wrote:

>> So, I'm still inclined to say that we shouldn't merge this.
>=20
> Thanks for explanation.
>=20
> Do you have some plan when DSS will be ready to port this driver?
> (3.10, 3.11 or later)?

When it's ready =3D). The work depends also on common display framework,
so it's not only up to me.

That said, I have a prototype branch, with my version of CDF, that
somewhat works for the couple of boards and panels that I have ported.
It doesn't have DT code there, though (DSS DT is in a separate branch
for now). If all goes extremely well, I could imagine 3.10 having the
support allowing to port this driver.

And if you're interested in some prototype code, kernel crashes, DSS
debugging, etc, I can point you to my branch and give you some notes, so
you could try porting this panel driver to (my version of) CDF. Give me
a private email if you want to try that.

 Tomi



--------------enig492D6F5DAB0BCF265F5BC086
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRI2M5AAoJEPo9qoy8lh71YtkP/jmbXmSx8oETXWGFZLJCtyfF
l5qF5hMbqMVXxPOY5p5Tg0e0ldJWVjdwJ5Na+DWbzwuTYPKT9FgQJfR7NEy0jzp1
BFdXSvtlP1as7ZtT4GDHyGGFfAa4MzVictoNndws1kCze9IrQduUl0YXejnaJlLV
rviVyVqvyTz8y1dTjV9qC3g/U/F1k6LBOxXudblWHaBmlPQ66mcmemdEr6ZtEh7Q
tzZkTmmePtYisIiPmgOjIShAJ5q3BN0B19BWTE4jUYGUyUgH2+jRKNYyU4QteA8O
6CFP59g33Jc1i3VUtofYbVCHl01o/y8uEZTuDewryoIipapFrkwk31wVwOoe8+dE
+NA7nhh5HYjMvWCKOxb2H6X5Fcmb741QBatiVU27yCBq9Yl+uYQXDpyTOOiwCNGC
aih7WI00k3pdRsMJZzMVGcKy4UNKbSV8Z5geQTmtTVhL3rw+Q5uN6L15G42xteyu
Ix0cKS4GJo5dSY+2Nuk/IDwx/mNdgeQw72gewMfsSbtozUX6bCbNRRAzS7Gu7gWE
glCr52cNTxbbljOdbmqJbW+N9clxExsxMK+EQnhuHnp8hzRm9ABODiQG3QootSpD
A45LLfkOybUl+OWtpWKzJL7rer/o3Q+ilRUIBB8Oag1mXknSUElqfxIqmefSc1li
Hy6pchrSf65HXQmEAeR+
=16Rq
-----END PGP SIGNATURE-----

--------------enig492D6F5DAB0BCF265F5BC086--
