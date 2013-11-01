Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3KAJPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:15:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3KAJPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:15:54 -0400
Date: Fri, 1 Nov 2013 20:15:40 +1100
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: check for devicetree early.
Message-ID: <20131101201540.3686ca90@notabene.brown>
In-Reply-To: <20131101064240.GN2493@sirena.org.uk>
References: <20131101134833.7070a5c5@notabene.brown>
	<20131101064240.GN2493@sirena.org.uk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8LORB7Fz3OkwSvLtFty8Pco"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8LORB7Fz3OkwSvLtFty8Pco
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Oct 2013 23:42:40 -0700 Mark Brown <broonie@kernel.org> wrote:

> On Fri, Nov 01, 2013 at 01:48:33PM +1100, NeilBrown wrote:
>=20
> > The behaviour of regulator core with respect to device-tree and
> > CONFIG_REGULATOR_DUMMY is inconsistent.
>=20
> Wei Ni reported this issue and is working on a patch which I'm expecting
> to do this as part of device tree initialisation rather than by faffing
> around with initcall ordering; this will be simpler and more robust
> since there won't be any possibility of races being introduced.

OK, thanks.  Sounds like a better approach.

NeilBrown

--Sig_/8LORB7Fz3OkwSvLtFty8Pco
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnNxPDnsnt1WYoG5AQJ6Hw/+K0Mhr2+GJ/h6GlWBLdzww7/wzplfID7U
I8WbGkbq4dS5cvzRQJB+hoVCgJ3r71/Jao3kl0PZmqwi949K3U37Za1n3c7j9fZT
wOvwy1qlQoQNVFAUP6+3sJTJVQ3tW6Idh7xMcVB2PGnRLydF2X/byBAJzG7v4OFs
U6OW78fjDq7qLvaW8mEevTIzmojGi3NR/qA7YYa5j+AouoqZDZvmBrkdo4hP2+F5
2/OByWhK91dMzfhDHPG92dfvefUMm+rCxWOA3faQEOqb/Yr1t4bc4ZVJzpcoLqPr
EN72/seUMvFXo16p2iNii6FoDQBaCIQHbdumFMJuGp5tFHxoRfiWFNy0Gw5raFQX
Lu6a5TCR4bQftJ+pCe+YQ9bh7ddDmrE0pB95M9bD6G1ypJtuvsD3WwDE5NHHkFj+
lfFzJvFPrkHrECtYLaXWpJwmNc0H+GkSH3UgMYSAGNv/jRUCLT8+1DfziO3iytgO
p4r30ny0dhtFGPy90/2h+VXQAaKp0X6uqC5vbsi6ihE7P89JXKBCd3KR4hesKQJy
xY4Oz0qOEvqPYeGW64ssu0u7WFYL6SAC/RjTrF3BN63TdjJ8oRNaK8umQ9Fu/TV7
AgBJHJM/VLx6z+p+7NbUDVuEPFQIirh7DnoXiYQF0+8Qlp6dlw1d08Bu7iq4oMd5
1SN5/Hgtd30=
=IBZw
-----END PGP SIGNATURE-----

--Sig_/8LORB7Fz3OkwSvLtFty8Pco--
