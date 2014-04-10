Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbaDJWLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:11:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48137 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaDJWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:11:03 -0400
Date: Thu, 10 Apr 2014 23:10:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140410221047.GE6518@sirena.org.uk>
References: <1397160240-2833-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U1t7w//IUm8YcF8e"
Content-Disposition: inline
In-Reply-To: <1397160240-2833-1-git-send-email-tim.kryger@linaro.org>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: bcm590xx: Set n_voltages for linear reg
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U1t7w//IUm8YcF8e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 01:04:00PM -0700, Tim Kryger wrote:
> Fix the macro used to define linear range regulators to include the
> number of voltages.

Applied, thanks.

--U1t7w//IUm8YcF8e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRxbkAAoJELSic+t+oim9sT0QAIDogSLYC57QKaFe8iExu/zO
qpSAw+wuzPtD12EYOTZzbpGN+/sOX/nPmKRB505pnObxYi7YkHpDVifX0gB9X8yz
KvNQjWtw07dS1odxD5bTNGA6RZZiGK6jl/fV7OqhoBuwQ4K3yW9bqOzg1r6a2Fon
WRFupu0MwL+683fSWKrL9EczjWjA8GE2NHc/FLpYYtQF9mkAO6K7l9PVBkd7kDDy
5WWD/juiLBOmKOMXa34FBqSdOF1vHTdrwJqujL5DZoYJw3VI+7+ChGoZzrmZMH+p
vDtJiNU+otIO1yAO0I/TLoqp8LBLhqB89IBvNYl36oG1J03CLH32bGCxs/Cwfu0l
nkWA1v2M/h4YOhG7atyE3x6r1xKZJfZps9mDje/20wJ60Q3Ypb6a2LmS49LtQMYE
071zB08LQKga9x3aZMzt1Vhp/AkoLd4ubML9EXn1BLg/bEGyGanBcfOkWUkUMgJ2
rr2UtmagVWGIe/3hTGd4gjemM0YLfpsKDP6SqHXD0/H5K/lgNCD6xAhK9+ICKzxk
u1hiGdkvBteYGg+9IU+yKjilIzS9J6k9r86PADHEzWXVjnLbj4HpM5tk+84n6vtL
Qc89oVwT9U/PNopDva0B/0eSNjgCgYJ5ZnxAFfnKZqs9aiga4urA7tdjlC3KIHbR
kb3pYiSOkvv8+hU2Yh08
=FF0h
-----END PGP SIGNATURE-----

--U1t7w//IUm8YcF8e--
