Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaKEEbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 23:31:52 -0500
Received: from ozlabs.org ([103.22.144.67]:35153 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaKEEbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 23:31:48 -0500
Date: Wed, 5 Nov 2014 15:31:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Sean Young <sean@mess.org>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-ID: <20141105153136.2026c4b9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MwwQOrG2D1+uD6.FVtQtPr1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MwwQOrG2D1+uD6.FVtQtPr1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/lirc/lirc_igorplugusb.c between commit
3e5907e695f2 ("[media] lirc_igorplugusb: remove") from the v4l-dvb tree
and commit d82e62deb51b ("staging: media: lirc: Remove useless cast on
void pointer") from the staging tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/MwwQOrG2D1+uD6.FVtQtPr1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWagyAAoJEMDTa8Ir7ZwVVdYP/iWWGa6qQeEpvHzYDwMh93YE
buT98Xu5paZn6KwtnvkMd4i/VXLWBiBr2Y+x0ZOAK38l4H1NcMdA3Av4ANOsnD/D
ZktOH2gjTc5jlZk7MGySH/C3DyLFNUdvjHuapVrtzygfLSUvPa5QIcZYzU4On3L2
cQ0BInSmPnN4DZgiSGzF40qBlL6Wg/M9KyiX/kR0MV9KGWfrwHNJ6zS6LhHMRT5F
k56Knzn4kLtB7Uzj8bz8NwjzZ7hMHGsX0Bvd+9QykEPg44uaxWLaO0Ntk++5DHwx
g4dRws5fGiHBzS+xaeULfz5/RgEZdt4h+w1YxtueMwcPR9uNu6ktzfhlcJT9zUyx
Zc9x5xyabsqLCmhFybrl2/KLxtunuq3abbUqhwturfl4X0qXZHc8NPVVWcH1vUbd
9DDOCU6JoAOVo/AwzB9l65MdyP7WcfiTcT+rq8A49JVSsDR3ka0e2RI0EiXYYgPe
DNBJTXF+AvqAo6MLIG04q4rRtzuDWcmsmnazQ9+yY8pIUyBJYPKKTTNw17FhHTNI
uvq9MXH+7ja76DEokcbUw5qwnxF2JgNjDYl+Nques/MKZOTrcBAsj0hcyKVDMZB0
Hrok2bMdDLJVpjdrrnx6fUt3H1TEXbHeKFf0hwPFzeaDPR59nDI66qLrjAjzL4m4
ULZD5XrWrVnIF5Qcbid9
=AtuV
-----END PGP SIGNATURE-----

--Sig_/MwwQOrG2D1+uD6.FVtQtPr1--
