Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaI3BqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:46:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:48673 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaI3BqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:46:04 -0400
Date: Tue, 30 Sep 2014 03:45:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH v2] bq27x00_battery: Add support to bq27742
Message-ID: <20140930014557.GA16998@earth.universe>
References: <1412025911-26809-1-git-send-email-puthik@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <1412025911-26809-1-git-send-email-puthik@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 29, 2014 at 02:25:11PM -0700, Puthikorn Voravootivat wrote:
> Add support to bq27742 in bq27x00 driver. bq27742 register
> addresses are mostly mostly the same as bq27500 addresses
> with minor differences.
>=20
> Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
> Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
> Reviewed-by: Rhyland Klein <rklein@nvidia.com>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> ---
> Change log
> v2: Fix flags/full capacity register read

Please convert this into an incremental patch, since I already
applied v1:

http://git.infradead.org/battery-2.6.git/commit/628ef02c56e515430dd8d843912=
6dd0ecb8ce8bb

-- Sebastian

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUKgtVAAoJENju1/PIO/qaD8EP/Aqw5TyaUWCYtj3foQbSPVfs
Y8kcfO9a5SFuGLhG/VeyxRIUu0AkphgJeHzWQdTgBfI6IJ1AAKsEghAUxc1uyF2H
nYqNXPoGrWla/GCyQwbm5/bNCcQfJqQVwvKLeV9Uj7/ng149sy0i4IV+S/5+73wI
8BLWLQ2XeWft+kxUonVhLQkYabk8v4whroEPu9w5zbxXHy7vjQAg2FyHC0lzhNfd
YA9PSwfwTHKjhq3OJxmg1xek2xhUu+kq4LBPyxFonSXrWoqiW/dgHY/5IQ0RQ+4Z
YFMBVwPCaaVb6L+GG/EKt0jKobzucwOxKEYVNd6xsWlW/vMUZNFLmmIDGwZM5E26
yZ7rUuSvIDnG6YR2Sxgy/3RWRgWgFzMtKBW17c2bmOdpET35P7Zlz2Grbvs/xFZR
YT7VFUTyiTE4cy9E1noNvuQupItgy3VugfNIcwgKps0NRPNPHoK+vQaJX9sVefUy
MXFChTnoQdx4tZH/F7g8ePvKe0lvEd9JutpkU6YJn5Cku8i4yJlpSPsuutG7eTGz
d2xxBbxGBSQD6BFSzV2CvrnvALKjHTgujtPeo6O3Mfp+vxFwsaueVy3JHLTcWnOt
0pP7LsBd3u4VtDFyffK148u0AZC0ODjtTC7Q2aVKijCxMx1Ey96InVmvTiFQuuYx
SHZb/1S+U9rXmSE7k6mo
=whSP
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
