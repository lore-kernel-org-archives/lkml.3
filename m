Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaJXVCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:02:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46924 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaJXVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:02:36 -0400
Date: Fri, 24 Oct 2014 22:02:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20141024210214.GO3729@sirena.org.uk>
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413816472-1895-5-git-send-email-javier.martinez@collabora.co.uk>
 <20141022164813.GD2344@sirena.org.uk>
 <0DA944C5-7A6B-461B-A8E6-D47343D22E0B@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AA9g+nFNFPYNJKiL"
Content-Disposition: inline
In-Reply-To: <0DA944C5-7A6B-461B-A8E6-D47343D22E0B@collabora.co.uk>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] regulator: max77802: Parse regulator operating
 mode properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AA9g+nFNFPYNJKiL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 23, 2014 at 11:28:09AM +0200, Javier Martinez Canillas wrote:

Please fix your mailer to word wrap within paragraphs - you should know
this by now :/  I've reflowed for legibility.

> However this is an implementation detail and should not change the DT
> bindings in the current version. Could you please let me know if you
> have any issues with the other patches from this series so I can
> address all of them when doing a re-spin?

I can't recall anything but I'm not sure I looked at them in any detail.

--AA9g+nFNFPYNJKiL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSr5WAAoJECTWi3JdVIfQlhMH/2XE67VcrSF7j0bGBNd4hHt+
WXiySErF4lpTjq8x8RtFnmWYpZevatt/BjltMcIDkajU8WNuR61A6IMtXkYUvtM/
Tj0aUeHcbrWkkXoNgufLQAF8yeJ0/ziHxikfI3EK8uPmYkECzNjiwrArf6GPDU2R
CUK/3k7b9qZrOMqNjPpMr+fbtqkhP9nYe7b7Rkw/qkNOoIPk9s9853jbCiaExmPG
nVs8dwN4XK5coyUfdacgwwZA2apVAnXIik/ye9n7W2qRliCcU44WEH64ZrCozsCf
czffdAw1zUSZX4Ic9blsXDutZvWrSSRTkbZroIEOwmkwlWsVOte+BgvRooYGlQ8=
=vEul
-----END PGP SIGNATURE-----

--AA9g+nFNFPYNJKiL--
