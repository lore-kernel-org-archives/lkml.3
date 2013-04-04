Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763401Ab3DDFSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:18:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40864 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763351Ab3DDFSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:18:20 -0400
Date: Thu, 4 Apr 2013 16:18:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the imx-mxs tree with the pm tree
Message-Id: <20130404161806.8f53f96c7197b978bfa1b63e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_16_18_06_+1100_k1W1XwSTcwo_wo2."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_16_18_06_+1100_k1W1XwSTcwo_wo2.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-imx/cpufreq.c between commits b43a7ffbf33b ("cpufreq:
Notify all policy->cpus in cpufreq_notify_transition()") and eb2f50ff93f0
("cpufreq: drivers: Remove unnecessary assignments of policy-> members")
from the pm tree and commit 180cb7d6ab8c ("ARM: imx: Remove cpufreq
driver") from the imx-mxs tree.

The latter removed the file, so I just did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_16_18_06_+1100_k1W1XwSTcwo_wo2.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXQ0OAAoJEECxmPOUX5FE20EQAKFQF8Gws5T7lGD/0/6huFRq
lyWxCfe0yrIwEIsghb9GcR8uVJWEMd8y4ZshPp8bB749iYgtil1EN+qHfTbVnEKC
UW9ZP5Jca1HgzE0+fWpBypfTcvuSfAp9S8Uq0oHvFMHc0s3IJNksa7jFhcbSFJ94
3mSo+2K7pzdzJ2cGGKgovF1q888DtFI+NOxdSdNfqB9sOKGgYV2NjavFeLm7SfR6
syEZ6vHAQNRHa7sw5bAhz7AN7MyuoEmKZf3N0Q3d7WDD9V3xN2nSK+L2tg/tdlfJ
S3CRcDRkVpf3NSK4E+SlDHUBK2rOTPQRq9sDHUiHOTUsj84q5ZrAVNw37s3t1Yf1
1cp7qhl1DITwJdTXVAtd6qlaLQmW+f63aGQeItAaGUmjNmCCyzYol5E5SxNvFPb8
PcHpH14eejm6qZ9H15uDh88HH1zK2rYfoH2cp+W9aI0BR+3xeCUO4xppdnDsm8dA
+fDF9fJc4uQihd93JW91Pu5VF9gQn+L2BAUmMFcYx9zFedeT6OO6Omv4oD4efdJd
FFxJeoat+S8rQhjZ/+00A8rgHC+5MOmOcAQJlw51tEYni3J4tPvYdTDN8ivopVli
gFrDJOplldBI5EnDGAmmppHsxOgsJI6GSWVHaJlR0eY1+lho49eEiSzQ631cmk6L
nnF1eUC2pzTCMy1LZ0OB
=DlIA
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_16_18_06_+1100_k1W1XwSTcwo_wo2.--
