Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966079AbaLKVgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:36:52 -0500
Received: from sauhun.de ([89.238.76.85]:43862 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965078AbaLKV0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:26:39 -0500
Date: Thu, 11 Dec 2014 22:26:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 0/3] i2c: slave support framework for Linux devices
Message-ID: <20141211212632.GA21482@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 05:04:52PM +0100, Wolfram Sang wrote:
> Finally, here is my take on the often desired feature that Linux can not =
only
> be an I2C master, but also an I2C slave. Since RFC, most open issues have=
 been
> dealt with. Find details in the patch descriptions. Documentation is still
> missing and will come later this or next week, but surely early enough for
> the 3.19 release which this series wants to go in. Yet, I'd like to encou=
rage
> code-review and build-testing already.
>=20
> Basically, an I2C slave is a standard I2C client providing a callback fun=
ction.
> When registering as a slave, the connection to the I2C adapter is made wh=
ich
> uses the callback when a slave event happens. That splits the HW support
> (enabling slave mode on the adapter) and SW support (here a generic eeprom
> simulator) nicely IMO.
>=20
> The patches have been tested with a Renesas R8A7790 based Lager board. Th=
ey are
> based on top of 3.18-rc5, but will easily apply to renesas/devel. A git t=
ree
> can be found here:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/slave-sup=
port
>=20
> Comments welcome! Thanks,

This series applied to for-next (with some typos corrected)!

I think I have an idea to improve the API thanks to Uwe's comments.
Still, I'd like to send out my pull request soonish and fix this
later. It won't be a massive overhaul, so I think it is okay.


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUigwIAAoJEBQN5MwUoCm2IS8P/RWVO7Ax6TIkYIsrC8TscGar
0ENgFTLZfldrqyREWVu36lz16JhsxnrBPcrboBe0BpFpVmgLIweaVyVcUFmhi4u5
Z8ZlAvH233j/yG0tyse3qWvhy/1yWkHPzLaTybhp7kr4iaGvRc7s8RxOiQNzYpAt
qk8EZeI9FrIRJ1iUUfT14vClB7Xi2DJl0qqC/rFrPIKVSVyOsNma+tW/wxuibSmd
M1PMYZdMJIuBOp6QibWaOxrkNOGwIU+aD30WWZsAcqGY9JvbpPTG9Ii8DoE4f8D9
eZAB4/yEFCVfVkSdzHgAosnN3sqcEkJ3L470nHz7ukVTUDn6sTooDKWrQOGhXpGl
S9/cuU67Zcsqgl1BUBzwKvgB5QzH2lButf8HuAdHb+s5SKIm465AtBADuj5TbNCc
rdDvnZUSZ/A07whh/KuWuraOxetfAQ4EMDwgFW+N67bg6ZXD1dPCyS8u9NU94XBC
D0ODP70T4QhT7prQXsTSbTjuRhf2DAldY+iMgmwefVTcDfxM5Z8YJnDiBSA2rzZb
RIuCQUJr78447O+OqVAELBDzBspWIaN6dHfywZ7RC0+7flbmCgI9Up/Oh24XziTZ
+iDA+jtd3/fmzAskDDPeok8dV/qUy5K1BNlaUgIz5wNjstyons2SzLsPq+vDfL/7
FhLkeFKOiUNMPKRcAc6O
=QLBs
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
