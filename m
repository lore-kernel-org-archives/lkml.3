Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaIHN1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:27:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55950 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbaIHN1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:27:34 -0400
Date: Mon, 8 Sep 2014 08:27:07 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Chen <peter.chen@freescale.com>, Stefan Agner <stefan@agner.ch>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20140908132707.GC22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140908170212.133cb6e0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <20140908170212.133cb6e0@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 05:02:12PM +1000, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> Documentation/devicetree/bindings/usb/mxs-phy.txt between commit
> 36687e305651 ("doc: dt: mxs-phy: add compatible string for
> imx6sx-usbphy") from the usb.current tree and commit d0ee68b59e6a
> ("usb: phy: mxs: Add VF610 USB PHY support") from the usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thank you, that's the correct fix.

--=20
balbi

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDa6rAAoJEIaOsuA1yqREgOMP/A5Cpdp0BdXbheAap6mru/Tp
nclzTxjosG0zXuLo0EMq/HyJHLnHdbZyA5HwYxegmvU2Tz8q3oMEFtlswgJUpYHg
h1r31eCxalV1DKyXx5Mh8Zo6vRYk2jO2Nmy/FZ5MFJFUF7UtR1yl42b79K4F2YSo
2oVkXib8lukktEpOZeTdmB6+xhWYJBGjW6MoxgwjEc3x6r5RvNz0S0zK9q22/s1V
TQxvrscFcmFI5WRbfcRbCRBaCHf8SwWqxn5EKhLWVqUvFh7nbgaxUwUg4YBSiPs5
R1Z3nG7iHr8L26ikG/p9HebvYVExa7cl4LpUaXqwsiFrteEjCi9U3GEL3K3fN9Eg
UNTzkQNrUNBVgc5hbyX8P7u7RW6fiT3+vwJaH81hQbOASQ1kre+oj/TNyJHYoWOS
Oz0f8CxqqPMmPMwUXLRbm1vk+qEIlQ4LK7RTNjhGYewXfPrjr77to4tBy0+gy5nU
JyvVYdgCmN88c35wgpydURV0/b4hPw8rrQx0Ps8JuctA2paiva1n3+t+qiY7ne/j
dnwQGsDqZXm1GYFHTQDoC7Oe7kL5v9aRfbUiMME0Pl3AvR+USoR9tHWLO5qc9fth
8Ij2M0pwP/2MaGXsGni0oVNUI2CsG9VYV6mEEHuODlRLJgQuc/1vOuTdW+P7s29M
KaKgiMHaQWxJbq+HTPGX
=br+q
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
