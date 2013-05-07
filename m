Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3EGO27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:28:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57092 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3EGO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:28:54 -0400
Date: Tue, 7 May 2013 15:28:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20130507142851.GU7478@sirena.org.uk>
References: <1367932297-27926-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DFFMAMYvrfM3lt66"
Content-Disposition: inline
In-Reply-To: <1367932297-27926-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regmap: debugfs: Fix start_reg calculation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DFFMAMYvrfM3lt66
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 07, 2013 at 02:11:37PM +0100, Srinivas KANDAGATLA wrote:

> regmap_debugfs_get_dump_start returns register number, not the actual
> offset into the map. So we use the return value as start to dump the=20

No, it doesn't - it returns the register it should start reading from.
It's just that the code isn't paying attention to stride and should.
Fix the function, not the callers.

--DFFMAMYvrfM3lt66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRiQ+gAAoJELSic+t+oim94mEQAIFo5ZPqqSr0uwbpQZn8LudC
sQIBAklLEkf1JWnIxiQacYYyjB/okfJ81CQUhoebDZkltihslsfmh1pWwzQWZEj9
OXxvg/YoTOfhH6O68en1JmE60SeSFtrsWsC/t5XrXawMREkMwlsheNvqB5oOr1lI
2bTP9jfBoOFymXEqF0VD85ejYWbgKHLbK5q6dM6mnQlpJ1bERVWWc3KLH3zr2ctS
JZMwr/WU86RkFAmWKRM5Jmstowf1PmRwvfXLXqJNbCq+03b+jTAhIs6WdA62sMRW
5zT+HF4m4BD5yYXrfi+aHk4v3xlFQ3dZEhpJSZKtzXQDcK8vI0GNMOn5vg0Fbvwp
TrNFB7mUNw3CN9/2t3K21k0pK5qP5ml9Dt2gB26HqRVclj0SoGiJ31qoIWFS16sN
AzRQcxXQ9NJUWDk77QImcilXpbB2W+GqmeHzN/i8WQG3Hi+WiVHiM53aL7katjZZ
CqcJqxaYdiN9Rsf76qLYCujqn5nXuoFSYX3f/fNW4J89aJ4vf8cXSgZN6ivGc8Tx
2PpMzfftKUVGZaUZ58fd7RuoOic/+4hTHRu/Tf7o43w/tWMPdZ8b6VCVr24aryCG
Hg+RCeeoIETpSDWyAddRnsLgawYkwJgw6B8jDnYHwfoEdN/CNYNIlFEUBnQhSwPX
gX83QljQ1zzvUQ7nZe59
=Nr3Y
-----END PGP SIGNATURE-----

--DFFMAMYvrfM3lt66--
