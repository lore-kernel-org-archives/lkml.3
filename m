Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817Ab3DCRqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:46:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47914 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759397Ab3DCRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:46:02 -0400
Date: Wed, 3 Apr 2013 18:46:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: lp8788: Implement list_voltage for
 lp8788_ldo_voltage_fixed_ops
Message-ID: <20130403174600.GM11305@opensource.wolfsonmicro.com>
References: <1364829984.17176.1.camel@phoenix>
 <1364830128.17176.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8m/hfNLtAhX2NvnO"
Content-Disposition: inline
In-Reply-To: <1364830128.17176.3.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8m/hfNLtAhX2NvnO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 01, 2013 at 11:28:48PM +0800, Axel Lin wrote:
> For fixed voltage, we can just set min_uV and use regulator_list_voltage_linear
> for list_voltage callback. Regulator core will call list_voltage(rdev, 0) if
> both get_voltage get_voltage_sel are not implemented. Thus we can also remove
> lp8788_ldo_fixed_get_voltage() function.

Applied both, thanks.

--8m/hfNLtAhX2NvnO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXGrRAAoJELSic+t+oim9iVsP/0Zcu2cBBlAMqRpTsRqNtpLe
UoWTjrzHgR+Z4TKUcM9YvbVGY/knwI1MhhWgEZ4Ni8YAfe/di2rsCzlU9fFYwHqS
UFuneqaCP43cVuc2iHS2FSrIUx2CyKdzWkCK7kSB1m2BkuGJd7tEeuef+lCoOoro
PN76tXlLXe3BTPLWDxrIHNcXkHIvTP71vH4xGIi7BTk6kYmzxaaI++IHHt+gXGNd
Ft2zZz5cRMzCcx9vOScRmOT9ZBgJmfQQ3cd6aOP3vqFVrk3tjUWzHVEtIIDNu75V
8NKT7+OHE5/xzng+StGDeaJKwCYnUxujf10bdeP6yhdhGIPxjFC0h5MgiWGEIlSq
NWHlvTpQ8nH/kdpCT+egj7RIvqzNDoDCM3DWxY+qtchGmnGAaowfmvep82pEsgis
LpBJIUysNsqwsCsDNeAHxx1YxOaoTSlUa5J/YQpISeW/HSFOjyuHyer8QOSEypGy
w+QD0Hqf3SvZTlTtxaBbftbhonbnV/buIZ5JAzsZ7xCS37aojUAIkwYNg360/PDh
2mBYBeomYn1eeItH+T5nxwcEdNItj85dIEjbFIqcM9ANoOd3e6WQncaiPJpO/w1/
djQXmkEHUfIurMGif4fFWLv8D5XmM17cOfLGo1HUX4aJytrlSMxcHPmkp/l648/8
rpgdtW1lp7H9ByY6HOkW
=kaVq
-----END PGP SIGNATURE-----

--8m/hfNLtAhX2NvnO--
