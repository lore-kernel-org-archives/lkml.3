Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaKJB4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:56:45 -0500
Received: from ozlabs.org ([103.22.144.67]:36738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaKJB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:56:43 -0500
Date: Mon, 10 Nov 2014 12:56:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the mmc-uh tree with the arm-soc tree
Message-ID: <20141110125637.30fe73b9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7nhfZn=bRNFbDHLgI3wKewf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7nhfZn=bRNFbDHLgI3wKewf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ulf,

Today's linux-next merge of the mmc-uh tree got a conflict in
arch/arm/mach-at91/at91sam9g45_devices.c between commit 4bf7753b8ab7
("ARM: at91: remove at91sam9g45/9m10 legacy board support") from the
arm-soc tree and commit 4049854c41e0 ("ARM: at91: remove
mach/atmel-mci.h") from the mmc-uh tree.

I fixed it up (I just removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/7nhfZn=bRNFbDHLgI3wKewf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYBtZAAoJEMDTa8Ir7ZwVbUsP/AmmnztFTOUZb1MXSZOImfnc
j2L+k94rpmWkacN3KG2flcr4hYO6g4nlzF7ykhpTwk/Po5cWdYw7o1MI6SAiKz0Y
WiduTK9Fm4AixY1Yku25ZthWSAHrl91yGgxg5ZO0Z1wuV6SXH/GQejIvwcM5k/9y
sfnWoXQprX/NWxEDkfJKam5ofw53PtXTahZoLc+2Kx2dj11P62Oj7VSqBCWzLPGo
bTZ31xxp1sek9elHNVQBHDq4mmiNZu78s39Wt0LDD2eFw+z7ncthYJyYE2/UQzpk
xy2DWGNFkD2oiCMzxyx7OjJjz6I/cClEFYkKkBctf0gs0TDEfDWP9j3iA2pGknzZ
vthTP7ZU9j8Y8Ms7SKHIiR9XO7uiGPoRpls1ww7w3NEOzl0RHHPsGnxe1rX69CvZ
ADycKB3Ci38lBWAAu+letPhIryb/2Ym5i0MwkXQx2x+nazkxX9HcRQXxXzVjcNcR
/2SR3zbExrBP79VtAVGTHHL3QEXry8TtJe+4LYn07Qp52FRJ7fAMHLRQ159Jmh9h
DPcif0ANBx2XQYpVTCOEIE2VYHtEsrCF2XtJO02RQHbyoBTAIYvO3Ap1oWh1M6Vh
Bgoy4NTcndXTyPY7cDBEJ3s1b30Wm+XqTHNrhdJTG6ZOU9fMx+cVSuozkoyvYUqn
BbRLyIK9kJusr3mn2qE+
=ozUW
-----END PGP SIGNATURE-----

--Sig_/7nhfZn=bRNFbDHLgI3wKewf--
