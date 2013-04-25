Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab3DYKvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:51:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50830 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926Ab3DYKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:51:14 -0400
Date: Thu, 25 Apr 2013 11:51:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: lp872x: Use regulator_map_voltage_ascend
Message-ID: <20130425105112.GM5019@opensource.wolfsonmicro.com>
References: <1366807487.16547.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QeIEYJGnsH0eC7HY"
Content-Disposition: inline
In-Reply-To: <1366807487.16547.3.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QeIEYJGnsH0eC7HY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 24, 2013 at 08:44:47PM +0800, Axel Lin wrote:
> All regulators have ascendant voltage list in this driver.
> Use regulator_map_voltage_ascend for them.

Applied both, thanks.

--QeIEYJGnsH0eC7HY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReQp5AAoJELSic+t+oim9OyAP/1zswdFueyEhA8Sdjz46e94x
gj7JfNbIcaKwLfpwRiq24j9nyjtu44oyVlrhi6+A6w1R0e4bjCEHmP7ibOqQOK07
S6n411Fy1P2MelajO+WSwvQlW+nk2AC/2c24INt6PkYoyCQCVf7PSng9gSMoK4/6
gtyyKpngTW7eernOFu8UccyyFByjSD+jxUTRE4+5Qbse0nNsKNgLq0HP0kNRFBnN
0dGA9qVE13wx22ACnaJJSzI+OVImMf/d3xFwM9513xQSSVS/ray3QH0ZXNO7+EBA
lCXrg3BOgfhT7CwFEJb+oWIl5pF8k8Gfd4e59vUHdKuzQ/8G2coN09t6bgZMdkpB
BY2S7gTK3JJWia5whfZEC3ni8kbDhnQ7IpBTUJDhYkybQP4iedxtPaHjo4P2s+Bz
IGuFwUPlN6RsTTcnaEynZpCxO52ewQQ/G7v9mmdbM8wyk2yO9dxZ+uhaVPZofySp
sAzdi9ULCRDVOPEq5ZJGKdyDMgVqtXpSTrtFjNzdqZ1+tcZ360kvO2SG8MnPHMRr
Li0AAxc/2CVMDpS5ofxsTq4vbV09d3h/ZW5plDTyv6xdQCZIe4LzeMytrjusLoE5
2GrCFeZlm3z1LqOIfakbFSIOPAGQu34/AmqJPssmSeJn8IEEL4Q4kEkTmBlXRv9c
dSdkZWwaTsQTwZ10eI7X
=PLYC
-----END PGP SIGNATURE-----

--QeIEYJGnsH0eC7HY--
