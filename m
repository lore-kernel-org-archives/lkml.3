Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaCJJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:23:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48511 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaCJJXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:23:18 -0400
Date: Mon, 10 Mar 2014 09:23:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310092311.GF28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB8SBNQBCzhQE3ms"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] regulator: max1586: Remove regulator_dev pointer
 from state container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB8SBNQBCzhQE3ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:44AM +0100, Krzysztof Kozlowski wrote:
> Don't store pointer to regulator_dev returned by
> devm_regulator_register() in state container. It isn't used anywhere
> outside of max1586_pmic_probe() function.

Applied, thanks.

--TB8SBNQBCzhQE3ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYR8AAoJELSic+t+oim9swgP/1EAkNDEzx2imkObNlEUYMsc
6UcX1jkBibjsr2t2+zWkx1tUhbyt5GACob0tvB1RYZTnVJyVR9oUgACgIcN/VMcM
Fu4IM+DBJ1231q4YiB/Cm0e89/2O237zJQhYOvM/4NSVSDSLMyldd683HHVc3goW
dRneY2wyHRsYF0Mm1aGYXnjT4YEfnjiD//P+phpeyh11PhWePvu1gX0PzzTh7bSO
Gg84kkMBD769jSebskoid2u9OiPyFAkKtGexOLscOYORBQo9arZl4g2KaQ8gGzYF
5FJwuqRTJ9s+YfZD2EWOefy6FIP22DeUZpyivhRe9y0zHa1R5uvLtccGuVrMfSpu
r6gSiVee+/yZj7yo3f+VGyiQsBK59dmaD45nyoN+jCaRmaQz+NHa3+JYfNuDD+s5
WmUpa9RdIU8bhgQcjSVyQqiF78eutnR2Xks5fdwb/yCw9N+JCrGpzCg22uNJNYJS
vPEIhTrt6AyOJnj+CfR6PuJw4rRxOfsNLozI7yLZ0WCzLdu9Pp2WNph3omM1m9u3
RERSSE027GLfTPXXCjuFozb+gTdb0CHrxKqhAFaXO2ECP+TdRw/9G4lIVmOSSHwy
IghZJ0FAlzyXakOyiEaJsVp7tXdz6FqgbDVQRipvUmuKMnZbTSlPqCgztE+dbEU6
EZSnuKtUkjC3SPWldN/h
=A7eV
-----END PGP SIGNATURE-----

--TB8SBNQBCzhQE3ms--
