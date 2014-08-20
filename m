Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaHTPy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:54:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57295 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaHTPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:54:25 -0400
Date: Wed, 20 Aug 2014 10:54:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Richard Leitner <richard.leitner@skidata.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] usb: gadget: serial: remove PREFIX macro
Message-ID: <20140820155417.GD24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140718113946.0e70c0cb@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <20140718113946.0e70c0cb@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 18, 2014 at 11:39:46AM +0200, Richard Leitner wrote:
> Remove the ttyGS PREFIX macro from u_serial.c and replace all occurences =
with
> the hardcoded ttyGS string.
>=20
> This macro was mostly used in a few debug/warning messages and a lot of
> hardcoded ttyGS existed beneath. It may have been used for renaming the
> tty, but if done so most debug messages would have ignored this because
> of the hardcoded strings.
>=20
> Due to the fact the usage of this PREFIX instead of the hardcoded strings
> in all debug calls would have resulted in a hard to read/grep code it
> is removed completely.
>=20
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>

patch looks fine, can you resend with RFC in the subject ?

--=20
balbi

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9MSpAAoJEIaOsuA1yqREL38QAJNAk4q+sZqr3dBuvvUml27e
PW9BWURUbWDxpA/NGlEu4cqHTgg4mcPclqMs8Abve0O8hO7g3p6Q8pUT8k7hx0ZN
oExjlhw+gzaaRJP/PeU8SnXImMdhQ0xBqg06MkOkfHBPzID5iNrHNSLo3CHkqBb5
eAFAHI85UKdN/NlqPr6Rs7duQqpWjqMbVTZRAM6G/7ilSijQbV1Be5pJy1DWNoU9
AknJBxld94oxKOi0S+NMTyhLhlEQ7fxaDWEtaXvQ21P2kFKShyIuQ6+iQm9NAjB8
b2DDh33KJfsS/o++0APSAl60shXRYCp9IBTBLJJS14wzWnwL339WZ4xl5g4vPQgT
8EunljtRkpO+XVhdT59MmafqO/vdpJrjPpXms8VYJE7KhvdJngEDTfx3lVsoMKoN
+9kRXrZtqYzR4/YdinjrJXV04g5LXb9tt/jbDTlfNXMOLBPL79KT6t4HwCCRlK8N
QxW89NOKQiHvBhb5zmMVIXLXBtu0ERlkzd145pyJt9zfSXbpKeyc27oVbWeE6JnF
sfJmIC3rZF8lmshDuHcpEt2t4Xa83LKEygjaz/bgrgzh2CMTJAauwvNCcFR+AHnq
85gxOvTmXOe4lu1VUOghcNspGvRiXxCmSQ3FV9g/zLTSeWhdj+yaOXUwYPjc1K4C
7fKTQiL0SLCi4Sd5BmSv
=Lp7+
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
