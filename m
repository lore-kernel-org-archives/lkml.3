Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaAPOHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:07:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55686 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaAPOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:07:29 -0500
Date: Thu, 16 Jan 2014 14:07:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Saurabh Singh <saurabh1.s@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "celinux-dev@tree.celinuxforum.org" 
	<celinux-dev@tree.celinuxforum.org>,
        SREEVATSA D B <srevatsa@samsung.com>,
        Praveen BP <bp.praveen@samsung.com>
Message-ID: <20140116140712.GE17314@sirena.org.uk>
References: <27224826.584141389879802275.JavaMail.weblogic@epml20>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DqhR8hV3EnoxUkKN"
Content-Disposition: inline
In-Reply-To: <27224826.584141389879802275.JavaMail.weblogic@epml20>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Parse missing regulator constraints from device tree blob
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DqhR8hV3EnoxUkKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2014 at 01:43:23PM +0000, Saurabh Singh wrote:
> Hi Mark,
>=20
> New patch incorporating your suggestions is given below.
>=20
> > * None of these properties are documented. Documentation is required so
> >   that the contract is defined. That allows people to learn how to use
> >   the properties, and makes clear what we can and cannot change
> >   kernel-side.
> Done.  The documentation is in the patch below.

Please send patches using the process in SubmittingPatches, the
formatting of the submission is very important for tools like git am
which people use to work with patches.

--DqhR8hV3EnoxUkKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1+eNAAoJELSic+t+oim9jNMP/ig9ppqMxc0cg2tfMODfcKwc
m/iBW1Ty0SNTuX+VOXnXAQG6YGRT31A3I+V0ANuaeMQ3yXtiSeO7btqrEn22qrTA
0NwGDSazDJiPz2/M/g370H7ky+avRK8WpLVtmClsKGFTJ5Shor86HJZTYv37DPO5
3ybKHfkKcjICpUpNOVn1A0b964lPRGVSkgdheda8J4GOuQbEa2rjnbx//HLHtIe/
NmJYFyvF3DDS9e9boauQySV8Yy9kOGORXreEe2bs9SUsvPlVKSC4Pah+DE9WHy9e
OgvNiwCVwFhH1DI2Jv65IZknm+vVkEoW4D6KXrYHhXr8xMtUQTWRUo2jLu5ylHBk
k+2y0EkJzVoEmh3JQEU3OTEwqnEFi8eI7+P3BR+VdUAMGY8MVIDnVjLzbt7gHstw
o5vLgrvX5h4blIx7fcdOwZTDmbfhyGJO8+Vb24lQ/ltLwuQrFpVUW9TNtzV5AFls
RgfGhOTzp1kD1ykGWlcLG1jMzgmf3GN0bhSkBpeIYPfXAK0u4bBT54rSiUyEX4cg
JpxSVCJeI55Kt+f60Y2cb4woLcJCWwRx6iqEehIrfnSTBtCEWUa0XsyxwXaQ311e
RKLku/VS47OBw4HsOrMzvaZGjVsQoppMadZBudpgBOvpR/zW04xqswtsQMJ+yxol
6V3R1CrISUTa1iFMStF2
=KFxQ
-----END PGP SIGNATURE-----

--DqhR8hV3EnoxUkKN--
