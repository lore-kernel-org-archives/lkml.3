Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbbALANs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 19:13:48 -0500
Received: from ozlabs.org ([103.22.144.67]:48307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbALANr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 19:13:47 -0500
Date: Mon, 12 Jan 2015 11:13:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: manual merge of the usb-gadget-fixes tree with the
 usb.current tree
Message-ID: <20150112111339.591e766e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tjuTYxf3o92sNdx5LC8zX6A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tjuTYxf3o92sNdx5LC8zX6A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget-fixes tree got a conflict in
drivers/usb/phy/phy.c between commit 9c9d82492b73 ("usb: phy: Fix
deferred probing") from the usb.current tree and commit c818a94c77a9
("usb: phy: Restore deferred probing path") from the usb-gadget-fixes
tree.

These seem to try to fix the same problem (from reading their commit messag=
es).

I fixed it up (I used the version from the usb-gadget-fixes tree) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tjuTYxf3o92sNdx5LC8zX6A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUsxG4AAoJEMDTa8Ir7ZwVse0P/0vyBonkg3HYXAPFJgEWwXqP
BhIYnIXxtA7OEsDEoFRmomqHOl1vt0D2j4SVminFmHpzTl9pQDHOyUo22q3Eliay
rv8ty4KQ0381Q+simIjOaVvDfcXn5OOXvftKepG0EYJANwyW+nQE2/ASbqGx/O+p
PqxO2xrbwnvMWBPIMWSevSPfX9yyMwiVBQ5MXX2EAHnnO1ANRH5Zx7BAknxpf4Wc
zpmUXDB/br4DuX/OCfVpflrfKKz5946GptMUKZDrg3TgZtH/mE/vG+TIRqo2XJOn
vZjw3woAIRm8YGGOwIJE1adI5F4nGH1q6/TcZrLYKsT2TX+TyiMFv+cvW4/fk2wN
X/dx9QKQHMQHeNuYVgjhLOkGu2K3oMEKLCXwrFPOmP4QtcibDx/U0dQRiqrKSEyZ
tj8OfHSRbrCg6Eo7Dw9eeN/FhGNQdCoo5zRXtWW+4irT7zheznjsJE8aqfRFrGTf
e9w62c7KD/GbbGqg0/RbV19bd+oJfqJmUAxBljOYubnz1G42AWtVe9mC8B5skTc/
NMEO+stOaWuZoiPyWLnbzRnn5u5t/+qRB50BZfG25k2QaAToch4Pxr9biug5saVI
M24UbEnCD3jtg+21TGVNdYoGhGuu6wlBRrut8AFC69RT+nE5jKd9umWljwq+hgor
GdQMJrRGjU8T4V/9Cxd6
=2dnt
-----END PGP SIGNATURE-----

--Sig_/tjuTYxf3o92sNdx5LC8zX6A--
