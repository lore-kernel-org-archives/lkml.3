Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3LQKcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:32:06 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:55589 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LQKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:32:03 -0500
Date: Tue, 17 Dec 2013 11:30:35 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        alexandre.belloni@free-electrons.com, galak@codeaurora.org,
        linux-pwm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/2] PWM: pwm-atmel: add PWM controller driver
Message-ID: <20131217103034.GE13823@ulmo.nvidia.com>
References: <1386916910-24832-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline
In-Reply-To: <1386916910-24832-1-git-send-email-voice.shen@atmel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2013 at 02:41:48PM +0800, Bo Shen wrote:
> This patch series add Atmel PWM controller driver support.
>=20
> Changes in v9:
>   - Address the comments from Thierry Reding

Hi,

I've pushed a slightly modified version of this series. There were a few
minor whitespace/coding style issues, but perhaps more importantly I've
modified the period change check to be done earlier and in a more
generic way.

Can you please check that the version I've pushed to the for-next branch
still works for you?

Thanks,
Thierry

--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsCfKAAoJEN0jrNd/PrOhG9MP/ihQHK+8vSqMribQsG+twIHx
AmBDXlduTre+JjWc90sZiJTBkjtTLBl5M71+qKnPZJvwY82quif5vnrHLmnzDL5e
C/Gip0s6DZfXooxRpWLcOXnA0feR0aYOfCTtw9xuiNu/qnGw1motHmtrPZZBrT5s
ja39O/yfTzQAoMdjoHji1hXvZ5mo69d5dyAkOVRBE167Mhgz0tpvo3sc5WT/1ElL
PXvoA0t83REgzfgQMM1HNitJKbPCvDh4FdWNrHFMNz4r5v3cIYN8cgEKtuXUEEiP
N8STQ57DwBdcPV9Aa4rCWnnIen5vCOYO91e9zUFS/iqKLFPlqXzYxgA/tVzGkZIP
MxchVUD/dkcwyaFra1qXrSzRka4Rrl1muaBujkO+2YlPjcfOeaLv4sHPhmrEKYNm
CC0Yl8RHdKxi4sxpoXsqzRqqhvi4j8XaAq+aZsEU1UA3cWr+pHfximbAwzVi9ucK
tLkjBXrVr659pKC1utKP3YmxPDC0nLc4uIu2U7qxb0xuQ/J1R1xYLxbwRheqODVC
xRpfdDe1fBmPjcHoL1izg5FcILZYfPL2CK9uyuhM0Qghnuf0mRagx5O1XPz9Qh/h
R1T4fsECqyqVhoHIiQMX+zURyR2otZN8qOeVyCE8tedUkPQMsCTSuD0CbXQ6CEfa
HodEXgKsNNLSRVczC3+V
=LhKU
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
