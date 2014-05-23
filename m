Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaEWIfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:35:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51582 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751868AbaEWIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:35:04 -0400
Date: Fri, 23 May 2014 10:33:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: wim@iguana.be, Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140523083319.GA22869@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20140522211207.GA28704@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 02:12:07PM -0700, Guenter Roeck wrote:
> On Thu, May 22, 2014 at 10:34:44PM +0200, Maxime Ripard wrote:
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
> >=20
> I had prepared a pull request for Wim last weekend or so, but then there
> were more patches piling in and I got distracted, so I didn't have time
> to actually send it. I'll try again this weekend ... the kids should be
> busy learning for their finals, and I'll have Friday and Monday off
> from work, so I should be able to find the time.
>=20
> As for sending patches to Linus directly, well, Wim is the watchdog maint=
ainer.
> I manage to upset enough people, and would not want to add Wim to the lis=
t.
>=20
> The patches _are_ in my watchdog-next branch and get some coverage from
> both my auto-builders and from Fenguang's build robots, so while they are
> not in linux-next, they are not completely in the dark either.

Ok, so I can merge the other patches then.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfwfPAAoJEBx+YmzsjxAgW3MP/1Cp1j/QA2RTS2PmgkR89wmX
kY0hbodbMVjLTU0gxuQdLBayjAmZ3HUSx1nGwa6/Lg3AT+Df/EgiUZix3Ao/WoIa
UEnj9p/YihT0u/nJhQbySQznzRdPyStbD1QrbYp1EMXvK1pEDGDPrFpsv7kFnX62
tvKk096aWP4cRZKszUOplhbkLxJUoyxNWFwK+dglMaP3tNPpgsUo3esylreWhSTf
ZCQ9VLfRBn3wYAEzvqqj7FsutKwxNLz/wpR74KSD4vk0dtBsfFpc132J3hcjZiaO
melHff5xUuGYql5TiADB7F6j2RYGcMuhF0WgnCeVWQSZbkD65wkPOZNzlf33nc8I
FCYPcjlKV87+GTwoi3EHZRls9KPR0owg9MOYmm6XZIDmNyuW9EjM4DQbDhcPLeZA
DEcalzwxaG4rqlYyeiB+c85IbidWrotQLRAwBZTi68rYzEwZ2PB6OP3TseLmsytX
MXhtX/Z6Yid8nLcPKIw+zSW0RApLQvBZHygVPJak5j8h6VzVsBKYFDEEsi6sdrDA
y8j1HY0S3j12i1RYVmxSBgF9GJJAd9DGrLgXUWx8EFGtedasvdKEQkWn/oaTVRbR
inKKwnS9ph7zuE1DjBUNi0BhbPFbOKpzZA4SphuOmPSwaAzaJUmWjesPyrOSIQPn
uNNj0tI7nXw/AtCWdd8d
=nvIv
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
