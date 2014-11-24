Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaKXHbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:31:31 -0500
Received: from ozlabs.org ([103.22.144.67]:42605 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaKXHb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:31:29 -0500
Date: Mon, 24 Nov 2014 18:31:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: linux-next: manual merge of the driver-core tree with the v4l-dvb
 tree
Message-ID: <20141124183122.4f318d48@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XOX+OO=RtEl8a92mAh4k8GN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XOX+OO=RtEl8a92mAh4k8GN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/staging/media/omap24xx/omap24xxcam.c between commit
db85a0403be4 ("[media] omap24xx/tcm825x: remove deprecated omap2 camera
drivers") from the v4l-dvb tree and commit 8c5bd8111b45 ("staging:
media: omap24xx: drop owner assignment from platform_drivers") from the
driver-core tree.

I fixed it up (the former removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XOX+OO=RtEl8a92mAh4k8GN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUct7OAAoJEMDTa8Ir7ZwVSVwP/i4BiU8dBmxELIw19oXVtfbV
N57T8QHVNWn5yQADND6pEa/KEjos0PirS9NZaiaYN7aYb9/odrjH8lLY68yODET+
bvaCT7AKUDd3Qi0XkMJYsgnDikgYS3G3yJpF64QvNMeiq8wzkP+EPQJ+Xn9SH93C
Mu8Ws5fdxdvp044DUf7+5jiV6PtS59DSVov8rhU8LfiokXDJTbIxJ0v8zvlGKulw
w9WeVljXFiCdbZjapGSM0hh/62kVUtibdMcFaE9g8P6BvXaOyheAfMpWpnoVCbGR
m9tWzrAe46OO0kJGPF9JeSluZLezToMGEQboaJdT01ZR07YnXJhX/z4G96bAMghm
v5QmJrWrb7whTm+xqDGY3Xv9H7XSSNrKf7rxlLZyd1QyOkwRNkJF5updfEbUo7gN
IAn7uP9gvatouw+iyw1knzNrtBB7tlQyJf22MTt61hWptheV3KknqNi4p1kvhnw9
v7jpU9owo8iImp7niahxzGDR4XWb+oCzPy2ppIUXTvczo4+Jml6q3xeVvMYO3hFn
Kfj0OqucRadvq22JY8VU/UXFAQARPKio+4SfH9tDPLtvZKPJr227z/RKVRruQKQs
A2DOwuFg6ctph3iIqc6DULad0vI4+4OHhCIEenyIFnFqL4qL7mhAsBhlQWXZ1fDT
fFH9eSve/rCnGx8OcrUa
=WaCc
-----END PGP SIGNATURE-----

--Sig_/XOX+OO=RtEl8a92mAh4k8GN--
