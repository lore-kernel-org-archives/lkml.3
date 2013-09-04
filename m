Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712Ab3IDJwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:52:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35810 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205Ab3IDJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:52:31 -0400
Date: Wed, 4 Sep 2013 10:52:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sbkim73@samsung.com
Message-ID: <20130904095228.GS3084@sirena.org.uk>
References: <1378276935-14053-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CqxttG7JecUZZO5Y"
Content-Disposition: inline
In-Reply-To: <1378276935-14053-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: s2mps11: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CqxttG7JecUZZO5Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 12:12:15PM +0530, Sachin Kamat wrote:
> Commit e398b51a ("regulator: s2mps11: Convert to devm_regulator_register()")
> intended to do this conversion. However the actual conversion to devm_* got
> missed out. Fix this.

Applied, thanks.

--CqxttG7JecUZZO5Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwLZAAoJELSic+t+oim9sE8P/j5woar3+pvWT7WIn0DhHMT6
iEDA1tPU73lM5oOTLMjK+NVNuRlBVpNL6FQqqlAnsQOGH8HaElRy6egYamvO/04D
SabrfVNxg3S2ptyjcmRBSSUKGqXBoklRkImuMilRQhjVPi9wtm9BCEsV8V3gvDGR
cM3sZssuDa8H9lhy6T3pKl683H/Zh5TiAC5hnSbMvshq12Ug0fH8l+2IbOMKxk1J
bjsYSxMAXJ1GaLL+T2JhaUVcAOwSmmlNm5BmYdTQ4rAHhYNjJXN6r5is+HY8XJ1D
dNMuRmhzYsZnq15GzF5+THmT3XCHjHuRQ/65wK9l/Hkq6oNo9cdlojLQZClUCLDX
mwJNh0TmtALzb6A7oPK0egAuVN+HUWeMKu8tfAMGC6TgEH3Anb0vYAgynOIpQysn
MCA/vTBSIztZ7aVfWkj53r72mu2iqU/3WuGP1chnIXSSaRA2NYekOG1heD9R1zbI
EHuyQ8gVIXamI5eda8E1gcWXMU9wwjwpKuBoFhXSinAeCDNHSTWlwbe6AxMl5FTZ
o/cEgS4FiRt2lB+x2nM3CeuEUjSzJGLToN41J65d7LDl3C6j8J1end9v0a/n3vRA
HjLpoyoAtLkp/mWSdXEnmOV3/vCo9Mi2cRszzTUQFO0S/wT7c4FWv3JPojvHfvxo
O0CgS9eZxrjo3hwaBPrh
=UDsz
-----END PGP SIGNATURE-----

--CqxttG7JecUZZO5Y--
