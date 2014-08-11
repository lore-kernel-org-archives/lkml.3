Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaHKNjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:39:47 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61412 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaHKNjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:39:45 -0400
Date: Mon, 11 Aug 2014 15:39:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>, Tejun Heo <tj@kernel.org>
Cc: swarren@wwwdotorg.org, linux-ide@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_tegra: Change include to fix compilation
Message-ID: <20140811133937.GA26128@ulmo.nvidia.com>
References: <1407752268-18745-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1407752268-18745-1-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 01:17:48PM +0300, Mikko Perttunen wrote:
> Before this patch, the driver included <linux/tegra-powergate.h>,
> which was effectively renamed to <soc/tegra/pmc.h> at about the same
> time the ahci_tegra series landed. Fix the include path so that the
> driver compiles.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
> This would be for 3.17.
>=20
>  drivers/ata/ahci_tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6MeZAAoJEN0jrNd/PrOhzoMP/0foe0K5J7B88uuIy3j2allV
ykDX3JDvpzXGhhcon2U2HejAslIU2/aSvwBAVgQ7N3aps07nFDQNtvHgaFu2o049
rkSYLbmTWkBphAu0gfCSosr6SHHza1UZA4RYeAzJxUOMu1Gxh1CZp/T6X73rrTjU
HlwT4Mf0gk2IlmeWpPSwjDxAhRRE6eNYvrgJn6k2gmE5I5GPVVPVds28fM12ritK
duYPpYLbHnPwVWCLUsDTZ1gcqAWieEttm2+ou5B2+KIWNpLvNXQcLr4z3fA3Urkz
eRREt0Jrr6Id/Lsy32k+lmv7w0hZnN62cn8FEppHbwtUiA+CzHlmGRCnhIjmnf7q
9NLdGH+OUgrKtFJPq3o0vITfBKIh1eCh7Qa2VvqW/a2+I1hQow1zuCIDilt+6quw
2NcZ4AfAjzn1OviuhbJXm/COreMOUXArOp6E9r/v4tvvJoWrH2aDHOZ4LP3AW+De
8JzwD+8B/0ETiFjEBwBrfWlkZ8tpQcOqIQa/cpPp2Q2iJIlNQZg+lkJDYi0GoD1M
X/6PORX0dvoze4E23qIv8HHk4pngXGsW60nZCohsDn5jaxel79UO6JX0o43r0zS3
m7QYmHgYZ2GrB0NUxWsDjvkEH0s35SQaKGnGEHIoa5/pHQBSt/VrCnGKlprMqXyl
O60Dx/COTs52USIoml6w
=gyhW
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
