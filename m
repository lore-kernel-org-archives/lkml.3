Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbaAHUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:07:19 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:63998 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaAHUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:07:15 -0500
Date: Wed, 8 Jan 2014 21:05:05 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] ARM: tegra: Add efuse bindings
Message-ID: <20140108200504.GD1298@ulmo.nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
 <1387891931-9854-4-git-send-email-pdeschrijver@nvidia.com>
 <52CB14D3.2060904@wwwdotorg.org>
 <20140108133951.GD1592@ulmo.nvidia.com>
 <52CD9DFB.9010007@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Content-Disposition: inline
In-Reply-To: <52CD9DFB.9010007@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 11:50:35AM -0700, Stephen Warren wrote:
> On 01/08/2014 06:39 AM, Thierry Reding wrote:
> > On Mon, Jan 06, 2014 at 01:40:51PM -0700, Stephen Warren wrote:
> >> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> > [...]
> >>> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra=
20.dtsi
> >>
> >>> +	efuse@7000F800 {
> >>
> >> "fuse" might be a better node name; "efuse" is presumably the name of
> >> the instance, not the type of object.
> >=20
> > There's another occurrence I noticed recently where we haven't followed
> > that rule. The PMIC node on Venice2 for instance is called as3722.
> > Perhaps that should also be renamed.
>=20
> Yes, we should fix that. Care to send a patch?

Will do.

Thierry

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSza9wAAoJEN0jrNd/PrOhB84QAK1ZPKj6gFYAJFaabDtwZz9y
yWMnI+N0c3Sz/6Ps/1hGgzJAZLm4x4DUOy6k4UjP8j6azfIKhGSUMfk7NewLOIUr
7OwNvRqFlIB9n3rKEXiAp18zIhpO8OK5KpKDYeDKCw7JdfHdQz+HhkQmd3Q45a+r
ZYVXjCRbeaR641XcjfDiipscn1xyRnOXEviDBeUVh6d5T2JpwOynT5yNU/MPtPZI
CTp+r8WuGmiHjavjh3bG3b1oTw2U/be9v7AV5B55f5uU7sxdsCAmA4feakZhPEdG
TKPT9B8D0WYFymras9sqZTEM+FlFR9FYu27kqGPbvnADH+lRX9d3N/GkHzxc6Vi0
c/NDKBW3GUqa8JHcNp8ZDwsnSoS/Z77vlD7sBmuWDKOfvt0F9S5EXDYhjXw/Y7qL
Zv3Q2BLozL92BeJ2oQBFiPYldxEu6sf9GwBfSp+ZWWCosABT4vwuppYfwrvzT4rx
YQy3MIMO+yJ5e0nMYY/YN9qeu+GC+IhZDvOYpaeUVx1WdxLmkRou6V9BPNd40OCz
NigIAJsoi8eyG8QvjGbRRe33gf8o9VqhG50V4mlGfZSk8fW+TCiZlxlNz/9Qc/Er
CRKnXTDTCB/98UGYsFXDG3/MCkwNYwKVNV3pFE9SLsmNat+BpjxfpP6ckz5tcY6X
AxepF0hrfInZ5Cx5DXSv
=SWyH
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
