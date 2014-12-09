Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLIV2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:28:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53595 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaLIV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:28:51 -0500
Date: Tue, 9 Dec 2014 21:28:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <20141209212844.GM11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9+yvdhHLKXN64C4s"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: da9052-regulator fails to probe in linux-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9+yvdhHLKXN64C4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 06:41:09PM -0200, Fabio Estevam wrote:

> With kernel 3.18 it probes fine. Haven't bisected yet, but if anyone
> has any ideas, please let me know.

If it's regulator related my guess would be the stuff around
072e78b12bf5182a3e2 (regulator: of: Add regulator desc param to
of_get_regulator_init_data())

--9+yvdhHLKXN64C4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh2mLAAoJECTWi3JdVIfQl7sH/iBVVMtOnqrlTYoHCTUY72qt
vcRNOU2MgwxUQWM4l3rm63eTuW5jjklw141VJuZNyrYpE5z7RKHd7kuxEiW6jMux
qrlMJg7gK4rj6qkxQQcDNr4o51GbESlw7OPRvobgUum4IfvVNCeA7MTWvPVEHjKh
C0JhHj8s3DooAvwTWycVHGJfN3f3ya6a9OhgyEKnf0KCHbXOxq/4Dty189PXTVu5
KZ6AMNTt+NsxmyH644meV9Nxp3DgMzQd8pgLMFrrz6P8Inv/bXhpvSYmB1oWsk+7
OYBFTGvEQ29Gr347MyVdcJSS36X3QXceBIDh3oGuTvfXIMAQ9JE/lxY7KknDd1s=
=CVSh
-----END PGP SIGNATURE-----

--9+yvdhHLKXN64C4s--
