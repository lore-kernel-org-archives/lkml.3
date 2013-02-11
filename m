Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3BKL1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:27:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60907 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab3BKL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:27:06 -0500
Date: Mon, 11 Feb 2013 11:27:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: debugfs: Factor out debugfs_tot_len calc into a
 function
Message-ID: <20130211112704.GE4607@opensource.wolfsonmicro.com>
References: <1360579859-26684-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Content-Disposition: inline
In-Reply-To: <1360579859-26684-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2013 at 10:50:59AM +0000, Dimitris Papastamos wrote:
> In preparation to support the regmap debugfs ranges functionality
> factor this code out to a separate function.  We'll need to ensure
> that the value has been correctly calculated from two separate places
> in the code.

Applied, thanks.

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGNWBAAoJELSic+t+oim9bZEP/1C6NlGPMBj0htvP+cAtOedP
npb/ZiHFuTVIE5EL9KJ034X2zt/kW3NnYTz7F6Mh6Am57JyotgCKobdCy1g19HPm
Ixr0oOYnvvWKpC6PeFzOQSf8CW0Oc95tjYSdKs+IY0Fh7Uw6JutboMFwqHG1zAJw
fITGFXcu5dwCkzs93xDW/6RaeMiiSDhiSsBzWcT0wGxI+9dFC1kMc0Q1Ie7mmkcp
Le7NAbu8/pTDhSv0pCDxzQzc1lBx3PxMiF/eIwWhZMIT/VtQ29D6KuGpesNWS5pL
5/ie57402ZqXNyQ6gYJNg/ssTn9bEhpTiqgqZOTKDqF7RG3zUnKYnrqcL3xOgwzt
p4Pk5+/gqsCWoCq30+ifNzsEOlgS0mjcNdVTdN5rp+W+8d00yUinrShYYMBayaju
vU5h9dQrkNxIfAsCgDh3PBNf5mG3oTu/t7dTavIxeMkkeVUSOMvkVEUdSERl2G+k
dNAGrS84paE0gedhxR86M1ZEXTlnbgcW/1baBYZNLD8SfltqJY6FQtjhrpEKnSID
WdiG4ZrtqlmRvyzKmQPXZvHuHoVlKhg22g/YZIt4PgJesHWulaAnxen6Xe1Aul7z
qwMwwQVNvizJbQt3wqH3HnOSSFi6i74Kd0io29VbAjeLC8B+DNCerEQN4oJ+YWQ/
6dMecoFSAUuWXKaZHPEC
=4Wi4
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
