Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaEVUfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbaEVUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:35:05 -0400
Date: Thu, 22 May 2014 22:34:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: wim@iguana.be, Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140522203444.GE27329@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CCAbHT5wTCfICpGW"
Content-Disposition: inline
In-Reply-To: <20140519150422.GA27329@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CCAbHT5wTCfICpGW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
> On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
> > On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> > > On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > > > Most of the watchdog code is duplicated between the machine restart=
 code and
> > > > the watchdog driver. Add the restart hook to the watchdog driver, t=
o be able to
> > > > remove it from the machine code eventually.
> > > >=20
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > >=20
> > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> >=20
> > Wim, do you have any comment on this one?
>=20
> Ping?
>=20
> It would be really great to see this in 3.16, and we get quite close
> to the end of ARM's merge window.

Ping?

Guenter, since you seem to be the only responsive, may I suggest that
you start merging patches and do a pull request to either Wim or Linus
directly during the merge window?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CCAbHT5wTCfICpGW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfl9kAAoJEBx+YmzsjxAg1ZMP/iiR/jK1qscwk/XaOPSi+Lkk
gEQS3PiozzBeNrPuu8AEm9g5Be7FN8aCyss0veTpvAqlIlZnI8gSX1e51TZgFJeW
cQ3gH1jm6ksBVmpjsOwwn1jfVIvT9H1u0fKNXV4mfdVtjwLPmEdkvaH0W86Wr1pQ
T99pwrOy2i1/WKIOVjN0YfMGBndOI956cNtq8Jh563EannDBWixFqm4bTgpBJjW1
2X0RbOlQzMCOahpJQ50UMOd6mhLJEWXKuEzH6OTE8rd0sFQm6JU1HYm8Il7Sun45
o2oVSaMqXGrZ4xhCVdG17O35HODDiZifVNpzsb04jH4ZqstfbWOvHox7soB031uC
B/F+Ey8ckRndcNUk+a6l1DjEvoelfVOtKcG80mDXCdqs4ECPQ5aC4N1VYDdvhfch
kwYb8p6rHeh8/w89c0sMGXOUuTHZqJLiTr5vNRazYcFazPqjG3S69GPwVieWyZjp
KsDQ3VyGprSTCJJj+q5sHsrkO95sUKGfnNEUhld3B0nYdBaesKF1aqm6KjeGN0Bk
nznA7/o0TcjrEl/8nRzcjYOcTykuEDQySFuuAp0KPk/ENmI81xoWVarlJQOvrKv5
qUANb/Xeukjtl0WYOQStYtpiDTpiUvtRX7tsKmFJVLan/4Z1A1/doMMQNHDhcT5I
/6KO3NlZAhxl0FPdHM+2
=1b1s
-----END PGP SIGNATURE-----

--CCAbHT5wTCfICpGW--
