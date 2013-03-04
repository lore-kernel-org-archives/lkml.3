Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3CDKYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:24:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3CDKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:24:54 -0500
Date: Mon, 4 Mar 2013 11:24:46 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux@prisktech.co.nz,
        grant.likely@secretlab.ca, linus.walleij@linaro.org
Subject: Re: [PATCH 1/1] gpio/vt8500: Convert to devm_ioremap_resource()
Message-ID: <20130304102446.GB15580@avionic-0098.mockup.avionic-design.de>
References: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <1362388179-26841-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:woCZZ5nThT+Z3cfTrUGyu1D/qxPXfHl4nKRDR09Oobi
 h2yNEAd3rZKhmssZaN/0tkNSanC73+tFzEK2OOSo9tH/LKQkiF
 OATdXz71yEahFE440IghgPv7lDc7sv1d7jtr3A/Lw5cEJ3+vJJ
 8S/sKD8HnrlO/MSMpdJPgYZ6PJmUjqyIg7HFzw6eoFxAvawm3Q
 JYuAynrFY9Tqyebp63BlQWf/KP6fe9d9xKKFu8GruXSbaNFK25
 8CFR83EXAs29MHKikrsxVwek93TYdFMbG+rOiOMwT/sdMGw8k+
 3VwXb5dTGqo5FyiOT+x1BG/AVeee93dKzc6HJaXSo4Z5tMh493
 29ufzjsfTzrcpKvYxH1Ad3Bhtre3oPMhejTrmvPxRuQF9WHwzE
 btSbQQ4Q/P3badr3MLYGjTap2Di3P2pYTBqTcmfXCwo7Wc4Kc3
 3I9+Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 02:39:39PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
>=20
> devm_ioremap_resource() provides its own error messages; so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/gpio/gpio-vt8500.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNHZuAAoJEN0jrNd/PrOhrSEP/0UYcUxsaSgfzp0JERSIuc5b
deVgsDDyLbYRydwvX7pfRPAzgzl/3A6AaUAIIo7QrfCbp70Qh2K+6vfn/rKyAkwz
nA6fz0xGeowVbLYsjngh6WXvZOfCFfygrb36Q6Bn0bH+Xc/o86d7hiLSl/DTGJHK
aPCTfksP8fx1YGYTYWwTvrxt37xdEszRlbUa8ZIEhic8Wn+NcBXRyYDZTlHzT8en
+s1XOwmj9mpSoBu0GCMlGJ2rpRsCwCGqs9COHP02l1sZ/50Hqvf/SCEyMFUQ7j0k
VxoJJRdCLzKJpSRjRQeQbhPkJQ019NnWBujMYGfssJNTjqFj0CUu+t3cxL43co+2
VclkZjcM5sGbpmRFl0eJOoJFjXfE+e2395fur+uXdO8kW5ztnW/ZN3gc5kGj8omu
FbmIWMRb2/M/B4+7U574nHVJH7FiU+cD9NHA8Z/iNK7hQqtWv+6rnGi5mP+M7efV
e25DMUgx3x4m75TP2mgrgwf29o5WtNCE/cUj5NPdyyyXL97wM3UqyjZF2meBTgMT
8jvk9f9+s25lN9/fligXf04gH5bPU7RL7p1BJWuETN8Jsn0OVNdYnc7ulsLjO12v
C9oyb3Ok5Ftv9cwUcn3YPwDP7yav+WdWucTecc6ooGNbl9ljo5FN5/ICepMSSmuY
HWT4lPp7NJZvheB1E0v5
=jYQw
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
