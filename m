Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaEVVAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:00:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49165 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbaEVVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:00:04 -0400
Date: Thu, 22 May 2014 22:56:06 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: wim@iguana.be, Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140522205606.GF27329@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522213943.7649e304@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bJBxXK1kQfYiHILX"
Content-Disposition: inline
In-Reply-To: <20140522213943.7649e304@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bJBxXK1kQfYiHILX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 09:39:43PM +0100, One Thousand Gnomes wrote:
> On Thu, 22 May 2014 22:34:44 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> > On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
> > > On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
> > > > On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> > > > > On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > > > > > Most of the watchdog code is duplicated between the machine res=
tart code and
> > > > > > the watchdog driver. Add the restart hook to the watchdog drive=
r, to be able to
> > > > > > remove it from the machine code eventually.
> > > > > >=20
> > > > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > >=20
> > > > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > > >=20
> > > > Wim, do you have any comment on this one?
> > >=20
> > > Ping?
> > >=20
> > > It would be really great to see this in 3.16, and we get quite close
> > > to the end of ARM's merge window.
> >=20
> > Ping?
> >=20
> > Guenter, since you seem to be the only responsive, may I suggest that
> > you start merging patches and do a pull request to either Wim or Linus
> > directly during the merge window?
>=20
> I've yet to see anyone explain why this is an improvement over the
> current situation ?

"This" being ... ?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--bJBxXK1kQfYiHILX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfmRmAAoJEBx+YmzsjxAgYcAP/jZBsbW8nzumbY6LIe5rpg85
N1wKthrVW3VtoyqSubYnLvyTKrrnRC+i1p0EHF8TU4Jo9AK/QRNRVrNHQD4MN0uy
e+QjXKJKi5nrqwLxd2Vx4A+LG1n52PNkmgdZ3ZTQuI2D0oiUmmoTAeXTQN35Ef0E
qc0ZcmJZha+EM36oPE3xhYB9mcYVEbB2t8V7cdFP8bapZEWsWIcsNsOs0YyqlydC
9qfuleLHkuTsDdY/Q8fWhhZJhW9jEJ1lpKqP6zpViMbH7GVtdiNbyvodZ5/MChc7
axT51/aWvMju9F/mB5UP+MBUeCjqNlHZfVz0D/U3fU+h12W3lwZ/yXl/lfxIrR7E
M4Hi1oe27ij6GctDg0h6XvAc4S6PvljPw7VXk0sd6J1FncZ/mX7pPwzDikYa4YG7
hfXrstHVWhrv52/dk7B+CDeShJTuvQXLWj4Y/VMe16oRXSc4Hw83krlI/8AyReTz
Nf9QP0QLDCdUMlh4Wgz96H2E7Vom0rEXN5LEPnkMgyjUodxB7Z9AQtgNpJIj8a6p
b0OQzt9HuMXniqLsQS/NEctm9xG4Ey8Q5ANMfKf1BhS8r52pT6ZhpCDce6YvxDWu
F72sUs2mIZlxkWhcHGNZ9RoVYg9YlInEpagtiGIbJQ0vBW13W4IadGtRhBMElP70
ZQtnmFzz2MBrD7Z05iBL
=IBGy
-----END PGP SIGNATURE-----

--bJBxXK1kQfYiHILX--
