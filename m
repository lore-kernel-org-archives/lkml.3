Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbAMKMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:12:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50596 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbbAMKMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:12:00 -0500
Message-ID: <54B4EF43.50300@ti.com>
Date: Tue, 13 Jan 2015 12:11:15 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>, <tony@atomide.com>
CC: <plagnioj@jcrosoft.com>, <bcousson@baylibre.com>, <hns@goldelico.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] arm: dts: omap3-gta04: Add handling for tv output
References: <1417642402-20538-1-git-send-email-marek@goldelico.com> <1417642402-20538-4-git-send-email-marek@goldelico.com>
In-Reply-To: <1417642402-20538-4-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="FsKh27OBDuG4WVkpv3ap5Q76vqlvrDUU5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FsKh27OBDuG4WVkpv3ap5Q76vqlvrDUU5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/12/14 23:33, Marek Belisko wrote:
> Add handling for gta04 tv out chain:
> venc -> opa362 -> svideo
>=20
> Use invert-polarity in venc node because opa362
> is doing polarity inversion also.
>=20
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  arch/arm/boot/dts/omap3-gta04.dtsi | 49 ++++++++++++++++++++++++++++++=
++++++++
>  1 file changed, 49 insertions(+)

Looks fine to me.

Tony, do you want to pick this up? I can take the first two patches via
fbdev.

 Tomi



--FsKh27OBDuG4WVkpv3ap5Q76vqlvrDUU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtO9DAAoJEPo9qoy8lh71qwgP/0WaNBxbpL5Z0jyxf2NkpKHJ
C5bKasUpileQUe4LxHe0VZzwiOrKDC4RcpdYRoo2c5+MrEmVRCuPEYWx64h2Yvvq
kLc+aJH+vmSBfej/CNgieRvElDaPy7ESzBxSIZT1znAkWYvzeyWclp1SX98cgJgg
GnB/bVSN3xHWuKfYDIp/+yyiwxSHLuKTsjPCQ/fEmovdXL35vZSePmeQEO6vzvol
AltR1EC/Nvgd2Yz/fiZtStwT8rKrsDV15QufnLQf+b5maIFzO4Erd564pbLIOu2c
xOoG3Gwc5lWlRqBiZxL7Q6wJEOGO+IBOnmw+btiJbemeWOuLmUl0Owp/npz6c4pr
wq5jJ0SHxe5XksFq9FKmqoBK03WFmv8syRtrBZgFlI8vidJGUw/4fpPMx70c5lmB
tLoe6prLlCTxebqamCTjwwtROWBkQg9CRljzR5yRjUPWQUoleMZkvdSjMJWedfGH
/Nm51fnpzWE59uRMd5hnrmlVG3t7dN6YDKvlrUFDIP8Gvv9Ep6s16I0VIbf4huo/
Yj7jyl47LMpewUCzhragJ2anvpTjJJFNcWdgLYxTT7mokgA5+YTsPge94HQ8Sfzk
urxnggTsg+3tEQ9qOn9HPPcfs0YsPIXJyjl3so091pgLHwyneOLAwCgQ5JOeskoc
97Z7hmnsaRcjHVnc0Pl8
=sNxd
-----END PGP SIGNATURE-----

--FsKh27OBDuG4WVkpv3ap5Q76vqlvrDUU5--
