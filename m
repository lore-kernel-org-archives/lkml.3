Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaE0Urk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:47:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:45128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbaE0Uri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:47:38 -0400
Date: Tue, 27 May 2014 22:47:31 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140527204730.GA30610@earth.universe>
References: <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
 <20140521194527.GM17417@atomide.com>
 <20140521215055.GA26362@earth.universe>
 <20140521220807.GB14520@atomide.com>
 <20140522000558.GC29118@earth.universe>
 <20140527203543.GB32336@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <20140527203543.GB32336@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 01:35:44PM -0700, Tony Lindgren wrote:
> Based on chatting with Paul it seems that we most likely don't have
> bits for sysc_flags for SYSC_HAS_EMUFREE or SYSS_HAS_RESET_STATUS
> either. So applying the updated patch below, and the SSI dts changes
> into omap-for-v3.16/dt-v2.
>=20
> I'm keeping your previous ack Sebastian as the the idlemodes did
> not change from the previous version, hopefully that's OK with you.

Sure, go for it.

-- Sebastian

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJThPniAAoJENju1/PIO/qazuAP/jWUjp10rDZcckjKqggbXNZq
8BJRYi8skClJDvpUpLq5C+FC2YGsrEXWeiI6+gjk7sVgjgSS4tFMIj94dpSWDfE/
dp3FXPGDX5Q3CsX5I5zPVXU1TfszkgOF86E2P1RF4+ks1c/5ih7W++R45i4QvCM7
+BeN9vcBrVZy+OkLWpCC5vdJM9lPzk6E4uD0KRxfL/AEgyF7ZyG8tilQVK73/FL6
GtueirRT7uTox1/oi9+3644x3zRaPTJuo/EeX0pha5DSZx6yUPM1raR2QW0oI/V6
mdXvwco6viNljS6NPUB/Mm/vMLGx9O9NpVK8Tf8tYZcZ6f482CutTkMQh3iDjH55
zlZiHfknl+EaFGVJ6yHkeUfUe4kK89uMOCs7oZjkpnnqiqt9J9Sy/4hHgvkHvV44
EzQ0CnDzt3SUAq9j2nlhGPNOqEUzqiTj/S3mFxnIE5SbpbtmIWY65mpzICnWyBVU
a1pWeB4ZvIrTzQsoDmRu1SBm+22GClJf+85akgeddn3z8eBFABqC1hwOWnnbXb4o
934N7E0mnB4mZ63gJJnUFfwY+vV70efDwXqxonAos7SJF6Er5YnnYei1cxRBNuSX
yCVGnk8OIX9rCvOFS4/oUcIpvLXFVPEoMUIgHXDUxKepUv/hKuyaXYzLRuJ0ZJsf
8guupD5jsKjqDJ6CqYuf
=yBWr
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
