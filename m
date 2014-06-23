Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaFWKfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:35:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47865 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752335AbaFWKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:35:15 -0400
Date: Mon, 23 Jun 2014 12:31:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: wim@iguana.be, Guenter Roeck <linux@roeck-us.net>
Cc: Arnd Bergmann <arnd@arndb.de>, dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140623103142.GB19730@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rsGyAQ90QqnfMsmV"
Content-Disposition: inline
In-Reply-To: <20140522211207.GA28704@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rsGyAQ90QqnfMsmV
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

So, this patch finally didn't make it into 3.16. Great. Now, we can't
even reboot the boards.

Given how it's just impossible to get something merged reliably
through the watchdog tree, I guess I should just start merging the
patches through mine?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--rsGyAQ90QqnfMsmV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqAIOAAoJEBx+YmzsjxAgMVcP/0+y55rqc1cy3QDovncKP+S/
CIGgk14dF+sgBuE/3KDsDTElb81Qi0htwFJaGic5wpN1AT+LzsGvsKmGvLa3rfCI
OSniWkDBlWMDTjE/sUdaquxVffiH0tRoOUkJgsviNDm46rN02oWYeUXTGAi+p6cp
gCwLH8Y4XepAtvNtwedEbbScRB1T/WdMYEXwXwnozB1mEZ/Al8jnn53I9NoZtNWb
vmPfsJuCsV8rA2rHBmPP8XcWqdokLcP0UixXTb5nsXaRBUuNym14qbP1WZLnNu44
UdWkJVcHhQLLrd0edMISeh9hAPtJYCbdRwQExFojROeFtlbIwWa0l8Jix27dQBPH
JsfFoWURcKsRXs5pLaU2Dnpftw1+mXRopLgxoige6USpeiXicoQskylDtbjMPW/Z
sHgVyj5Q/4xUe5DUN4zEPy1aKxWtS8enSZpPYGDWkXcHXfE60bglw9/lm52wJ4eu
kUNar9O7khCd+ziw4w1su4HpbmwlNapFcMl8r5yz0YYznOTwSFeY+D/ROYcQOQ3H
pBATD+DaEM3btqK/zZsIORl7QaDD6Fji2H/QQ6ux9cxri940Oei1xn1OAP0iWQj/
bh3fKqI6n6M/4Qda+gxtf6hPZhGLSK+vDcERi+okMdT4BkxuwwJuWOZVBByr1B7x
jawKxeY//RrfWAhMK+Xq
=ptEC
-----END PGP SIGNATURE-----

--rsGyAQ90QqnfMsmV--
