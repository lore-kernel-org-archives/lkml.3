Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953Ab3DBWFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:05:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52963 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758195Ab3DBWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:05:34 -0400
Date: Tue, 2 Apr 2013 23:05:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: dbx500-prcmu: Remove operating_point from
 struct dbx500_regulator_info
Message-ID: <20130402220515.GQ23065@opensource.wolfsonmicro.com>
References: <1364908104.9803.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rG09A39trvEtf3rB"
Content-Disposition: inline
In-Reply-To: <1364908104.9803.3.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rG09A39trvEtf3rB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2013 at 09:08:24PM +0800, Axel Lin wrote:
> operating_point is not used since the initial commit of db8500-prcmu driver,
> remove it.

Applied, thanks.

--rG09A39trvEtf3rB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW1YSAAoJELSic+t+oim9wGQP/R+hH/X9VfAhcfDfk+iI/cAw
0Ri2I+OmlSFXvh358sjJ/f91P3bM8dNwQDXPVrRQAlgXTRuL17ntHVSfsOHSAvF1
0oVz9qEKBqrO3RBF9ErkfYud/eZmfPwHmNIOlMZuJ4GGgLqo8PtwkaPHLfCCx7tH
uTb4AXZu6Zp0KNlur3Hj38kR7iT5m6Ae98Qhq8XUB5fcVx8viHh7Kjolb6K6hRTE
N9ZIC7uburi/6oWdBJwKl644jTI7R3bZ7yd8LuDcJCkC+qWaKX7ndbBmjxlopknT
omlJnd1SvDaEmPzKH4an2lzWljw7lTacGiiSci4UpX3+eax+mp6elaHK2T02VtW4
PrDWPlA8QS7RI5ZA7U/+r0jRRqY/kYVB5+cfBH+kmmRU52rInWcZSQ0OFxjtqPtV
cjn+ioNbH4uE+Eqmd/ttTzi2XGhx9pdocqQ4SVQ58+KHc6+MaYIlgZaO+29x3ez2
5AU/5Y2e5rsYJG0IGDt3pn2ySADHZBWONqGNdOxF10u85xFwnsK9eNVKFl43cE2U
T/O56Izhvjlsw2ofe814mmZXxMsi2wRDLxxTskh3VL9ZsjqQWy35CCv4LvXoKfl/
UCvhyJuec0bmQuzrvBje0RttoTLWhrp4h+sgREWq+XDkjy7n8ec7HAiGcS0MpzCL
cM4fIfDNNfChwXNfhxgr
=wqxM
-----END PGP SIGNATURE-----

--rG09A39trvEtf3rB--
