Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab3BMMxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:53:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57465 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933763Ab3BMMxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:53:36 -0500
Date: Wed, 13 Feb 2013 12:53:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: s5m8767: Fix dev argument for
 devm_kzalloc and of_get_regulator_init_data
Message-ID: <20130213125333.GC5062@opensource.wolfsonmicro.com>
References: <1360718985.14930.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <1360718985.14930.1.camel@phoenix>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 13, 2013 at 09:29:45AM +0800, Axel Lin wrote:
> Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
> of_get_regulator_init_data(), this fixes memory leak.

Applied both, thanks.

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRG4zDAAoJELSic+t+oim9MUIP/1D3GXRkSJk6fLcB3t9+Wu2B
LEejcxjTbf/GhiGZ6rBBuaE+DDrtvzYAIbyBr4+0j89SfUDGsBsLPfurpcb+bdcR
UZLH7kNIV5xNlkdIidQBOA+uZHjV4WiAJVXCVawCTzQtyDD0eutqgDa7tcC2NqRs
t/iiape14DPwKgH1NfbBk02Y+0GyVMOOXKTZLlMNaVIJv9fRQGhjVjMypMvj+bar
g+ClDPeOnHriHQkQq+RcuDPYQkayNhoK5RC81/nGLP5q9J7UcLBYSYJ3HjlMq8xh
zCcanKuRONItgwUEe9eWFbdm5BAwchQMMTMRoAUeCPb+vuMVO/+KrYWnfKBNnqzF
3ZsBOuxxQ3WMmUv2sQBfDoFN8qXfaogD7hm2wgj/qmMavGmEExV3dyz/gur+YDTt
keQE6pZtDysHNipXlQFwSYSnXPYx6nQ8nwRwrmcCviFlTz4iqeUEY3x3yEUddIWQ
upWSgDdu7q7YLhYHuC9YFrIVChyFFIbbx/XAR47G7Rl9UTsmnEPm8tNlAI1nIwcW
vQ0Xd9JZeUPgGEkHhWMYVs3Pn1bTQualWrwkxK9y2yR/VPA3/aXmAmC0JCb/bWxe
etf2nZjfYiR6Gr3c1Hn1NaqC6JW5iCpE/YuPGms1NVaR6TKn6hwFHigJu9HUo28W
V7GNrnBJcsz9R3836cfy
=8T6Z
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
