Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3EIOlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:41:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49105 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3EIOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:41:19 -0400
Date: Thu, 9 May 2013 15:40:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Message-ID: <20130509144055.GF3200@sirena.org.uk>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081650.23264.arnd@arndb.de>
 <20130508150141.GA5057@opensource.wolfsonmicro.com>
 <518A8E6C.6070907@st.com>
 <20130509095143.GB7478@sirena.org.uk>
 <518B8F49.5020902@st.com>
 <20130509132600.GA3200@sirena.org.uk>
 <518BABF0.7040201@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
Content-Disposition: inline
In-Reply-To: <518BABF0.7040201@st.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2013 at 03:00:16PM +0100, Srinivas KANDAGATLA wrote:

> Some of layouts of the sysconf registers are totally changed for each SOC.

> Looking at driver by driver maybe some drivers can take advantage of the
> patterns, but Am not sure if this will be a sustainable solution for all
> the drivers.

So what exactly is the driver doing then?  If the register maps look
nothing like each other then what's the common functionality the driver
is providing?

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi7V0AAoJELSic+t+oim9QEsP/3PYTETaOGDXGkLb5WdAC/6K
SvMEIrDDS3EjA9oc8PED996LqrB0X3KfzDjKI4dV62g+0syOEuMbLu4QvyLjB83v
Vsq6VsO0wZ9p++4QljCBThb1opO4Ot+VkLtQuavEHTjd2ejxigxpG0wBQkNxwiYu
MmXVVXgO+HqEAcjwLyy1Uz26Y46VupNkaKmNNF/IW50h2+dSkH5vMZBQEl9UTfkg
yadmMVbtep9MFRRUrt4gZ5uY59/15CXgjnaO/bUJq/23ycTwaSsh0YYb+6MV7A6X
VRXEWSpz0d8b+BbKMtZl/iwWN4Raoi+fOamwFz1rJ1BslEXekK6g4ydE/ODtb0Vx
JavId06SA+YZ+DNGiLGXSe6XrLGDlXQesiH8EMPXYiDxtDkDmDalFlksmfWgFuu0
UvjJGe2zqaYPFvWBTyFqxagDNC+FkZOkcRqzWq5ka3Q39bNsFiuAO86kxKKxisX5
e7/RbskUxqddaQZmtWJj0zrU8dZ+hY2YA5a1j+Nx/m9+PrRbMsIQ6wA6DZZJIooX
6+qccSLZlxTm1MtCVbupWqorWDWcpPdw9u+a+bpkbjZITrqe8X9jKOXzbg6BWsb8
cgQi30E2YhO1NdLz1TgyPNt2vA4HqE9fZLNg2DK4PDXZMeMFEncmtZeaQYV8dtQj
udqBvOSjKXhsRrb82mCb
=SzXK
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
