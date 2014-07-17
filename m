Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbaGQPJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:09:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58483 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaGQPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:09:06 -0400
Date: Thu, 17 Jul 2014 10:08:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.16-rc4
Message-ID: <20140717150856.GH10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404153635-10868-1-git-send-email-balbi@ti.com>
 <20140701045957.GA17105@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ewQ5hdP4CtoTt3oD"
Content-Disposition: inline
In-Reply-To: <20140701045957.GA17105@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ewQ5hdP4CtoTt3oD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 09:59:57PM -0700, Greg KH wrote:
> On Mon, Jun 30, 2014 at 01:40:35PM -0500, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > Here's my second set of fixes. Note the revert of the patch Michal
> > asked to revert.
> >=20
> > Please consider merging to your usb-linus branch. Let me know if you
> > want any changes to this pull request.
> >=20
> > cheers
> >=20
> >=20
> > The following changes since commit 5d881802c407d83c169c875dad88fe2bba06=
6c33:
> >=20
> >   usb: musb: core: Handle Babble condition only in HOST mode (2014-06-1=
9 15:43:07 -0500)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixe=
s-for-v3.16-rc4
>=20
> Pulled and pushed out, thanks.

looks like this is still pending and I can't find them either in
mainline nor in any of your branches.

cheers

--=20
balbi

--ewQ5hdP4CtoTt3oD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx+cIAAoJEIaOsuA1yqREvicP/0I53QDO7LM8fkOg/wvcmns3
sqCWDHlbwiSzUT7vx8i5J9fNU130J1ZpWYxDG7epEFnFTkgWKvEgmGkeX0Gf9QkN
6hhvDOxp9P2ffj6n1IekNoxZ2NCLdInD9PJbgqLZVSl43H04BU+DNkuSYg44rNfM
9ZivCQD9UzO73bLbeWEUZRE4D04/aSzWjZFOfmzzgx+EjolEIJ15PYzrsWyXycx6
qfkMYbWlIg3hU594Z/TO/47h0B7DOMamH/8IfkZ1TxTFc31WwxkLan8zF1YuJUzA
648eW57nKRFWp1/uRuHunloESNRHaNsntbVtH0/aJi/KYi2c7ME+kgw4aQYLDsDm
F69o3ATe9YGy7HPen2zUu3xtVBA2uGbIzxosO1W9+d+My87dGzBfOSxvxoeJ+8CG
OtAp3aZ3Nn3X1RuLeQ17030UUuezm4nwn3yIfvnSikEETvOjW3WAmieVVF6lewUx
3K3GG6LnR7eHVIGUFhikZyNyiYHUHiFQJndx8kSQF0YTcir/SemEN9/NMSYGv3WO
Vhmnk3mLy1APGry848pdCAIQBRJwENJzuVOu9W/Zm5YwBjade3151SUciK3N0t4I
ulW4MZSo4x7qxHpr2FXF47j38q8VHG4yl6DFp4M56nc9vT3NZ019NWVjg3L1ARqo
u2bjqf7whYUALcIrlxVK
=tgZm
-----END PGP SIGNATURE-----

--ewQ5hdP4CtoTt3oD--
