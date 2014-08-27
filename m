Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709AbaH0TXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:23:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58684 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935182AbaH0TX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:23:28 -0400
Date: Wed, 27 Aug 2014 14:23:12 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] usb: phy: samsung: remove old USB PHY code
Message-ID: <20140827192312.GH6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bygAmIonOAIqBxQB"
Content-Disposition: inline
In-Reply-To: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bygAmIonOAIqBxQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 06:59:00PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>=20
> This patch series removes the old Samsung USB PHY drivers that
> got replaced by the new ones using the generic PHY layer.
>=20
> Depends on:
> - v3.17-rc1 branch of Linus' kernel
>=20
> Changes since v1 (https://lkml.org/lkml/2014/8/14/241):
> - rebased on v3.17-rc1 kernel
> - added Acked-by-s from Kishon Vijay Abraham I
> - added Reviewed-by-s from Vivek Gautam and Jingoo Han

So, everybody agrees that there will be no regressions, right ? I'll
merge this on my testing/next.

--=20
balbi

--bygAmIonOAIqBxQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/jAgAAoJEIaOsuA1yqREMPkP/AoInxTvy7cl3Q90yb+c+uc2
Qqs0FQd81qQyRJHfzuqPyBZJCbsydBfMQxh6Kz7QEHdoWJD101YRYO5tVBuh93kO
mHtCMy0TOiReJg+S7m/X0KiTteGYu2X5fB7YvNjMli+QIM/wqTV5xWDrK9+ZtBxo
XW7oywMBgCzcVGGO8yixT98ZrmlshPOFeAefMQM9CGp6GT+rVQH8gVVBjXpjegmP
IpCxpyLCWQZPIK9TmbluaLvsBVK74ZxPDLdMLdLl681F0nYYFg/WkcZfWo6OyPx2
5qwSjDIgxvM7Wgy12s4Jhe4vK/L3X3mWGFJ2aofJZJPA1d9w51qMoxrpClhfRNKK
uBQ2imbTkZJ880zdeG/dxabmR7Q9v2RPkiy1jf/HVSV8ZPPKNODl2vLVucZJcZhk
rULmGGriPdOofLofIKKBEavL0Wrz6WmBQwBNW4T0a1jKFhs5mp47v8uYr/Rvkne/
MHAs7M841p7CRatNHykl6HZsA2E2DfdxcyUpR0AgvQ2up4jWDzISCN69eQhhw3z/
kZo/kxFece7lLDw8OqtCV+q9Te8Lagcol5ogL8VQBXm3SY3bfLIA2GhZEcewBeVl
yyoPZkvc0ZQ9OoJDCRZtSSSnlKQqbs+DFRguORvuQJ7OdEb7dzYodKeEXTsKRadz
HxjklGMmWK448/nUnw+Z
=QB+n
-----END PGP SIGNATURE-----

--bygAmIonOAIqBxQB--
