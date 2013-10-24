Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3JXNnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:43:13 -0400
Received: from ring0.de ([91.143.88.219]:46523 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab3JXNnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:43:10 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 24 Oct 2013 15:43:00 +0200
From: Sebastian Reichel <sre@debian.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Brenner - TAOS <jbrenner@taosinc.com>
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
Message-ID: <20131024134259.GB3681@earth.universe>
Mail-Followup-To: Jonathan Cameron <jic23@kernel.org>,
	linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jon Brenner - TAOS <jbrenner@taosinc.com>
References: <1382565063-17083-1-git-send-email-sre@debian.org>
 <5268DA76.6060503@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <5268DA76.6060503@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2013 at 09:29:42AM +0100, Jonathan Cameron wrote:
> On 10/23/13 22:51, Sebastian Reichel wrote:
> > Add Device Tree support for the TSL2563 driver
> > and document the binding.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> > ---
> >  .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++=
++++++++
> >  drivers/iio/light/tsl2563.c                           |  4 ++++
> >  2 files changed, 23 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/iio/light/tsl2563=
=2Etxt
> >=20
> > diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt b/=
Documentation/devicetree/bindings/iio/light/tsl2563.txt
> > new file mode 100644
> > index 0000000..b52cf4b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> > @@ -0,0 +1,19 @@
> > +* TAOS TSL2563 ambient light sensor
> > +
> > +Required properties:
> > +
> > +  - compatible : should be "taos,tsl2563"
> > +  - reg : the I2C address of the sensor
> > +
> > +Optional properties:
> > +
> So two options for this one.  Either pitch it as a possible general param=
eter, or
> mark it with a vendor prefix.  It seems like something fairly general, bu=
t in that case it
> probably needs a more detailed proposal and explanation of exactly what i=
t is.

OK, I will add a vendor prefix in a PATCHv2. When I converted the driver
to DT I had a look how this is used and I don't think it's "fairly general".

> Also, is taos listed in vendor-prefixes.txt?  Jon, is that the right vend=
or prefix to use?
> I'm guessing you have some non mainline bindings out there already so it =
would be good
> to match those...

taos is currently not listed in the vendor-prefixes.txt file. Also
it seems that "TAOS Inc." has been absorbed by "ams AG" in 2011.
So how to proceed with the patch?

-- Sebastian

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaSPjAAoJENju1/PIO/qaqqkP/RkWc6EDdRaKNkNRtahjKtQz
/vBR1C5oaM9TkAT61aXNNcC4ggIUXHS/GmyebntVVIaNcQkVEpf95C5nalPc9qMZ
kHIHouvwNgv8UCZGxhp47Io4lZfzaqkNTmfJEjVnuKMYZuUvIx31UjTXWI6OaB3U
p84EtPOUozc+9OtNq/v30UXjVmR+b+kuoppmjZUni1kovAzVFDr9uNA7r229YOK+
YrWPKeCdwRDSHvJAuAqyMb+QiCwE/EZsVr23mGEOwU8U2/9IsqEK7/emWFTg1gZW
OlD+QYup8XCDEKstssmZRbj0Mlt8zqAt3PluDgwyUYgArfjkpV2DJBo8MWgUbsZn
zmPJ5PZOz3whPAOsK+6uI1JZ5saye1IJ1ByMId/Hzff0EZwR27yhPDVxYLnOMGQ0
W08bBJkQqyH4SIzq2jx0sm0C0HFtDWn18bCpZTuKewwPSplxg4U9eVfMrqCEYjIf
9Ha7t+B59JNvNKZ/l9GbNZM1o2uNcpSndQvJndeSXHu7I3ezYVFi9o2wLerK7Ulk
dJSPlSy3DYLTkQemSWh4EEwMaUOF4pcXIlNsJwy9lwO8gZgamtO/azlFjSToU7RB
U/t6MDfnPh/uwThJd7gIPYYbL/beBOF2m4fEli6LTzCOvIqyYXvDn78N7bml0y3N
cCtbtICayHI8ROz7WESX
=e1tl
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
