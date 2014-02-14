Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaBOKHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:07:30 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35605 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaBOKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:25 -0500
Date: Fri, 14 Feb 2014 21:08:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214210854.GZ4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tpXmNJJzF/fVXUEg"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/16] regulator: max77693: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tpXmNJJzF/fVXUEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:48PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--tpXmNJJzF/fVXUEg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oXjAAoJELSic+t+oim9U+cP/AgCnGD/9LvGw9duvg9p9jI1
K8QH0HgJSaAdyynj8EvvldbEyAI20ulj/A1s/faG/+G4WXTEzbIYLdOzdw5P3Hjt
zDZG9TdbmjrM+cbw2sYShrb6NQdJLgce8ysm/Yu/OFLzgVlXRaLrNwOPkbZqFfRp
tCELi1CSFiLw3gXWsxI2TJ01s0OE1oxFaXlflkZfqgB3F2uBKEIIYCB905knp1s9
0x05Y7IlFU74ohQjqlo4u6PdU5fz69KJG3CVFbyVy6jD0sq2gVf7EhkHJm+fttWz
EQ0KbMuFk8eBzk2rM0E3YVhcugtumZiAwjuyKv9JdkpvfzSy3gwiHazSAv3blE2v
/PUfhDVj0HviQGeDeCUgvlw4EB6WkDz+8ojkikOJmrTffY+USkPB9/UzCCjs43lZ
IFTvho3Lrbo1HJXns92scvZUe3xqcCWVRTDttOodjGv8E8ZCxzxNLCGYEfUW9Nc2
HpkLyKkKMwjxCGG5rrE4VWwLJCpywvHJcSNhuW4NUwl5YvyWEDtf/AHtVYSN95im
Lj4hu7TevXG1KWpyltuCx2lfBo3XZV8s9L67DKAG4JKyLtnqFmci03TfqzpNFRGe
c2HGL6YJ4lUsJgp0iuG4isG+qvtm4t9849L0hEHzUG8jsqlF0XsPOmbghsevOfR8
0wePeNxgQ+xQL2dVGcFx
=Gq94
-----END PGP SIGNATURE-----

--tpXmNJJzF/fVXUEg--
