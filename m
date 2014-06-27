Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaF0JDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:03:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60966 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0JDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:03:30 -0400
Date: Fri, 27 Jun 2014 10:03:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20140627090303.GB23300@sirena.org.uk>
References: <20140620203858.GA14718@himangi-Dell>
 <1403849258-21779-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XeHo0rFSNt4mQX/E"
Content-Disposition: inline
In-Reply-To: <1403849258-21779-1-git-send-email-olof@lixom.net>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap-uwire: fix compilation failure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XeHo0rFSNt4mQX/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 26, 2014 at 11:07:38PM -0700, Olof Johansson wrote:
> Patch 'spi: omap-uwire: use devm_ functions' (b3f6a57506b8) introduced a
> build error due to a missing include file. Add it.

A similar patch was applied a few days ago.

--XeHo0rFSNt4mQX/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrTNEAAoJELSic+t+oim9ki0P/A7Q0H4ph4cBx8iqUpyhV3D4
2BdPi+gBoJBAWVhx+E05D8w1qN6Ud0cCzHsL0bFd3ejLbHSgw0Lgtz4rYdOJ9DkW
5sOvByejUPKJXHt1Ohgek/A+AUeQZM+cPncnZymQ8XyEQ/nu8Dvf5tSUlyUkEwDV
omtKjpZlhfabFAPithapFCNlwPxqkC4AWDSBmI7siJjBb8WD+2Ztk4M2dXk4BcOj
ZiFportodEPv21ogdIEV+JTrHn5KZi9X1ygZz7p70/1YmBOc/kt8tvYcRJuiQSmu
SP8T84cIVGoGSdjxX/TfQIvykphtDAGPumWp2ZFyBWBy2mEwYZoSO5+sK3hsq8L5
nmoB3VDiIGeX4UYWcB1GFxz3ZvhAIC2XssfI8zq4nj2pwA/MAfovQvHqEEQp5L/Q
cvcbms2pRV7ulwWZofkSwEf84A70/dmJB0qpAluXbDSkGRIwIkVs0+fkQoElV0XH
BLQeiOrhkPDX1PTDbaSpe05lX+JdHHJX5y0vaVixMBo2tryE6wZ+/8xXhFQbNAbd
lOWAxJ7i3+NeSHVISlVjyIrmPTObRQ5QbKxUjpmQ+BScemkhOKf6tU/URaoy8IoW
gdEGO27tZ4nAYPYhEwHS8hkXRmr0tli4JcofnGEPPDr+0zbQj4bva6lYAm9NK6bd
Vey4I2XfvzoJOWasXr6S
=zoWB
-----END PGP SIGNATURE-----

--XeHo0rFSNt4mQX/E--
