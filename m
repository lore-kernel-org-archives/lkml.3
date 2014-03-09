Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaCITIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 15:08:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59585 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaCITI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 15:08:29 -0400
Date: Sun, 9 Mar 2014 19:08:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140309190807.GZ28112@sirena.org.uk>
References: <20140309114134.502cdcae7e6a97db684d6b15@kernel.org>
 <CAOesGMhUVEEa6KLs2ZORxJunxitVdOQ5-wbs3KtEWBq+77t5JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ddN45lq1N3it+fOY"
Content-Disposition: inline
In-Reply-To: <CAOesGMhUVEEa6KLs2ZORxJunxitVdOQ5-wbs3KtEWBq+77t5JA@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the arm-soc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ddN45lq1N3it+fOY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 09, 2014 at 10:08:58AM -0700, Olof Johansson wrote:
> On Sun, Mar 9, 2014 at 4:41 AM, Mark Brown <broonie@kernel.org> wrote:

> > ERROR: Input tree has errors, aborting (use -f to force output)
> > make[2]: *** [arch/arm/boot/dts/socfpga_arria5_socdk.dtb] Error 2

> Known issue, I unmerged the offending branch but didn't push out the
> backed out for-next branch last night (I was unaware that you were
> doing linux-next now, and sfr doesn't do them until Sunday night our
> time, so I didn't think it was urgent).

No worries, I wouldn't have done it on a Sunday either but this time
round I've got Stephen's scripts so I've been pipe cleaning those so
hopefully everything will actually run properly on Monday.

--ddN45lq1N3it+fOY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHLwUAAoJELSic+t+oim9H9AP/2TGw3M0IdazbHj3RqPQ7opo
pi9q8xIt3f2FvatOLEYrfCzmQLzR+r7aY1ASByrTTrabwGHk8CQADYHRJe4+Tg11
VRTHfnN6RC1kyBJuyduys2Dcw740/sBfzhJUKU3AwP3+4Jyw836vi/AyU11YL8nS
irhy9+4pjs3bXi5lXZkA6OSXQ7q1DqyOV9S95kjZRL69rbyFjvoPQ0N+9OtM6cv7
Vm8RZIU6plM+hpoWZnVoxpQtOj8hykaOQ/r64RbnZ/cl6fPMbnM8/vg2I8Y0phhq
cRNUOdzL0CVB8301M6swbfe03HCwUcUvCvf/1ZsL4xJTfIBLAFXzP4HZKpImw7XH
pxTxig68ab6apDYCt7FmFcxw6B3yAOtU3YdUnFRFk/IeuH/kd6b9QeYzZ6OEoJQA
18lWxnKDDEkLpsd3zuOXaG4uRLJgSoWQB8c4nMx2O3SxVT28rXuQaqkS5aooiE3W
MkOiCKL2M3NUmHNhxSMqYJ5cxo41/6lcZfrhM7YVMJO/ZKO2B/duKqwIDokkHhg6
W143uXJABcRkvHWaYr89IHzV3QI4l7iK4+ViV2/HN+wTDW1v4IJsWzBWf48CiOqO
VcE6GevBftcfXzUaNLWYvACf3rZ9yplMr+nkylp3cooaQ0WLmIzjv1ngxkqkZP8W
3sPK1vz9c9xFM0gK9t68
=JypB
-----END PGP SIGNATURE-----

--ddN45lq1N3it+fOY--
