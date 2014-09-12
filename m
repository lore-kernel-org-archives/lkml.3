Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaIMPkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:40:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39101 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaIMPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:39:27 -0400
Date: Fri, 12 Sep 2014 14:57:38 +0100
From: Mark Brown <broonie@kernel.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-driver@qlogic.com'" <linux-driver@qlogic.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>
Message-ID: <20140912135738.GX7960@sirena.org.uk>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca23f2aBZR6YDKM9"
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103CDBFBFB01A@CNBJMBX05.corpusers.net>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap:change struct regmap's internal locks as union
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ca23f2aBZR6YDKM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 04:19:49PM +0800, Wang, Yalin wrote:
> this patch change struct regmap->mutex and struct regmap->spinlock
> as an union, because these 2 members are only used one of them,
> we change it to shrink the struct size.

Applied, thanks.

--Ca23f2aBZR6YDKM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEvvRAAoJECTWi3JdVIfQIBoH/RgND4g/oRll+35TNJ7SrHvS
4AAA17am9RLZISkGF2+EHb2CGGWW2h6ZpPV8UpFlW09N5tmh/gT80qpMqpFixF3T
d7bq6F/reMP41eyKIEDarfKJR7fRvYc9adTA1okPicJQ0ddBm2lFrvkjVOaNH2AX
/Qw9Gib0aOs5OEvDia32W575I3KtLKEpUDqHimpmvpgqpNXcrbL4ySSBxme5It6b
KBYCN1fF8UGJWFZRb5hDFHv0RJ/JoHbXOmHDfsp3Z1IrHRPDlOU0v5CnOvvfFG4t
S+wqgZ4ul+WZstUbodTAgSZjD5pgo3Xq9eJaZtI0oVh+F1PSq3t5js0rsPpdgr8=
=zdIP
-----END PGP SIGNATURE-----

--Ca23f2aBZR6YDKM9--
