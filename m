Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3C2Rua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:50:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45425 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab3C2Ru1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:50:27 -0400
Date: Fri, 29 Mar 2013 17:50:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 08/33] regulator: ab8500: Remove USB regulator
Message-ID: <20130329175025.GH18316@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LcazS9JvbA+3v7Zb"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-9-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LcazS9JvbA+3v7Zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:08PM +0000, Lee Jones wrote:
> The USB regulator is controlled by hardware. The software support
> was only needed for early hardware (ED) which is no longer supported.

Applied, thanks.

--LcazS9JvbA+3v7Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVdRaAAoJELSic+t+oim9BtMP/Ru0KwKVHcgUDrDISPVn8xu9
eIiMPNmJs5oHT0xYRxoPO3V2wb5IrRDhaA0SmGRic6qsLdcF4oAMN1UMIQ4l/pbm
MFK5cteREuOvJDkg0YtFCfaaHPR2PYnGc2XPZzVsW4vE2CS+feAqmqBMYWrI8wqQ
SVndxlwW+nbbTV0yzJ1xBhPw+f9ADrjHFKDmimaWKCuFTt+8CNOlhh6bV02zGWj+
ceQEHdKRgGMta197Y6JKPN85ral4jc20/56o2+UjtorFC6WiwKXWWJ6HMFRD3oaT
nJQjv0VOZt1LBpE/DiBLste2IPmOP8j7xUfelai0B7fm6Nal9+Yl0R+dHAmOM09n
OtXJ9hy6j/aNQNBQgyxu1JPmw7xeKrUXZZ5ed6tWnspBBsy0caD6n/ss1QgUR2Ts
7WloEyGKmYfVcGLN/73zTl06kNz/LuoIngCrCr0mlnP56Or0wTzwmiyhQsdjJT4t
LGzURNxwnA3ILcXCI7OxjBZ7jguXN5eLSOcyCS6jADloVUt57T5vozbomORQ2VuW
nnS/U9dFt3LT789dsoqztcsrvGeMAMMu7kpXqlu+aToqqUJI5iIbTzG4Eb50jaQy
l2lFWZ182HBaHFs2J6C04KWBlJclHHQI7mFdV7WXP+99yANgyW/Phf/wzoYBZ7y6
nFsmVIws+zrrYgBh9N9r
=/TaQ
-----END PGP SIGNATURE-----

--LcazS9JvbA+3v7Zb--
