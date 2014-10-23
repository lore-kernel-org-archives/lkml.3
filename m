Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbaJWNBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:01:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44497 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaJWNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:01:32 -0400
Date: Thu, 23 Oct 2014 14:01:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141023130103.GC3729@sirena.org.uk>
References: <20141013103512.GJ27755@sirena.org.uk>
 <20141014011112.GB2751@jack-ThinkPad-T520>
 <20141014075606.GN27755@sirena.org.uk>
 <20141017091950.GA3233@jack-ThinkPad-T520>
 <20141017101734.GB1820@sirena.org.uk>
 <20141017104309.GA3136@jack-ThinkPad-T520>
 <20141017142605.GU1820@sirena.org.uk>
 <20141020061024.GA9406@jack-ThinkPad-T520>
 <20141022102723.GL2344@sirena.org.uk>
 <20141023031443.GA3244@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <20141023031443.GA3244@jack-ThinkPad-T520>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 12:14:43PM +0900, Gyungoh Yoo wrote:

> So, what do you think about DT like below?

> sky81452@2c {
> 	compatible =3D "skyworks,sky81452";
> 	reg =3D <0x2c>;
>=20
> 	backlight {
> 		compatible =3D "skyworks,sky81452-backlight";
> 		name =3D "pwm-backlight";
> 		enable =3D <0x3F>;
> 		ignore-pwm;
> 	};
>=20
> 	regulator {
> 		compatible =3D "skyworks,sky81452-regulator";

Yes, this is good but I still feel that the above compatible is
redundant and shouildn't be there.

> 		lout@0 {
> 			regulator-name =3D "LOUT";
> 			regulator-min-microvolt =3D <4500000>;
> 			regulator-max-microvolt =3D <8000000>;
> 		};
> 	};
> };

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSPwOAAoJECTWi3JdVIfQJxsH/jHUTXSiCTIoVzgO067yEVJn
iC+HZORa1gJryKg/vrdsber1l5csAiXW1jU0wlzPxBbNhJEmKDFQ4lyvBOhuBvE2
LwBeP5Quf2dcel1OnS/RZ+5JiUNNFaJmsceY6eXSl48lQQGMw7oXeoJTFlYcV/zr
Kqr8cE9prIX/N1wQQ0cV4M710bNYj2qHT5sbhRXkHpZz2vhZ6i/QIIi1ODzy0epS
Q2hOh69aaaYFREaUiVL82N6WUzBKiR3HxhPFz4TsVYeyupqzIdL3o2ImXleRf1AE
pavCTvli0TSYJPReeJSqO/o+neeUpjZr+HnM3WomOQJ8MJN1jqDz5+E/NADPN/U=
=ifPD
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
