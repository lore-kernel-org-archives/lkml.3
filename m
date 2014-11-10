Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaKJEuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:50:06 -0500
Received: from ozlabs.org ([103.22.144.67]:47582 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaKJEuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:50:05 -0500
Date: Mon, 10 Nov 2014 15:49:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>
Subject: linux-next: manual merge of the tty tree with the tty.current tree
Message-ID: <20141110154958.5729e46e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/R0PZF6PRl_EPEso8w9yGGav"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/R0PZF6PRl_EPEso8w9yGGav
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/8250/8250_mtk.c between commit cd92208f6996 ("tty:
serial: 8250_mtk: Fix quot calculation") from the tty.current tree and
commit 2a768264eef0 ("tty: serial: Fix mediatek UART driver setting
baudrate issue") from the tty tree.

I fixed it up (I just used the version from the tty tree) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/R0PZF6PRl_EPEso8w9yGGav
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYEP7AAoJEMDTa8Ir7ZwVnnUP/3lda4Z+Egqqcbb1sdELcxAj
9b9EyKlc9TQhKo5sEgj6bRKy07r4PCrh3Jjo8ediPbQZOnJUO8KqftqKvTzrTbwM
HczawK8hilGdVviZh8T4QvswHIieFgmm2Gwt4fvNCi+RbDxayamlO/MGPd1YZGik
QWu2hGOHB95ApQAuyJW6VTzEqUo3cQd3nD/1D1RMBRR7bi0HxioTRo/7qlm41Hn0
aeYqYrmsi35a1t6S+yw96HaTGRRqTmY1cZoJgKIjaX8LAY2cevfAb73jOPiRIFfs
hQwZcKFmHl+nERgVWpEdHidMB6xylsVof6co5JcCaSD9+P3YOMU9ecGoM6OdA84D
8tZKnAqBPfG+vREFxoZuLmscaWqInOXuuJcbfvBENFsjlyo47mrCbc4gHPpXac4F
c5S9E6tGdWzQB2ZasFBJeAvLA/19Edrzl/C9TGhAt1BJ7bH0F5XyNC2EaAHZJ+fX
3DPbA63xUwQGn5ydGUBF3/2UjuElQEmU/NreIvi3zsUvt0Z5OZSZT9jWbyYzChHR
3Cfa8+zTZVCjWY5dR372YIh2lr9hhZIGd50Sr06gkn1/pg5CxrUvq8Ex8QMl2VOC
c61+DGoJzuuLDiwQpoIsgbEnNZBvHKyGLTAhavvnqOy/49YeILvD4EXcc+4WtNRn
W9jbfFjJA1j49LO82nOM
=R8pY
-----END PGP SIGNATURE-----

--Sig_/R0PZF6PRl_EPEso8w9yGGav--
