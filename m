Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaEOJOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:14:32 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54847 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaEOJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:14:27 -0400
Date: Thu, 15 May 2014 11:12:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
Message-ID: <20140515091220.GC6434@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
 <20140515075102.GE5952@ulmo>
 <4de1d09b7873e012e43525c1f8ab9c66@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qbvjkv9qwOGw/5Fx"
Content-Disposition: inline
In-Reply-To: <4de1d09b7873e012e43525c1f8ab9c66@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qbvjkv9qwOGw/5Fx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:24:39AM +0200, Stefan Agner wrote:
> Hi Thierry, hi Philipp,
>=20
> Am 2014-05-15 09:51, schrieb Thierry Reding:
> > On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
> >> From: Stefan Agner <stefan@agner.ch>
> >>
> >> This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
> >> evaluation kits.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >=20
> > Panel patches should go to the dri-devel mailing list as well.
> >=20
> > Also a patch was posted only yesterday for a panel that seems to be the
> > exact same one as this, even though the name differs minimally, see:
> >=20
> > 	https://patchwork.kernel.org/patch/4175251/
> >=20
> > Adding Philipp on Cc so you guys can work together whether this is
> > indeed the same panel. The only differences seem to be in the vertical
> > front and back porches, but I suspect that either settings will work on
> > both Tegra and i.MX.
>=20
> Its etm0700g0dh6 vs. et070080dh6, Philipp's panel is with captive multi
> touch, (hence the M I guess). The panel itself really looks the same.
>=20
> I found this overview of EDT displays:
> http://www.dmbtechnics.com/scripts/passthru.php?id=3D7
>=20
> There seem to be quite a lot variants with the same panel...
>=20
> Regarding timings, I just checked the documentation, Philipp's timing
> really matches the documented ones, I miscalculated the vertical back
> porch.

Okay, so that means that the panel works for you with the same timings
that Philipp has in the ETM0700G0DH6 patch? If so then I definitely
think we should be sharing the timings in the driver by making the two
compatible entries point to the same driver data.

> How do we resolve that?
>=20
> I would suggest that I split out that patch and remove the et070080dh6
> panel and send the other as a single patch to the dri-devel mailing list
> as well.

Yes, that would work.

> Philipp, could you add my display type (et070080dh6) to the compatible
> list of your mode/panel entry?

I also noticed that Philipp's patch doesn't actually introduce the
device tree bindings, so that will have to be added as well.

Thierry

--Qbvjkv9qwOGw/5Fx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdIT0AAoJEN0jrNd/PrOhARoP/3+sfqWil3n784t6Iif8lKR3
lR9uJGCRtop/QXlaPx5tiGwgDAwmR6tQkVcB0U/JzTxOJikgqYgQ17CS9prFVCRG
s37jrsaPWWfs7CWI8ThBc5VI6fwo9BOwgy7/ARVkLi2GjUD3d8BGEQ62BslbznKa
nG/uGqCEK8W+sFnv4ek3CIykGdB0YYtJW65aJYzbZYlklKptHtzLK+9kEaOXEFOU
rIZuUzbr/iEtG7hEsrmLCoE8vFI3k7INwka1v/FZLpDeN69OuGW5cSbFu1lyLiQk
QzveVW8AtW1gcbXP+4TPD0rj0E0HU+JUxhWdx8HB/NjBikg+hU20Qo1BsyNkBv/s
5p3MZ9RtypORN1uJklsWq/oZZ8VeRyu6kyVyvuc42h9Ej7/N9rI7/prA8F4KBWDN
9ABopZxwiPhGHYVh2q53Dpz2RgnCx+F7OJ9xb/Z3VKXYqyHDLp0Rz8iIpuChuC4s
a/pXeF/kgqsjUdgMVzPsG+uBKUe1PxLaNjynoEmdF3kLsRdghfXztxkGOA4rn2+b
gORMhOAy1CR9Vsqu8puN76k0bXCAZfPSNLcdHQTHt+T1P7Hyl/PR7sttYRpGQUnL
4+GEyB1UKipt+AM38yUD0ED0+jnLvgaMp6giHjA/9lE3CIz1+PKYbNjmtG6xogp4
KmiJ0lR4W91YZkznALh7
=HiEb
-----END PGP SIGNATURE-----

--Qbvjkv9qwOGw/5Fx--
