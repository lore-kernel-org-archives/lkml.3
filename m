Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaLZEil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 23:38:41 -0500
Received: from ozlabs.org ([103.22.144.67]:47944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLZEik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 23:38:40 -0500
Date: Fri, 26 Dec 2014 15:38:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: add the omap-pending tree
Message-ID: <20141226153822.20a6bcfe@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
References: <alpine.DEB.2.02.1412191715230.3102@utopia.booyaka.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/29nt8rEGUk97a1L2RmECLp0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/29nt8rEGUk97a1L2RmECLp0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 19 Dec 2014 19:28:08 +0000 (UTC) Paul Walmsley <paul@pwsan.com> wro=
te:
>
> Might you be willing to include this branch in your linux-next builds?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending.git#for-ne=
xt
>=20
> It will include OMAP clock, bus architecture, and low-level power=20
> management patches that are planned to be included in pull requests to th=
e=20
> OMAP upstream maintainer, Tony Lindgren.  He in turn will submit pull=20
> requests to the arm-soc tree.  The objective in including this branch is=
=20
> to get these patches integration-tested earlier than they would be=20
> otherwise.

Added from today (called "omap" and with you as the contact).

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/29nt8rEGUk97a1L2RmECLp0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnOZGAAoJEMDTa8Ir7ZwVTMIP/ReBdMiSlPzSi35dWsEYhBse
OoJDE+9/AU8NHdhQrK/9nYhPV7NavhQ5M6/qmUBpA+nx0pgc9NJ/AWO8J1+YJ+Zh
dqvnnpX5Iu6NHCLIeoMUp7+UmZrNBVzQ6cMl/CqVVICWUT9j7SpiM4pDAU5iBiBH
K2khmzlJcKSBKcClKqppqmoSeZohrj0FcqtSD6RcwRD9M7gdyEepEdTsb9WlQ6Hc
+ng8nWmAN3GiFBkqJRWUNEZPSCDNqobwCuMBQo+Ugyef6LSCoquDeQ/UIbGqm6qP
Dgkj6zRLqufKtFUNrmoroZAukJq3JHvJ1lDuptGNQoPRtzR8unS8xAGYBcBY9WjJ
QPy9bkWUirzU5ZXheBZXTfEPl5FBApgUJjXkwF6lwtwrtvQGtpImYJBVMp5YR40U
r3ntfip0LhGWsExlOhkaKfAJgdolSCB8804m/eSBHqBZNdd3a69dMokSVhTk91uM
MuuE+Oq6JTLek6/cnF4zGhM2X/a92NyOZVL/0oRI8xtVd81TDGxdAJORrz1vx0AD
sFwskKCxCZ/Ce1tlLItfBTbKaLji0C5TWYfNUUU0zaBzDgtPcrIRHY5qWVuugiCl
vYO2sdp9vAtVH5KeHt9ocJQRjnJMWsZse6wlmJurHaUW68juYz9txSlLDyeijvV7
IACRfpvGN6GfXefGmaR9
=1VaS
-----END PGP SIGNATURE-----

--Sig_/29nt8rEGUk97a1L2RmECLp0--
