Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaHUTVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:21:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45483 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaHUTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:21:42 -0400
Date: Thu, 21 Aug 2014 14:21:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, <tj@kernel.org>, <thierry.reding@gmail.com>,
        <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: ahci: tegra: fix build error
Message-ID: <20140821192134.GO11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140821190824.GM11146@saruman.home>
 <53F645BA.4000402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nLMor0SRtNCuLS/8"
Content-Disposition: inline
In-Reply-To: <53F645BA.4000402@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nLMor0SRtNCuLS/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 01:17:14PM -0600, Stephen Warren wrote:
> On 08/21/2014 01:08 PM, Felipe Balbi wrote:
> >Currently, ahci_tegra doesn't build because it includes a file that
> >doesn't exist.
> >
> >The problem is that first commit 306a7f9 (ARM: tegra: Move includes to
> >include/soc/tegra) renamed include/linux/tegra-powergate.h to
> >include/soc/tegra/powergate.h.
> >
> >Later commit 7232398 (ARM: tegra: Convert PMC to a driver) renamed
> >include/soc/tegra/powergate.h to include/soc/tegra/pmc.h and neither
> >commits fixed drivers/ata/ahci_tegra.c.
> >
> >Fix that so the driver has a chance of building. With current kernels.
> >
> >Cc: <stable@vger.kernel.org> # v3.16
>=20
> This driver first appeared in v3.17-rc1.

hmm... weird, git describe told v3.16-rc1 :-s

> This patch has already been sent, and apparently applied:
>=20
> https://lkml.org/lkml/2014/8/16/36

aha, thanks.

> I wonder if libata/for-3.17-fixes isn't in linux-next?

it is, it's just that I was build testing my branch which is based off
of v3.17-rc1 as of now.

--=20
balbi

--nLMor0SRtNCuLS/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9ka+AAoJEIaOsuA1yqREQBAP/jQXcse3UFDEv0rNPXj8Ly+u
wwWKgy7ULlslpnLRVgUieKE2BZjn0zj5wy5CYksE8rRocgdfy6nmdvPOjkhD4zlm
dFJ1Phwc1/btCWMIYDTmkvO03HKIxeM4S7PQ+qblYGVuwgR4/gpwMKPj/jx3XRvF
pKfXA7pkhsxQPNdC1/TtPrSfVQYDJdQVmbBZMAohcFxj1zC/Tu1rKB78DYgvJrhb
FBREv1lPH8SCGxOzRGfBfM2ZgNBMa+mDflCMbhDxpkTIbJk9a12lXqa+6LFtPO5o
thIEqyVw1uMhlPBb97oKqATfwUGpqqCkjbRtBfPQ5Kl9BHMtHyChYWJt8eKoTeST
FNMImlC27e69Se5K5kRIdnR4SfqKK94ChN6t3ZdHqeriR0nweYVI2nmhQWGdW25K
apmcMUWZnda1sAj2XCFI6C70EdyMjN0kBhXlsFgZdRemEmc5eaYvGOUkwm4uDpi/
q7Xmr4PSAiBQWeq/mtMFhVI1owXp1kUt26M4zuwZR6SGc7ri3MDWpDFnYPAhljj/
+AC+6pQrb5hrIGZXCKZqkhod/mJt1yyll1SpchyaN1YasX7kUN5iXGO8JiVadg5D
4PamhaaQrUtPrR0odM4Ug+/izG9uZx4o9JL4LNhJ+On/gOT3TWj9xEWadwqiqjkg
8rYV4sZdD9ZytgVOhOYT
=V1g7
-----END PGP SIGNATURE-----

--nLMor0SRtNCuLS/8--
