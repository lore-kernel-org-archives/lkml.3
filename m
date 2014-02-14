Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaBOKLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:11:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60678 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaBOKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:10:02 -0500
Date: Fri, 14 Feb 2014 21:20:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214212022.GL4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-14-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FLFbAWqIDstwcN4K"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-14-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/16] regulator: pfuze100: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FLFbAWqIDstwcN4K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:20:00PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--FLFbAWqIDstwcN4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oiTAAoJELSic+t+oim9cFMP/3dsND9kA4bGyChgMfzkAiNd
yeUWkyxVTdlJiXJ/WJbQnW8zo7KOI10mpzsSAvYkKnyhCpTBkwYjmDQT6oesfaKL
mRyNpRZYb4mmQBp/J3Sp5pDxbhYVhDMJTefq0XXxpYDcjsr7c5SmFCtZNXRzXPiQ
UWCwVjPvJEIPjL+RSLisDnQ9s2I5SU6RW0wP+l3ddAPioVvqcAalAVKxAxsyHTS2
LxyoJJkhidN9UtGTJP+ctRSE3+HCKjtT+9jVdfEDShwddAbhEF9d9HXnVza/ROwr
kjdSURTqvtY7ZEurepnBhLdyPAcDkjUbg2a2kh1uBW38zFnhlewb+N2P9xrn8/NY
k9ffIIrLJNfqZ0Q/TQ4UlBXDtnQGubE+yvarw9EzbUkzr19PZF7JyAaE5yax9NHW
gDFlFkR36rGZN43tymfvMdBx2oHSrVmZatWXi7w+YJO8STc/a0VVSed9cbKoH8B0
2LrApixLnlH5qQgW/nvlEVzHHG54+WJUjBT5t2bsjdOuJRKYSsBVemeMun7WoHwe
p/zeaGHu/jgBt5uNACLslXUzX+SWwGSnnrEhhUqJGa7UB+nh67ShovUl1kMs5kRZ
qY+csR4C0F2DVA+I6khQnHHP/z/MqZfFyJq5MsZkcKU6HRM+Ne/YM7MOnDfi9kkM
R7mRUvKxHNoMsIM8MiQ+
=Fy/Z
-----END PGP SIGNATURE-----

--FLFbAWqIDstwcN4K--
