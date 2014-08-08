Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbaHHJnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:43:25 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60893 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:43:23 -0400
Date: Fri, 8 Aug 2014 11:43:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 2/3] soc/tegra: Use of_match_machine in soc_is_tegra()
Message-ID: <20140808094317.GA15852@ulmo>
References: <1407452515-2390-1-git-send-email-ttynkkynen@nvidia.com>
 <1407452515-2390-3-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1407452515-2390-3-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 02:01:54AM +0300, Tuomas Tynkkynen wrote:
> Use the new helper function, also fixing a device_node refcount leak.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
>  drivers/soc/tegra/common.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5Ju1AAoJEN0jrNd/PrOhM3QP/1tdY0KjDXYbtLv3WeKwKCRK
KeKPMqeRL6ZVrojBLYvSOPSZS3VWsHS5rHW6touRKhzzDRUS7EIolG3Wt0fGW/lE
nIxfiVol+p3HKhNupQxY1xfnQXrPriNr2Evwc1JfBP4YNsZOwFM8q86yAPomyrO4
0lXwX2g9Q4sIUMEXwmDQkKo6+SeEIvua+sNgtippJtT/nNlNG3CSFD+nt7Iz4FoY
kxzDsSQUIPvYO331TstXQYRt7ZxnlzDVnk1+ydbdfRLm4uCRJsHadKE5NmWAkoTw
Sgo8+Ph1agqQlsw5PRDQc1vLZoNr6zZrV144rI9kpsC5lrd/FeO4abUsP79M2BPA
h2zbBFnHtFXcEuce47iuenO9le0vyCcCTidnmocwMl2LXX2jjJUHytZ6O/Sn/PDQ
l/vfFYQHN2i8LLDUzv8+rj3teYpctH2mrTPJhnqwC7kA/9h3AYTn8mMTJd8H/LoB
kpsOHZ/1iRzlkiq4+nYKX43qQWd/YQhvhf5A1slp5fMBuEnqhcMkIr1DxoR6eyQw
BnWgAR9aNaDXxDzL9hP9NJxlYULevop3gymOQFLtX25jrOE9ii93nO1yDvG4lZeJ
epffyx5pChCTY/GO/yxZ6sQ5D8IZBv1G9E+y8hDJeFjQeY91EpbtFGId83Ausqk/
MZ/foczd0d9fDNXeYWDt
=r6fh
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
