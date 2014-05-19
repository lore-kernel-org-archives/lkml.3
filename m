Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaESPF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:05:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52714 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173AbaESPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:05:25 -0400
Date: Mon, 19 May 2014 17:04:22 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: wim@iguana.be, Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140519150422.GA27329@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20140515091123.GQ29258@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 11:11:23AM +0200, Maxime Ripard wrote:
> On Wed, May 07, 2014 at 02:33:18PM -0700, Guenter Roeck wrote:
> > On Tue, May 06, 2014 at 09:44:19PM -0500, Maxime Ripard wrote:
> > > Most of the watchdog code is duplicated between the machine restart c=
ode and
> > > the watchdog driver. Add the restart hook to the watchdog driver, to =
be able to
> > > remove it from the machine code eventually.
> > >=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> >=20
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>=20
> Wim, do you have any comment on this one?

Ping?

It would be really great to see this in 3.16, and we get quite close
to the end of ARM's merge window.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTeh12AAoJEBx+YmzsjxAgwHAQALu17RQDqV1h2ZMSjUA9/NV2
M9ifNpE4GAHL14FxdMPSO5/wTyTSIjdHJ+czZgBSjsopQgddNIqR44JevOzYSRPc
/Y9w0JiApGg561q3Y1kqhVoAolU7sFUSdVP+imO3Prr+NrK/WvVYKFXBekgdi6br
T0xbKu7JC7KGx/XD/wOeEkO3nItNpxGkFoj2ewbs2WUZNecn3/01IL9GoxM9ox50
Oijrx45TA7Ldwe8Bks74gv65RUik+FjeX5TslrZPYYrj7+io1sfxRU42XkbTVx8j
x3gJZkNFJlHmn6XvqSczDckyaxwnDUdKUVaU7XK6g6SQxd9S86v0AqpTedAudSTL
70SHw1GEBcJ39BbWkr4NTI+22ybC53mRiEk/L3KdwW4dXCco1VRqAUM5ZW9ILkL6
cglMZIp1vTiqL6FD51K5IbdLfqR50ctZjzftpN7NyevHgCdbqNb8MwXFUiLaJQst
QeRsmpfKU+NHQKvBIPNa44VsCWRsw5/nF6VG3c7g0gVt/mRKz/tWfllgejXynWLS
tMQbZ67x/9CNNV2Nvdg8cyXGIA2CsOoT9lv62o4XRnYxY3aquJYXyh1OGcZnNQgt
SX9UTthUJtjGv9quXG1qwdqTOgPOpr7P6Ddgb1NxHBFvqmUK75rTqsVbHosK0uw3
Vlw+D/8mfcmCvASKYXjm
=ccwN
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
