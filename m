Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab3LIEMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:12:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60945 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3LIEMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:12:38 -0500
Date: Sun, 8 Dec 2013 22:11:52 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131209041152.GC20608@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> After merging the usb-gadget tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/built-in.o: In function `otg_set_state':
> (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
>=20
> CONFIG_USB is 'm' in this build.
>=20
> I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: phy:
> Add OTG FSM configuration option")?
>=20
> I have used the usb-gadget tree from next-20131206 for today.

I see what caused it, will fix it up with a patch which should probably
be backported a few kernels back. Thanks for letting me know.

--=20
balbi

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpUMIAAoJEIaOsuA1yqRE9fIQAKa7mj9OH/Cz0oskSux3lpJM
r40DhP/gVXiQfFnoNJ1+iKVzkbyI9WEK+FivSjwQp/9ujCM5P47FhTdL+JVUJWn4
c203lR+SzNpZ1T0lIzELzZQTq+BdP8NYggLu47BCFvZSJOs5p5efjxPtG/IT5gqw
hcItv/vGhDGdxZqKzbOTbDFDGzvQx4Km4pbSSyvm6Et8vYiUwJ+4OK+3dmAVPke7
It7A7Gr42vog0Fu3ARrUhQ1c67Jpaja11kTDswhYZ9zpOHq1cEqhf8FWNFi8Q+Ir
5LoDct+p63+teF9RzojkH+zxQ+Xk7m0v1XOUCT9nbvzbNWsSvAyjzUw3iTBX69CP
RCnfc3ClFphtLC4bFQvZizH5nG/BW74+kEkHMAW+C6757KCmsUXqD0W2AbGRnhPp
jyUdT7FrDwNtxqbLPJGRwxfB8MPYAgRCqd9ti3z2CzgtoSS9NCLJ7Jx3bvsXDFiH
EIxfBq0Ux1BflUWSDSVxafImXQKc6ABtQ3gWFjjz2xS8g+rH72AF1W6d+cEa4f2x
z9otsMDBigWz6DuZGxP7f8PihH+P6auQwDTPZp2GGowonCfXA92aGzPnICQKZxlr
rDTEuFFToCE2wOSlZn8rotH1Xz3Bp0orHRwVkqTTwhyNAjeoxW/ICYDpMeS10w5d
KO66Rex3Ou6JLB/VlKlQ
=SaGK
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
