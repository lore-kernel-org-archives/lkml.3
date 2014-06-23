Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaFWSkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:40:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50509 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754310AbaFWSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:40:06 -0400
Date: Mon, 23 Jun 2014 18:01:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] ARM: sunxi: Add earlyprintk support using R_UART
 (sun6i/sun8i)
Message-ID: <20140623160134.GI19730@lukather>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
 <1403275973-24259-3-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GFRhMCFsFD5VPY3r"
Content-Disposition: inline
In-Reply-To: <1403275973-24259-3-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GFRhMCFsFD5VPY3r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 10:52:51PM +0800, Chen-Yu Tsai wrote:
> sun6i/sun8i have a UART in the RTC block group, which can be used
> as an early console. This is most useful on sun8i as UART0 is muxed
> with MMC0, which is not available if we boot from MMC.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied, thanks

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GFRhMCFsFD5VPY3r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqE9eAAoJEBx+YmzsjxAgDb4P+gKbCSsrMk68+3nw4yhQ59ik
XdfcoLnp+aWt73g3IcY6dP/sxsCKz+srAttHQ9ap1HGMKbsjHH3nyNq906voFaSu
xn3116SSEPDJmG825BQ6J1jAXru9rP3kx+/oyYcz6WIB3Ia1yHdsiBzqbmXtgUS0
tEMiG1wGDccdsLX9xubMVdszTjJEZWM5iC+s8sWl3glwE9TgVDHGiVmNXgE3NjVa
29AVaG9H07Br923vbngGOtE9HBzqWxaun2f7tHwnb5fwPyx4WErM/3EJ5R2Yh9en
lpT7UewqF4rD4md0CRjbX+zj4a+7NoLtOtp5n1A2PLvJDOsKVB742W7jwP1vgbm4
M/PpUegJWqhBTIW4Xb04ZvDytX2zw8lFlCSrO5b7cBL7MZP7xi17t0hHJtByPu5P
4v+A+je34mwDkb6qzZ0zICbvJMWEV2tRsPYmW6gzeOU0Df5SbnxGS2aJ2sw6lnz0
sW0LMyirOzHKDRX5AYeEmL8WtDkRmCykubBjqVtSQu+tARiCfcpDa/vTH2VKslkX
U368Qu1rFOXV5ZICNRcqwsT6sE/9laFkq478d7jQAwriRMQkJ0zMXRySaoFDM0+U
vt/8DGuehhHtT0c0vK60o+yGtFSW6j7qlO6+w0pM4uIXtOkZvQxM5fyRs4iId1JH
ruOBknFvTVjPoMeuY1cp
=Sc9s
-----END PGP SIGNATURE-----

--GFRhMCFsFD5VPY3r--
