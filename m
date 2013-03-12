Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab3CLSma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:42:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48297 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933370Ab3CLSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:42:28 -0400
Date: Tue, 12 Mar 2013 18:42:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm_adsp: fix possible memory leak in
 wm_adsp_load_coeff()
Message-ID: <20130312184225.GL19942@opensource.wolfsonmicro.com>
References: <CAPgLHd9K-jMNYXY=sTkANCfzk_fCAF8arZUZHJmvBRAnCx1SUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <CAPgLHd9K-jMNYXY=sTkANCfzk_fCAF8arZUZHJmvBRAnCx1SUw@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2013 at 12:23:15AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> 'file' is malloced in wm_adsp_load_coeff() and should be freed
> before leaving from the error handling cases, otherwise it will cause
> memory leak.

Applied, thanks.

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3cDAAoJELSic+t+oim98uUQAJAI2mUlJEXS4YjS6GrGS7Um
RRv8fhhg15WtpnedJsr34VfUuhUwid4YY/K9h56MUcNPqtc3JN/lqw/RJ4XIgHa1
ojuT/pc/JXaCllh3Ya0pwVv/+DNyWePtW26OFC7IJebRSuKOhTM1lae39TrrRu2A
eYedpCEU7FUWx0Z8CshXQjY9TehvTLs273HDrnoHzMoUaTbLauTNUfLvpdT4jB+8
SwVu9ncAQbYOdaSq1H9qZadmUN0v2kjnYaWS5GCDdIYjn1i4XrzmFfceLr9t/erT
Zcxvc1vLjGfNmMeWRqIIQp7TTv4gUkQl4Cy2rf3MjpTZXPL4rEwGxKCWFe+60akh
qtevNBPpo7mcmk85XHbSK5aoHP11SeTYe7/3XYpPNB4ruSyn9Fvcou095qDUkZ5L
vPFsF7AMJxAPMa7bJR3VO6Ix0xvpydn/CBRJp54MibK/raJAfTccYLILTuENzeW2
wbUELCCahG/pAfabOA9ApqPOPAFT12l3wcbmv1jrDX9sBCn7e2sv1oKpM/ndkHUD
pRDrpXdSTeITWBWAEzrgp88RkJvuakS6v1WNDnVY9YFRyg2KrqZj8o/H3pmfgJGt
cd1cQ//6Mop3JS3HxesHCyUAiiJVFm21Z4YRq5CDtBQBn01hLCyH/ED7Qw2Lwz1l
VIFKfxFDeIR1X2SIPwTE
=mYyn
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
