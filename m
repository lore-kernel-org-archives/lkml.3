Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab3CZOEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:04:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55848 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933930Ab3CZOEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:04:43 -0400
Date: Tue, 26 Mar 2013 14:04:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: ab8500: Don't update is_enabled flag in
 error paths
Message-ID: <20130326140440.GV18316@opensource.wolfsonmicro.com>
References: <1364285594.27005.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ou5B7nmexOOGXbzo"
Content-Disposition: inline
In-Reply-To: <1364285594.27005.2.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ou5B7nmexOOGXbzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2013 at 04:13:14PM +0800, Axel Lin wrote:
> This avoid setting is_enabled flag to wrong status if enable/disable fails.

Applied, thanks.

--Ou5B7nmexOOGXbzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUarxAAoJELSic+t+oim9XQ0QAINDdMgUTpZUNlz5/A3rd4r6
E+6L8IwCYZBdRezooF4toDlVLbCCmqXxUfCl3VMRoiiyxKsduFGaH4h3rnrJR7aU
SXEz6iKJg1VoiOrpOQY8TsnA8kTYumn3AClADHRaWDd3mkveu6Vdwua1rplfjQu8
XZlqIUBeDWolYo230XUwIIIjirBbg1uhW6arqZwSnbvSyOcQBxJbNEpW/VgyYGM6
p81s9447KB3kl7fY1TfM4f092TeQr7F51bsS8qrTY9WFTxZz+ShWXRiXf5bW6FtN
tzMfwAzWGut3/hR3IOSbHltqBV0ctkzCiDvGzgxe3b4LS3h0SJQbGRNvOir10VlX
MsMvge9JSjxt1KomRYVt4QCpS6pV/r4zh61066SBK8LfII13jjubPiwySunAsyCD
8330toxNtmwTOzi8hmm38aJ2CJbto/0crB8JzuVoU9OmVuouq+lJTWgQvMFyUYPb
VaLdzOQd0DK/qEdxQ9rBUkQbuybX3d3FL5cGmQOyO5Hy0xPp/eRazyvJ6RKRReu3
eg0Qyg4ZV08SzTYSXoLWhgqjcDwJ1z1/giEqOIMKVD4bkechTFJH7BtME/5ytUzT
o9OQmOf7yKStH3Hqz0QXjUYkW/gLX20wDybZn1s902wZmqUB15nhvxmm2O3o3Mj6
NY+f/Q3OgcjAZFQWP2t5
=Gpqo
-----END PGP SIGNATURE-----

--Ou5B7nmexOOGXbzo--
