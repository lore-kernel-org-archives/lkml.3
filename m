Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3JXKPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:15:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51517 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3JXKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:15:27 -0400
Date: Thu, 24 Oct 2013 11:15:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131024101501.GA17157@sirena.org.uk>
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 178.105.202.101
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to
 parse data related to ramp
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2013 at 10:41:35AM +0900, Chanwoo Choi wrote:
> This patch parse 'buck[2-4]_ramp_enable and buck_ramp_delay' platform data
> from dts file.

Applied both, thanks.  Please submit a followup patch to use
of_property_read_bool() as noted by Mark.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaPMiAAoJELSic+t+oim9BaYQAI3xdZTxgyXZb4fzquPMQPk2
4zH7NoBsGOtxCiMjy+I+o6h2mFdDkeMqg8Iy8e2fTRH5c9mlg+pixv94kzG3W0J1
ZszjYiOYg6j6Ri4pkasv4+H+XiWtCwrzvWYM05glS0JwzzpjlxmDWQveR7X42I2v
YJs/VUby47A8S21V7hc7MFiurIuiol/pbcA3yToFwUjX6fVjFi7ikhLEYrAf2SK0
I4VtP6jjAnnezzkyJAqzs3+Rlwr3tUHjln4deAYq3DcI8AliO8lQIdvLoci59499
VPI6QpL2VjibPewLDxLMgVkWNaa0cNd+M6qjKZ3aZEFGuJ3xmLMoKG3W69Lxhqr2
jINp8ZwMtvv7Aa5Fz+Pnv2uD/l7qgKlXeEwKiDeu0o+hoHTUn9ywLAdmDiRYkfQ8
3iy2aGIduSy19pSzj0t8dTwzLIZ5xL9M4ZQZefYb6wkG+/K84i1Tnb9+ZkXXmGu3
wF53uwbUx9eCKvSXoxcuz+TLeh+l4GfbT543mDwAtdF8k28ZxFrA3to4EAO2di+Z
I0OmddkF8BlrtXs8vAHJF+bvObHKvbdd+L9MTSIRcj41u0TQlCtCzcXrjalQ+Xkk
aJgrYok8G+v149WIRGX+ypKxO8I7bUHhttwz53iwz0ALuKtc0rBZi2LkfX8QyIps
X7gJm/097vNOODRfRDqE
=NlR+
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
