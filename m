Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3CUV03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:26:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46152 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365Ab3CUV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:26:27 -0400
Date: Thu, 21 Mar 2013 22:26:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound: max98090: Remove executable bit
Message-ID: <20130321212623.GK15926@opensource.wolfsonmicro.com>
References: <20130320163627.GS28775@opensource.wolfsonmicro.com>
 <1363820072.16270.43.camel@joe-AO722>
 <20130321162503.GC14768@opensource.wolfsonmicro.com>
 <1363886175.30275.10.camel@joe-AO722>
 <20130321174440.GG15926@opensource.wolfsonmicro.com>
 <1363888393.30275.31.camel@joe-AO722>
 <20130321184458.GH15926@opensource.wolfsonmicro.com>
 <1363893405.30275.39.camel@joe-AO722>
 <20130321203709.GJ15926@opensource.wolfsonmicro.com>
 <1363898422.30275.47.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4e5ZDkbgLEOfWmLx"
Content-Disposition: inline
In-Reply-To: <1363898422.30275.47.camel@joe-AO722>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4e5ZDkbgLEOfWmLx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 01:40:22PM -0700, Joe Perches wrote:
> On Thu, 2013-03-21 at 21:37 +0100, Mark Brown wrote:

> > you routinely send very trivial
> > patches which don't apply cleanly

> That's demonstrably false.

It's sadly not, at least for the things I get to see - as far as I have
been able to tell you submit against either Linus' tree or the last
release (I think the former) rather than the relevant development trees
or even -next which means that if anyone else has looked at the same
area of code there will be conflicts.

> I'm done with this conversation.

Oh, well.  Hopefully you'll take on board the feedback.

--4e5ZDkbgLEOfWmLx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS3r5AAoJELSic+t+oim9WXEP/jdUVnQTCHvs3LluOTcYyaJk
eQKl6KH2mHUG+TM4dj3Wv5JosJ7IsU6mRn/ZunAHVqr103Dd8qkYMyXssY13Vajg
e6iXM/F1bkrefc9qEC3RbvzvvmFS6lbxtzTNkmo2kWoVW5fyCNnykl0/p2QxCP+S
itg63fF7+WBE7G+Gfm+JuNwFS1EDDtZD97DbEkcpUvoKOXCgGmUfBe359Qx6aEEi
8XadmT4f35l0zei1NiU4qtUo7z2RAlKgRekA5YRlrisPE7LW21vRSknh/BOdAvnH
uwDkax3/W6WfKDxH6x3yxGWXFP/HgGFwY1ttK4QDjKlAUsy5eNGMy5ubBzEuhpCa
1/oTSxcxv+5Qf+FykP3mXMGZ+f5ONpCvBlDshXkgTZAUQnorRpNy9mCkOaCD1EbU
CHQtQhUgGevCK5ycYaDr8WIQhPUyC1hEp7D6zQMIioUoV0NIKMLnyaYn/W2mWsXZ
lWn1KjRFnDWcpwEw1Wz5mrW4Udn+Pv0/56tjoGYv3UNUzO8KHBWn1gvNvOiUGOxN
+F+xgk/cGRtXUfLq0dGUEgEBzwPpURPRXYG3UDmNANoyssyY4enTAwQxEBsxUFmt
jbC16ikXqx77u78Dem6cEVpljSCcuITEpcmmFCs6bQATMv8WskfUrVA/lLf42oOR
7NMsqJYyHPavK514Ez81
=bRGv
-----END PGP SIGNATURE-----

--4e5ZDkbgLEOfWmLx--
