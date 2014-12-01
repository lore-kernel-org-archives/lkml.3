Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaLAKBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:01:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57328 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaLAKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:01:05 -0500
Date: Mon, 1 Dec 2014 11:01:01 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: swarren@wwwdotorg.org, gnurou@gmail.com, pdeschrijver@nvidia.com,
        martin.peres@free.fr, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND V2 PATCH 1/3] soc/tegra: fuse: export tegra_sku_info for
 module use
Message-ID: <20141201100100.GB20174@ulmo>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I think the subject doesn't need "for module use" because that's
implicit in exporting a symbol.

On Fri, Nov 28, 2014 at 07:12:58PM +0800, Vince Hsu wrote:
> Some Tegra drivers might be complied as kernel modules, and

"compiled"

> they need the fuse information for initialization. One
> example is the GK20A Nouveau driver. It needs the GPU speedo
> value to calculate frequency-voltage table. So export
> the tegra_sku_info.

Also please wrap the commit message at around 72 characters. If you make
the lines too short it becomes almost as difficult to readable as if
they're too long.

Other than these small nitpicks this looks like a reasonable change to
me.

>=20
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>=20
> v2: add more description why we need this patch
>=20
>  drivers/soc/tegra/fuse/fuse-tegra.c | 1 +
>  1 file changed, 1 insertion(+)

Ben, patch 3/3 has a dependency on this one. Would you prefer to merge
this as part of the Nouveau tree or do you want me to provide a stable
branch that you can pull in to resolve the dependency?

In case of the former:

Acked-by: Thierry Reding <treding@nvidia.com>

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUfDxcAAoJEN0jrNd/PrOh68MP/0Ju1GABQnZL6rdowR+rqnX/
lgaibyR9GtynKJkK2fwwaIj0W5m1wjdhcYLfy1GlC3P7DBll+EYdIlRSU6l6eowK
oheIh4quxcMBmleYjgNNV6af9gJu9eCo9v52gYB55vuwVtcknliewVmgII64LK14
p+x14cIrxYgtZqqllAWHoYWJf0AdpUDaM5cxbjqk/j+r+9fkSFKz+sooAxKU70Y6
+ySxK3+bi5MRTxpwVJ9RHRCNckgH1sTU0UaENn5x2Ze/LE0OkuqM1/k4ZP5dVKDj
ZWAd4KQ+O37C+1wWD5OCw9Q5LknyG7na5o+eFAgvuVmRW36YbEiiLhN4NSVMYvH/
9atUogCjJ44k4zM3K1fEJGZ8bVOS0J90K6/oc5oz51HxC5imt370TryRjrQKds/u
NGvU9p0fNiznSxg55gSfBCaOU88JwUpNxPdbd4Qz6RMrizms7fnBb2pqCrIcj084
4oTox3dyWeLkFEIAmgDCBA+LmeSAZ95XbdnzqkQbKIKMD/Bm2Z3f8mzXg5l+zNQ7
wxIaiP+YDi1SGxPU9MdsVQzD7folegHz2gFhi0ym7xC+K0D6TlMamyIHuUFyxT/w
9Hj147/qxTJURmmqH9e9L+lKE+B4P4twSzbkcidVsJLrXA5BzM2JIleicVXUZiOY
A0nEceRvSjL/LN1wnHKw
=z4iy
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
