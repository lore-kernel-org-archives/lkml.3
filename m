Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaKJTEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:04:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57623 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaKJTEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:04:51 -0500
Date: Mon, 10 Nov 2014 19:03:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141110190332.GG3815@sirena.org.uk>
References: <cover.1415562021.git.moinejf@free.fr>
 <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zzcyysZ8YhDsnlP5"
Content-Disposition: inline
In-Reply-To: <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zzcyysZ8YhDsnlP5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 09, 2014 at 08:33:45PM +0100, Jean-Francois Moine wrote:
> From Russell King:
> of_node_put() modifies the struct device_node contents.  Therefore,
> of_node_put() definitely not treating the data pointed to as read-only,
> and therefore it is completely inappropriate for it to be marked "const".

Did Russell write this patch (in which case it's missing a signoff and
his e-mail address above) or are you trying to say "Russell King
said..."?

--zzcyysZ8YhDsnlP5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYQwDAAoJECTWi3JdVIfQG/cH/i1k6Zg0+Alez03elr0X9A5O
4Ce4AODbyTt0+wgPwAezQqDcZGtqoPRL0BIN/8ngiDPkhrAh43xueGDywmzt5c26
GfbxyH7ptbYvSEYWm9yXQvQ989MukJiZS5EN8CU9eRn2j9JfdCiEqK71RY6VKln5
AeRXFZfQ5jVPsV5sNUFDC6khAfzVao3cVkHugp236kjiyu+/V+rjp5r4brm+6GpH
KBhfe4hJPxNl1rn28z8ffyDLFIx5bC2F34R9jrnEKD3I74VXnnqy3B8AquLTsMEs
8c1rBim/BquDbM0TcZ9nR+7mmBkEAsHGUWXnSMI8n+UL095b6q/+wNcvvewRBOk=
=F4XH
-----END PGP SIGNATURE-----

--zzcyysZ8YhDsnlP5--
