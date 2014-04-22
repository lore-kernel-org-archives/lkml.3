Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDVTI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:08:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41673 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDVTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:08:26 -0400
Date: Tue, 22 Apr 2014 20:07:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, olof@lixom.net,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140422190754.GF12304@sirena.org.uk>
References: <1398180298-2018-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T0Q6x799hJWgQ1sc"
Content-Disposition: inline
In-Reply-To: <1398180298-2018-4-git-send-email-dianders@chromium.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND PATCH v3 3/5] mfd: tps65090: Stop caching most registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T0Q6x799hJWgQ1sc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 08:24:56AM -0700, Doug Anderson wrote:
> Nearly all of the registers in tps65090 combine control bits and
> status bits.  Turn off caching of all registers except the select few
> that can be cached.

Lee, I don't mind if I apply this and send a pull request to you or I
pull a tag from you with this in - what's easiest for you?

--T0Q6x799hJWgQ1sc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVr4HAAoJELSic+t+oim9+L0P/35kYdCKp0hqz29+ZVBX4P8C
o4SjA8cysa1vg/X2d9O9LU2FNJAoA298WgQh/rsPTDNqyu7sInFiFqsbcOTBwMTu
Rm4dgKhPjjSy2kphCr1E/2IpHTAVdB7pmcySwZhfxI/v4SSgabrRqua1UmDL/sXA
Xb1uvd2l8IpBF1PpVrYrflcPsz1En3ygoE0zQfx8EuiiYQwvfnOt94VdvG1dhD11
VjDOg/UrXVVyf+ndVfwiOxKKuBLA5KCf8Av/6DOGer+6XXveidz1VvjdIjHYczZj
ckSI8wWfB480OdPkLnqMVlFWo+t0yilGfohj8fL3IMmVIagReBc8Pu+XStlpsBwb
7+mJy896WLiluGLpVdb0lNUr2PYwdwGYeKP5fx/yz97HCRnuP0qnl6NWhUcUaJzj
ZyUb+Dfgz9eq2/rdNWX9qguRPgUXh+7dM/Haxs+3z7v0f+nW7pzuCsqNOygR/0WD
fbuMgVT1UM/xRBC0zZUY8JgcMF2cmz7vHBdIcOlNJe/aw7rLNhKRDrMQJsY5I1V9
Ag/k+lEpYIBlBGBeGv/K5IQsq35jxQZiCaab9y57OPFYQuPPoNSNPNfXo2pjkAsO
lLQPU6SJAnNhsI/jkte9BFGc6zFqXuY4Tgu0fyxLCJ/5jMIs0mRzy8feHKJcTJJS
RC9wD2+NXrFl33ldKDF6
=UoWO
-----END PGP SIGNATURE-----

--T0Q6x799hJWgQ1sc--
