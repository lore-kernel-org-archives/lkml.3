Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaKCQ1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:27:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58446 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaKCQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:27:53 -0500
Date: Mon, 3 Nov 2014 10:27:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
Message-ID: <20141103162722.GN27425@saruman>
Reply-To: <balbi@ti.com>
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
 <54463063.80207@ti.com>
 <20141021172223.GA12943@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VnOTrGv5LmZxna7m"
Content-Disposition: inline
In-Reply-To: <20141021172223.GA12943@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VnOTrGv5LmZxna7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2014 at 12:22:23PM -0500, Nishanth Menon wrote:
> On 15:37-20141021, Mugunthan V N wrote:
> > Nishanth
> >=20
> > On Tuesday 21 October 2014 03:30 PM, Mugunthan V N wrote:
> > > Adding device tree entry for CPSW to make it work in Dual EMAC mode.
> > > These patches were tested with DRA7 hwmod patches on top of linux-nex=
t.
> > > Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pus=
hed
> > > my tree to [2].
> > >=20
> > > Did a boot test with CPSW and ping test with suspend/resume, the boot=
 logs
> > > on DRA7xx EVM are posted at [3]
> > >=20
> > > [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cp=
u-idle-suspend-dra7-omap5-framework
> > > [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/dr=
a7-evm-cpsw-v3
> > > [3] http://pastebin.ubuntu.com/8613072/
> > >=20
> > > Changes from v2:
> > > * Changed pinctrl comments to hold mode0-name.mode-selected-name
> > > * Changes slave numbers in the pinctrl comments
> > > * Added cpsw and cpts clocks
> > >=20
> >=20
> > I have not added support for dra72x-evm as it has only slave no 2 pinned
> > out and having issues with bringing up the interface, need some more
> > time to submit the patch, in the mean time I have submitted dra7-evm
> > support only so that people can use dra7-evm on linux-next.
>=20
> Quickly tested as well:
> http://slexy.org/raw/s2vISJxYrR
>=20
> Please feel free to add:
> Tested-by: Nishanth Menon <nm@ti.com>
> Acked-by: Nishanth Menon <nm@ti.com>

I've used these patches with X15 (DRA7xx-based yet-to-be-released board)
with v3.18-rc2.

Tested-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--VnOTrGv5LmZxna7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6zqAAoJEIaOsuA1yqREFaUP/32dgxZtWZYEVyl+myp/M3Hb
E1zqqKezV8X+YGNRCUUbZc+1JuurVm68A17ElOwz8y2/wqEIzwvGAd+cbV/elkcz
NzksTPP+oFEiWV1YShX1xb08CSfjWMk2U82kC4/i5zTVWlN+1PM/PDYXXKCU2WMK
lZf6oNfINoxXxK9+1gvWqq7mtUjYrh96Ch6eu7TxBa9zR2DeL8BsuizpavIwcO8D
ckSJon60x7j8ENtjNZPss5cPykT9cEYheu3StM6vrQQiY39X1/z6QHhN79jzkYPy
VYpZR4hk4DEojZ2OwnBkD332DMrE0f9XL9YIO+JHlzCjBzZiABnQcGZ+YK98byka
q/m8ed9vi9oJWm4tQ7xRrqtmV9S+HNGms7BqC5GpZuOCN98THQMQ5L0EDnf4Nk/n
vA1YsEIo6KhRt6RScD0Zn5XKbA9BxCiCrmCfexwsLDRsTHfjVDAp6Axt02fpeV58
jsM4Q4heL8gj1vDTCiQ/DuPoTuOugx22Tqp5gn+v62rk49bYZHyLxQWOtGfjrCMC
amHTwuZKAqkORu5Y9GQaNFozP54EqQTQ6zxRXYPOlX3OByOS6g3gK+hVEeGqP3bX
HjGdDTtOXOz2l0Jc2u7tZnxgjqa/Ff0+t+1fDN5a0znsmytg/9HQXAKGEWqQQRnX
xRArRJ8jQnXHqqrmXRk2
=cT0+
-----END PGP SIGNATURE-----

--VnOTrGv5LmZxna7m--
