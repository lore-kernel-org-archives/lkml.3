Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3HLImA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:42:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755679Ab3HLIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:41:59 -0400
Date: Mon, 12 Aug 2013 10:41:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: kevin.z.m.zh@gmail.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCHv3 0/4] Add support for the Allwinner A31 clocks
Message-ID: <20130812084157.GP2911@lukather>
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nF5CeAc4QNWHTmva"
Content-Disposition: inline
In-Reply-To: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nF5CeAc4QNWHTmva
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike, Emilio,

On Mon, Aug 05, 2013 at 10:42:57PM +0200, Maxime Ripard wrote:
> Hi everyone,
>=20
> The Allwinner A31 SoC has a quite different clock tree and structure that=
 the
> other Allwinner SoCs that we already merged, so it requires more work tha=
n what
> we had for the other SoCs until now.
>=20
> It's also an opportunity to do some minor cleanup/refactoring to land the=
 new
> code properly.
>=20
> This patch set is based on the "ARM: sunxi: Add support for the Allwinner=
 A31
> SoC" serie I sent previously.

It would be great if this could go in 3.12.
Could you review these patches? The two first should be trivial, only
the third one isn't and adds the basic A31 clocks support to the driver.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--nF5CeAc4QNWHTmva
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJ/VAAoJEBx+YmzsjxAgfNwP/AniSJXKaNMIRt3S9fKiSa/1
3Z65BbgVTWFggNgw+3adkHz9w3Y3YIj3n76y5EuA6I9Oa4YreUT8O3+zF2Ne+BNZ
Ds5t6Znz5MpPghU17/GEuhav2dimBm9WWCfC+ixlGgAv0q1Oh0Fl4DpQm1FQ3/20
Q7MHLOK4OpQWpti5LlWjHJAQj/ab2WhvJinojF4OFkz1A3eXnrjKStQROkw9DAeu
ZEQjURpx2p0WIDFYfdYJardMk5hiyam1/kC4EP46+YG3ext2HnVXqtCgmcJFfAop
nFzqc77xDbBZHCNujH/pB8dkhSG62RTb117EdGDnJ2+omRGhNKTx2JzDWyvslTCv
zzepQBX8B0pAXwniQ7I1pDa3qINJHmM9338eMQFEX68wjcaaN0jF1Up0C50ZimXE
ZGAc5eZfGzLVvY0P0G2CVPuReqJXc1RM4+pw+K2jhirCBfW469PsxtWU3VPK6X1O
sPiU3qS4aG/oR7R0b+oD6xmq5Zhhf/M6EnXEhgYPSPIXzv1tKaL1Pc0c2Ud312Ay
Fy+L4hcGAj+J3kW0/VMHhsit57n5G/CMKS3jlDQdbgkfrM0001TUnz5ISf+wEqns
D95AMV/gXCl/zD0I46Y4NV+vY/uZqRPJoTwuwzUGwps2kstQTHC0IyGYKazA73wM
qCKxEgOOQSdRzU6xPM02
=xpgx
-----END PGP SIGNATURE-----

--nF5CeAc4QNWHTmva--
