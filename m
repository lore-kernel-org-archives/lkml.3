Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab3EHMkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:40:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42536 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3EHMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:40:54 -0400
Date: Wed, 8 May 2013 13:40:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Message-ID: <20130508124019.GN7478@sirena.org.uk>
References: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0oEQci8Wf3TZ4Qnh"
Content-Disposition: inline
In-Reply-To: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: debugfs: Fix start_reg calculation (v2)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0oEQci8Wf3TZ4Qnh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 11:20:09AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>=20
> If we dump syscon regmap registers via debugfs you will notice that the
> dump contains lot of XXXXXXXX values.

Applied, thanks.

--0oEQci8Wf3TZ4Qnh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRikevAAoJELSic+t+oim9MwUP/Rx8MOXyMx69IuNP7JnP+XZm
LDHFtZczUjhpKuJJ+aliOKu2iw6qjrdC6OqfjqWeH1UvpfQa0rBz7yWo3ZelyNiD
AKCK614IaitETQB1dQKn4rwdmSBcy25FUYQ4RwlGfnQ8Labr8Xj7tb0yLTHjDgsS
4iLLidnyQeHkdqaevKfkzvWwjqwuk84ydOTvDG2It1nBqj4s2A2x9kE3O6iC4D8Q
AnBb8zYsDEYMNLtxm9n5bSMGENpIVFa5T2lkxYpGluBSECru8SE5pIpCxcFrUgwo
Zzcn9RQchvhyugUpCk2xWWetLoad19PfsWc5CgSUQHjXJS6+PVUsKl1rTQtmLlgM
+uVhknWk/CF+QG+JHDjouujAyvvRrBFnhqSouiaP551llvnOKC78Bcl+DDji43Q8
bCdSpn1a12fFhxnzpcTddqf4eIpQYgVY3lOIYA3/WWcJhokYgwBjYVpvesyMyvxv
+LXGRqFZwopVnzbS/I5VzjtYQdDJdzR5M80eRN09bTic3nUxno8fMGTqJglhAkMp
JQAmr3obZ57UpWXsg4E3oB4Q6uLTzogb71enYzeV70msI7Vy44ARU/fLYiaJfm7x
9DBmM0bexeLgQSBWdGPA4wm2/qVg2zBRfDr+OFQUSlYZqdd2jXUp7kaBU5KjurW9
H5gdeERs4yWne20VL/2/
=XPpy
-----END PGP SIGNATURE-----

--0oEQci8Wf3TZ4Qnh--
