Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3ITQHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:07:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48088 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751942Ab3ITQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:07:32 -0400
Date: Fri, 20 Sep 2013 11:07:17 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "maxime-ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "oliver@schinagl.nl" <oliver@schinagl.nl>
Subject: Re: [PATCH] [PATCH] ARM: sunxi: doc: Add sun7i (A20) interrupt table
Message-ID: <20130920160717.GB5429@lukather>
References: <1379675560-30656-1-git-send-email-oliver+list@schinagl.nl>
 <1379675560-30656-2-git-send-email-oliver+list@schinagl.nl>
 <20130920123956.GI17453@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IiVenqGWf+H9Y6IX"
Content-Disposition: inline
In-Reply-To: <20130920123956.GI17453@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IiVenqGWf+H9Y6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Fri, Sep 20, 2013 at 01:39:56PM +0100, Mark Rutland wrote:
> On Fri, Sep 20, 2013 at 12:12:40PM +0100, Oliver Schinagl wrote:
> > From: Oliver Schinagl <oliver@schinagl.nl>
> >=20
> > This patch adds some documentation about the Allwinner sun7i (A20) using
> > the GIC.
> >=20
> > Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
>=20
> NAK.
>=20
> This information is not a binding, and it's not a property of the
> interrupt controller. It's the integration of a full SoC, which should
> be described full in a dtsi where it can actually be used.
>=20
> The only other SoCs that have this are other sunxi variants, and I see
> no reason to have them here either.

This was mostly here because we had a very sparse documentation for
these SoCs when we first submitted the patches, and these informations
were not easy to find out. So a misplaced documentation is still better
than no documentation.

We do have the same documentation for the clocks here, mostly for the
same reason.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--IiVenqGWf+H9Y6IX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSPHK0AAoJEBx+YmzsjxAgv4gP/13dni0QuVK6K/rGCSS7oLj1
uuNHfAnZPvbDHlLcgIdCClaDEQQB52uLLc1ROSjWGfSQG9dkoQKB0rrGJvk9jpTO
1BHGvThB6edsUWwajHdxu6VmiwCP7i8fyR6Ya94fbLf7yvE2xlhmZtkCbYnjWRPn
WWaGx3gXVSlrV82PSqeRxYxj2goWoLDRFfnczGt3TDYCzEJsOBzNsDD6urGgpbBd
lRxO2HxCV7l05xeDSFwRdakLpFn5/hlEsZZYJdvlr4MPiTniKd8vUJUKCpNMpFb2
eddShZvRFbeHzgBnL3u9do53NGRWwULi115b6uIkJ8v+EV2KhvcKw3Ut8jwCc31l
uQ68kw5wvutxDzqW/wDbw6jmHLQHY9CqLoQJf9Ty/pi27k9BOQ8SJDdrhWhfGNbn
7n+dMnlIzDiJ0YdI+Gw7N2SS9lw+J8QtJAp6fS8yErLn3tN6wInVjnIMTNKkq9G1
YUUnzatvuwvjoGeKc1Plj0t57Pzx05F9xjmYVTaZzoCk8DyjRPj2ZT6gUwsDhbxr
m3+kik46kUmJL3GIGD0ox0J9WYC2CJ1eMQLSPWLYFeIW1z3aW5cHpKT8xuJoMCd1
3gbYljV3MbDX0JtHHohqwZfNMzcVwSYmOICbvxHxLzfoHmhkRT/xVRcYGEHzh/Bf
uDKq+BRWHGVuaPv9BJFd
=/xRw
-----END PGP SIGNATURE-----

--IiVenqGWf+H9Y6IX--
