Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3GPLw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:52:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41765 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3GPLwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:52:09 -0400
Date: Tue, 16 Jul 2013 12:52:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130716115204.GK22506@sirena.org.uk>
References: <20130716131828.7c0b539f4ce5a515cc2553ef@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hl1kWnBARzJiTscN"
Content-Disposition: inline
In-Reply-To: <20130716131828.7c0b539f4ce5a515cc2553ef@canb.auug.org.au>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hl1kWnBARzJiTscN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 01:18:28PM +1000, Stephen Rothwell wrote:

> Caused by commit df7e4082f47d ("ASoC: tegra: Enable COMPILE_TEST
> builds").  If you are going to do that, please test via (at least) an
> x86_64 allmodconf build.  Including asm/mach-types.h is an architecture
> dependency.

I'm *very* surprised that the zero day tester didn't report this -
normally it's much faster at allmodconfigs than anything I have
available to me but it didn't report anything except the usual problem
with s390 not being converted over to genirq.

--hl1kWnBARzJiTscN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5TPhAAoJELSic+t+oim96DIP/1mRqk6koTsRlJ2DtK4M28R8
gwooPziD60qCnvklc48s3A6wvJMX+PW+b0b7I0VwfWHmTVpVCs1llYGYsI+kS8Om
s//Wkn0pH2iRrWA/fDtKD3MsAM+fSuk4e62to145nEsa6V+VTRRiWj62OVS2hCGU
/Nv5TeW+X4WJYxm5MjrbqIqkfTFW+xqCkSOpEv/BUQLgaTDBhG225Molu4QD2JOJ
xwSSIW7YZ5orRsgkevFLAkP/L++RFoDagEDGdOSihFTBfbZu24pBVMsYVEFLP0/Z
SIb2rSWxR6NJbUmjYvl6YopwsSzOjx0nWAGwkdnpHHoiKWC9DMelsSSU9ldoDzDD
sg2fkC8w708Ey0nLqunYPX/x12TJzkG4C6L2uA2uTAEFJf+uDVTWYgcNKTgPJpgo
Ce+QlOcYaEdkix5S6Ier8Fnj7TbDFLr+vV59FtBXMEODx7xPLCT3mkoYzEpvazeE
4NKTvAD0tM+cKdpFNE4HIQjM+zvx/ChUvNluVJmJhQcWs0TXeNr90cO+C3+fqbna
MoPjRKz6A5lKJtEQlsIbZqs0MZyHXqzf66DCC46o1g9U5sXg4Zpeh2mo/eTov++Z
aE/o1yxQsCf+X9MpbFdcfpa9CvilrDQMdTeHkLJ4gNPzZChlUouJb2/NNncW0xpe
qS9tr8DOeVbZD4xfR/YP
=vWHK
-----END PGP SIGNATURE-----

--hl1kWnBARzJiTscN--
