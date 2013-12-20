Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3LTJFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:05:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38322 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754589Ab3LTJFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:05:04 -0500
Date: Fri, 20 Dec 2013 10:03:04 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arnaud Ebalard <arno@natisbad.org>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        rtc-linux@googlegroups.com, Peter Huewe <peter.huewe@infineon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thierry Reding <treding@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131220090304.GA3144@lukather>
References: <87siton6ke.fsf@natisbad.org>
 <20131219164624.GV2609@titan.lakedaemon.net>
 <87sitoka39.fsf@natisbad.org>
 <20131219184924.13a12247@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20131219184924.13a12247@linux.lan.towertech.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alessandro,

On Thu, Dec 19, 2013 at 06:49:24PM +0100, Alessandro Zummo wrote:
> On Thu, 19 Dec 2013 18:46:18 +0100
> arno@natisbad.org (Arnaud Ebalard) wrote:
>=20
> > > I don't mind routing it though mvebu/arm-soc since the only consumers
> > > are currently mvebu boards, but I'd like to hear from Andrew that this
> > > is ok. =20
> >=20
> > I will do what you think is the best.
>=20
>  If the only consumers are mvebu boards, I believe it is correct to
>  route though that tree. imho.

We're pretty much in the same situation for the Allwinner RTC driver

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/211849.=
html

I'm fine with merging it through my tree, however, we still need some
reviews and an Acked-by from you.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJStAfIAAoJEBx+YmzsjxAgMoUQAJsMNgi8nrHgAMP/GwpttNv5
gAozFxL4l8eLS8p50r8Zq3dIE32TON567augOYMZeRmfPIW3HGbZVdqMBidiv6bA
mDjaTD9ElRs/QNLQ/s55rnoBDS9KJ0YoQ7P2UanJo9UF6HQuzMcxbikRBY6lf9A2
86NjA7m7WCg5y2M5dS9NJiUVbmdNxjfRzXHwwYCO36gvA/AseObGu/QhnroK1rdu
jCzMBw6oCruYRHPI/4jupaqE/sld0DzXzju7dKRyp0brf9aRY9pbo4IIxu9UR8+f
xXqVzFx8ps/NyaoNKLguwIQViWc5XV6OlgMt4OyAUFNJoHI1blaldHcmsFtaJZ+l
+aagL8WrYfNthYgSCFj51GC91TSt0SG+6BXw0mJrTILlGiOk6yeqUncsQwjQm/Qz
bvHGHOkrNMp1XtNFBmn/Uqu0SmF3IWUWtRkYVaLmSD3UNrH4XYhzDSO/hJ9i6DSW
mWl45JPpP0LmiF27VYKUdSZZGQakIsTa84tsJhFXj/rqKtNypN/8xTdClW3weA6Y
1ll6J+CMdlXGozuVtSqhLf99e5MuCwGB1STno3aYKJweexmt9Lj/okTGPqfA8c2a
41qtuBKm5s5Tbgud6d9dsmj48UoItdV+gK+hT1yMExtubsLQmjoA27fI3AuPDEe6
QDwrnYrvRVMvybmqZXBA
=2c7b
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
