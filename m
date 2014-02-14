Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaBOKI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60408 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbaBOKIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:25 -0500
Date: Fri, 14 Feb 2014 21:10:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211028.GB4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zUOaI4FcYSvHUUu9"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-4-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/16] regulator: max8907: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zUOaI4FcYSvHUUu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:50PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--zUOaI4FcYSvHUUu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oZAAAoJELSic+t+oim9H7AP+wbBi9PZe65KtY2fJdB2JGmh
GAH5la5bZ1tP/EAfwlsmgfWfIN8OXe82Q3it755Re7+RxC5QaoYEDBo9G19hn3KM
O1Q7iB5zJnx//KJmPZtANqBNgbnAxmppfEHPJrKAAGBwXm57PvAY9z+I2qbDxiwH
YmPA8nQkSLgKkA6hsnTJgs66m63poiVlBFg4naWnUjo0EcleeClqks40l394iwzZ
05pmvbQNFEsRCBhvbkZw+Ioq8nAURN2GqMBbZc2zyEIQuNqKfQBd3yiElB7S0UIk
Hpu27lpNFwYiiQ+Rg4FsdQvCxGXEiUEEt9ilOU7YGUfC/RsIYOmvL9GutvORmlME
rhBgcb7PnsWLbGGdcwWZVEeIRxR2YCO23tH53cYKM3/t5sBMBf21qqTEDdnNIkQV
CS4iXSjfQqTXGsqpU8Bm7eY/kEWiINzLJL5jf9aoPDrhcczcSsjZzsSpprgacXIH
7DhGBfrpXLLIdhFN42aU2wGxalfW1EugG87T35UqmNOsgGpwyHgRDn3Vv5XBCH8l
mfYym4zC7B1au634gbCqQZ0cTuDD+CclnRtwmoCh6kRCmAwwOy2p4IGPfocP6CM1
/RJbD+w1HdS2BeTF/qOQdVSYF54SOpy50I6/rhmh05s6Y9vW6IC2ncsuoP0BQOG4
dkwWpy3qBCmyzweBDvqy
=13bm
-----END PGP SIGNATURE-----

--zUOaI4FcYSvHUUu9--
