Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaJIHnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:43:39 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47141 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaJIHna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:43:30 -0400
Date: Thu, 9 Oct 2014 09:43:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
Message-ID: <20141009074326.GA1010@ulmo>
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 03:11:51PM +0900, Alexandre Courbot wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> Add the device-tree node for the GK20A GPU and leave it disabled by
> default. It is the responsability of the bootloader to enable it if the
> VPR registers have been programmed such as the GPU can operate.
>=20
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra124-venice2.dts | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Are you going to send the corresponding patches for U-Boot to update
the status property if it's initialized VPR?

Thierry

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNjyeAAoJEN0jrNd/PrOhwJwQAKPejMRAURt41D8ikCOk/YkU
9kB6r3GtKcLTJLsutbnkscdQmLFO6e00wg7oDicUMsnDkv8YKeFKrdgPCAvEjVXk
F7e2UZ5T+P9sLdVqhJyU7IHgU8/KvCESwApxIlRVrh4Vm5eN5fcH7o/cFnkvmpnu
NtlVJGG4OOV5S04DTgtmQlnGZMoXYKetZ9EVDDLefx/x4/wNhHmakHmQZqeN3vvN
qqcBPO2GT49zd2+BmGEhhIkw7vLW0RRKhQyzGVScXDobn/n6teGJKD8Jz9+eDC3i
QWitD7bgRssmb07ms6H0ys3kCAOrYeHtO1B7EUYB/LQrwpQQCG8wjwdqde6YkZ3n
XVJ3TQNiOqPEyeLXSJKGlJ9z3X3jvF+6b9vyyZFsTy01CYmdDqr4QIUzA05vLHSp
FwBZE3N4HElB8GyC+WDX9vJrCaxUhh39XTr/r0yEi5RGRfFlC15ZmKlc9pKVCx8b
e+yT24BeIIT5WUZZ/yxcd7r8oYl3KC/78OlEJfjqw+Y+VnKqy3JcIcQ7WJhuOwhF
+NtOgtQwaOG695saZ2K14WwsJnTWKtSd2CbPNcZpVkBkoHGLQV4R4FEy7N0d+k2S
w5R1qJn9TJ+LLTbGD+cq9L+J8rWRU+BsOQwrVrwFS0EaDgwNCDJF54n/EE9bDgjS
94mPClY7xtG4yrLWZdAa
=xumw
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
