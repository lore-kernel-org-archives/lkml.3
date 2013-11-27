Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3K0QHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:07:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57114 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3K0QHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:07:32 -0500
Date: Wed, 27 Nov 2013 16:07:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131127160707.GC14725@sirena.org.uk>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
 <20131127151639.GX14725@sirena.org.uk>
 <20131127152701.GQ3296@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpveMUvXs97SUkgl"
Content-Disposition: inline
In-Reply-To: <20131127152701.GQ3296@lee--X1>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpveMUvXs97SUkgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 03:27:01PM +0000, Lee Jones wrote:
> On Wed, 27 Nov 2013, Mark Brown wrote:

> > That seems excessive and it probably ought to go in as a bug fix
> > afterwards.  Given that it's just an addition of data to the table I'd
> > expect we could cope, we've routinely done that with similar updates in
> > the past without incident.

> Ah, is the depends patch in Mainline already? I assumed it was due to
> go in during the v3.14 merge window? If it's already in Mainline, then
> sure I don't mind if it goes in -fixes via ASoC, no problem.

No, it's for v3.14 - it just seemed like for the size/impact of the
change we should be able to handle the situation more smoothly.

--LpveMUvXs97SUkgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlhioAAoJELSic+t+oim9/wEQAJNLkZxAKP/j3gURcyYOVkvB
WEcyJe2a+18o1sp/JEBB1+vASNtMpXO6NQzQNYgNn/30J5rtFkzf0IspL5hiwic1
smeo9nuFMWlPebLKymRwTROYt/nHJz2NXh0E4hEHL/vK/X0KrKMPYcuBwcqYrJUd
+QrijHxxlZEalHU4wBYwDuNH8aIf3VQXwLjJDMzCudaF5sdEd3DUFvX5+IF6Kgtj
sX35MVukpOr29Y19QCxbxPC8Aj2k5cef3BM/ZKZ4x87cts0h5/ZlUNIvprrIQqGV
iIUtKb/QtOlpWwgy2xckkXzcHqFSgfJ5DzC/60hfxlcjtXQdgtSPEwQJMS/qcwtr
eftNHbdwDHD7e4qoogeHIsT73EsR57kx1xDLodwTlqXEfTfX8/tmG3S9n/Xxy33P
23K682WRaFi1PEUUwvar5+0JkV5gFpAA0fTRjl5tUy9XqOd+OHBiMF4es5+hj49S
6MRwgOhRiCBVh3jMhMNzNzClFxfI5jEaVLfdlKEvA0R2yL8rDuOx3hM9lNCeuGiL
+PhVrx/CYPGYuqh4nGxnOy/JBmfbopunWJiv7vG8KRr0ba9if4GO2GJE+nLh4b5O
K/pKRB7Ka0d+X0KQLhp5elMW04RFYb2Oo8fWOO9Agifo2OKsEw23LJMOcQvQKdEu
sSLMEtyuTJQsSk0ndIwQ
=2sq7
-----END PGP SIGNATURE-----

--LpveMUvXs97SUkgl--
