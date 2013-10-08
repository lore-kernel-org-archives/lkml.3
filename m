Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3JHLeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:34:22 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47875 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3JHLeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:34:17 -0400
Date: Tue, 8 Oct 2013 13:32:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Erik Faye-Lund <kusmabite@gmail.com>
Cc: linux-tegra@vger.kernel.org, Terje Bergstrom <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: host1x: check relocs after all gathers are consumed
Message-ID: <20131008113212.GI19633@ulmo.nvidia.com>
References: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boAH8PqvUi1v1f55"
Content-Disposition: inline
In-Reply-To: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boAH8PqvUi1v1f55
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2013 at 08:18:33PM +0000, Erik Faye-Lund wrote:
> The num_relocs count are passed to the kernel per job, not per gather.
>=20
> For multi-gather jobs, we would previously fail if there were relocs in
> other gathers aside from the first one.
>=20
> Fix this by simply moving the check until all gathers have been
> consumed.
>=20
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
>  drivers/gpu/host1x/job.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Applied, thanks.

Thierry

--boAH8PqvUi1v1f55
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSU+08AAoJEN0jrNd/PrOhU0gQAJ48g2ZR+7ZFvyZMwz35jHOU
xYpjk+H5VE9D0CpXpsaQO5OWc9dIgRFgW3vmwFWUCwFTyFQVuFUMO9bSzDDL4hR9
nYVMv3/Q/J3Z1Bq7dwk7UEMJ80U/Ag+ZO+tCwzdlAJSK9v6a3F36cKEfE6ZBOQpO
9TfNcrgwb2G2ILlnp2qDlp8Ch/h3434joCBgD7ZnM0Q0XiyxzMGpXHt0fU8foxgi
vsNiVPwjORFB67wEwelZ1I3w8GjNbDndZw5soBZqfEhq4kThYSQaRrKM7y7pz6Zs
YWbdqy7w52Bx3dlN5WfJG5m4eefHJDRDeJwR12wM1hLB5tqLqqeLuneb2QwdiYLW
MtolFjOHVO8rxUd4ZtMAQRvPaPmMTvkrd6tUdoaoHc9asQm2BUSr6CbLNYW5okyR
jh4oc1eaA1o3LOVTQdtiQgjfqUnxi41x98mWDpy8PrwkNKvNs7fyP2djvAxzp8YB
JfoUrXJ/PhNf9MgZ98hdHs3uMTiOFJtWDF2xXxddwZ4LWjdMlRc4CQGEMU1msFRz
yR429R/OgrTsFwLPvuhHSbAy3583klnT/ZDeVHenEuZZXSipQJNSyVl8t4lnOXcC
3fbuaZVi5TJ51cniN9GN5XQst9kImrHmV06kBUY4PSDgczkE1w04hPL1hGYUTKQN
F5dChSNN/I+PyDEgvV3Y
=QrTF
-----END PGP SIGNATURE-----

--boAH8PqvUi1v1f55--
