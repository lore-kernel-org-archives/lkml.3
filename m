Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3BEREt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:04:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44465 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949Ab3BEREq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:04:46 -0500
Date: Tue, 5 Feb 2013 17:04:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] extcon: arizona: Remove additional increment for
 jack flips
Message-ID: <20130205170444.GI4720@opensource.wolfsonmicro.com>
References: <20130205100840.GA21629@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QPZaqi6af6gbSrAE"
Content-Disposition: inline
In-Reply-To: <20130205100840.GA21629@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QPZaqi6af6gbSrAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 05, 2013 at 10:08:40AM +0000, Charles Keepax wrote:
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

These conflict with patches I've already sent (and which I already
posted).  I'll roll these into a series and resend.

Patch 2 doesn't actually seem to reflect the chip behaviour, though I've
not managed to track down why it's not needed.

--QPZaqi6af6gbSrAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRETulAAoJELSic+t+oim9bTUP/jMf3AkjA+cpdPjajpC7fuXs
5yUiU9DfHKTkzxBCAzO3R6gv4Lt0b1z3tu6zXefiVzdUHdmjBEf3p9UtzoDSqp2g
KZQYf4EdHT/0AlvRQ2Uw0yRlhDQ8T4z6XJcQr8vIUxn+5YV3oeT2hBEa8XTE3uOd
Wm4P3gPjVgGM5YjiS7tobCWHRIMJyyPUpP0mJL/kWTaowFtxfg13PlpuTBUEc4JB
bp/1cD+0/fjM+My0iKXWReT52HHLn1knbBdLEFJufZSkZS3pLix8/u5aKuATyEKW
1V46Brv+Ozik8zQGcDrV4jxEivf98iXK5XZRG6mCz1PkFwvzj1cPUuDiybd3pOys
a14bHXv6goTfPLfpzPCPIZksex87uzK59b/B6G8I3QEmQSVJ361HsvlYZ0qAAgQA
oVran7xshwY2NrMunz7ehoGMh6B8Xblax6+xJ6UKGjV6vWugtuNC5crJZZ5ACiA9
8C29Q4ekCwdShd7PA7vaHWUNd1xWYIvHjklyPz96NTRQKspWgX2h8M/ktmYn/44S
SwZN0tHFcWgBgpYGUjWW9EAVBsmS1vtzeD8vvJnxU82oycnhq3mn1yzeZA1toQrE
XblKPV0W5o30XMn0Cyjju52v5gnPW4C+mf0D7jWFPzcym9+7JSAPBeDluHk4CeQ3
Fxb2wZb+nAiiMsqG6vN7
=vhsI
-----END PGP SIGNATURE-----

--QPZaqi6af6gbSrAE--
