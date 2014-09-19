Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaISKkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:40:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755777AbaISKka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:40:30 -0400
Date: Fri, 19 Sep 2014 12:39:59 +0200
To: Chen-Yu Tsai <wens@csie.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-sunxi@googlegroups.org,
        Varka Bhadram <varkabhadram@gmail.com>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v5 0/2] ARM: sunxi: RTC support for A31/A23
Message-ID: <20140919103959.GO2166@lukather>
References: <1409025296-6342-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nG9yj4eE4W6Oba0"
Content-Disposition: inline
In-Reply-To: <1409025296-6342-1-git-send-email-wens@csie.org>
00From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: maxime.ripard@free-electrons.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nG9yj4eE4W6Oba0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 11:54:54AM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
>=20
> Resending the sun6i RTC series, rebased onto 3.17-rc1.
> The DT/defconfig patches have been queued for 3.18, and therefore
> dropped from this series. Hope we can get the driver parts in as
> well.
>=20
> The A31 has a new RTC block that is separate from the timer block.
> It has separate interrupts for each of the alarms, and a different
> format for the counter alarm. The driver has been tested on the
> A31 Hummingbird, and the A23 tablet I'm using to work on sun8i
> support.
>=20
> Patch 1 adds the driver for the RTC.
>=20
> Patch 2 is a minor cleanup. This makes rtc-sunxi depend on sun4i or
> sun7i, the 2 platforms the driver is actually used on.

Ok, I ended up merging the two patches.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+nG9yj4eE4W6Oba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHAf/AAoJEBx+YmzsjxAgzEgQAJKQXHWsRlTCrF4j2hmUXTY/
VNsHZmWs39mShphiiKh2kwOtGBTzJ5txl7FOY86UcHpNh+EvquTsmFJPzP1IrBsr
ue42iSgrzNTRoEyMO/uy+NrtB+ECsmS83A4IdObrB/yTYvLhTTdt3tnPJC6mqZqE
VPL4gDHV9NxQMXep5J3LGCGRZR8xtetoIx1YnqZ2qDUID4kkXvJa8TS91NRCDDzc
59SZrefWu8SZUXGetm/jGesRB3mnjFy4BbE5Q2vpw9ppuFjGb1Yik4lVKgWxD53f
9A+RBw9muwfavWeX9eSzYqOuuOrs1G6/P4P7zmx32T70tdOwfKrdF8w2lvUSX7A+
g8gdTx8Pt7dVw2UqE3UuMjI0JoRi5rAtGmoyKIkAmMHOm3D+wi0DVw9Bx3UgTxzD
tLZxC4f+UbuxG6G04vDsdkjwnQKF7zVYny0weIeXzLL0F/1JIZOoQM+EGzWx06gR
TeY3Had8cBDqlNoznJb+tC8eVnkXFHRtLjL7jSpbgByn46agvTf0L2WupeaVInsN
+DzSpuza2sY9CJp5g6nw/C366ddbIv0HAwglMRK9jwWijzrRIdNeDcdqX2uc9lCc
VDxKRs4y9ntPZnpMfEzaugTKhIImHpEGkBfDFBbhbO3C5rZYoJLTIbV1qn6d5c25
9Lb9wbNzOTZSlrDFswuu
=fLOS
-----END PGP SIGNATURE-----

--+nG9yj4eE4W6Oba0--
