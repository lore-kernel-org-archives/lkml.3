Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3GXMcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:32:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41689 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3GXMcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:32:32 -0400
Date: Wed, 24 Jul 2013 15:32:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, <balbi@ti.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/9] Tegra USB cleanup series
Message-ID: <20130724123229.GE17962@radagast>
Reply-To: <balbi@ti.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
 <51D1FCBD.6070104@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Content-Disposition: inline
In-Reply-To: <51D1FCBD.6070104@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 01, 2013 at 04:03:41PM -0600, Stephen Warren wrote:
> On 06/28/2013 03:36 PM, Tuomas Tynkkynen wrote:
> > Hi,
> >=20
> > Here's a few cleanup patches for the Tegra USB drivers, to be applied o=
n top
> > of Mikko's two patch sets. It mostly deals with removing all usage of p=
latform
> > data and using standard helpers and enums instead of Tegra-specific one=
s.
>=20
> With the issues in patches 5/9 and 9/9 fixed as I mentioned, this series,
>=20
> Tested-by: Stephen Warren <swarren@nvidia.com>

so, do you want me to apply these myself ?

--=20
balbi

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR78ldAAoJEIaOsuA1yqREUlgP/iiKDniH1mdj7o9YkBWEDIIn
TilCUbtwagjEaoh81R7qiKaUBEisvmM2Dek//eNkEZ4zU4U8MLgMuzcuQDyQMNNI
jmncQVJAaVqVwmulgbfUfzGaGChZ+XGkTOXX6If/9udSn/Q+m/dHoHxnAot5J5i0
f6ZbLg9QOC9YsRYY+xUlLP/zwBXreWqwRPJnBj7LMMYpXqzISbXVMsa5Zu8dVJ7o
M8uGm+kHxelmsyNfKmUccLoL02fFQJt0PF5mygybwAtHJ89827m3IXuo5oKc6VNK
/am5yhxbegLS2AVgwH+CkUWa1nekGsFYpA9omZ02fEf9FV0LKjYaAb23b4aitF+H
Up+FYT7XLAcd+a5KV9BhE8mfIQB2RvSgX5+z2xYyV+kiBn9Z6XD6Zrp84LkotAPx
tldWLhIaGMJArZwOy7lwC+SOUOOR4m8NzbJLrLbTVhH/ASb8wEs/+bLnaaFxO5VB
7GFmiMzVHQgMYLbi2CKgMKV09/knlijgPuM//wq9mXHCOyzU+dlkHykeotv5vd/p
yPWSfv2ZBYJcBSIQD6q4e6/w67mEqupdNNujysB+i+fcK317Ny3Tldm8m8xcS5+Y
winExlPbP1z3aaWLk8dBLLDKq6rOxlj0Jxf/evqfw+J8zy51AW3konwXUy5nSmjn
AvlHD33Wq4q8bVWbesHX
=rxUk
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
