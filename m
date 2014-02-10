Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBJLAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:00:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39878 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBJLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:00:40 -0500
Date: Mon, 10 Feb 2014 11:00:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Message-ID: <20140210110026.GP1757@sirena.org.uk>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391993920.14955.5.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Content-Disposition: inline
In-Reply-To: <1391993920.14955.5.camel@x220>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Remove orphan kconfig symbols
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 01:58:40AM +0100, Paul Bolle wrote:

> Anyhow, you should also check MACH_SMDKV310. And then have a look at
> https://lkml.org/lkml/2013/7/14/27 , in which Mark Brown (added in CC)
> and I spent some time not understanding each other (at least, that was
> my impression).

I understand what you were doing, you just haven't thought about what
what you're doing - why the code is that way and what actually needs to
be done to it?  You didn't reply to my last mail there...

--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+LFHAAoJELSic+t+oim9nzsP/1xKXe+eLDRHXZYFDUCTLjiJ
CvFrD1Er2EgyhPjh+kdTbFxgP1tYtF1/qF/FmYZzkzBjxyzDxhxMjdZ8nv/dZ/af
O/dzeFmliCGyd+S1n9Y4RRvpmq5K8C1Mq6ZTajo/dUvDp6EFpSZGay+4rBLc5d2S
jSjxQAzdjm0VODZ3xdVWFg3k5O1VaVR5JwSgNSO+w6Jva75U85vBQnsy3qUmZCDv
l+bcgu3pKOEnyOQMGMkvRystQYGksQqCg0mohXlMvNx8V98TuK2hrFzpNtEyFIEK
4dNRGFNkkSpL4AjJuvelOWXs28lkOh6k78S29UcGWiGauTVrI7rWTyMzN6XvyDcv
JPcF+H9WYoCA6Qifkal/nmwIeuV0myKeKrcV5LBc/KC7JaHOpqBmMBgLVMn2iGr3
nKnDdTle5r6LbMfUEhtWjw/96U63Z4/ZCl2mhZo6K+oJSPZHu0Zk6RlC/Lv09Tnc
sw3qLH64WM+vBhFMlQCssZo4V9kmQEsZxPUq3GqBx2l6fI+cjTiXVef9heVoGJsx
hCtGEmBTCvuqWuxF5mfCye10GKrBXPKzdPkRvUtRvEAGdFQbO/sZqrJRePE8a1Jx
KGK8ACqJTHWY25szLifST5jQd2idMTBgy87G2vO/9XWv/QhKiv6v+A2WWNmsnKE8
2IL3o3/rNMh3vnWaWQ/G
=hU9F
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--
