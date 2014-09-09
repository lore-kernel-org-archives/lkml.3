Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaIILWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:22:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58779 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaIILWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:22:50 -0400
Date: Tue, 9 Sep 2014 12:22:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guodong Xu <guodong.xu@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Message-ID: <20140909112221.GP2601@sirena.org.uk>
References: <1410260825-21667-1-git-send-email-guodong.xu@linaro.org>
 <CAFRkauBhzHot9=z-Jv-rvdLaSWSfyYSULMKqcVX+tiHcXrxt_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LfQcPIWFRhGivmDw"
Content-Disposition: inline
In-Reply-To: <CAFRkauBhzHot9=z-Jv-rvdLaSWSfyYSULMKqcVX+tiHcXrxt_g@mail.gmail.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.152.174.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: mc13xxx: add missing of_node_get()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LfQcPIWFRhGivmDw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 09, 2014 at 07:11:46PM +0800, Axel Lin wrote:
> 2014-09-09 19:07 GMT+08:00 Guodong Xu <guodong.xu@linaro.org>:
> > mc13xxx_parse_regulators_dt() goes through dt tree to search for regulator
> > sub-nodes. For each matched node, later on it will be used and registered
> > into a regulator_dev.
> >
> > of_node_get() should be called to increase its refcount.

> I think it's done by regulator core:

> commit 63c7c9e16c8e92cc069854f2babdf82d2d38e4c7
> regulator: core: Get and put regulator of_node

Yes, that's the idea anyway.  It's possible this is buggy though.

--LfQcPIWFRhGivmDw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDuLoAAoJECTWi3JdVIfQmYgH/00dYGF31lb02ivfhf8v/kUQ
MPwoWmTa82mZRE5tWWGNkWGrJ2tnzM6oE8p/qsrypYSPXm5ltGh04W1KOMt1w1B2
EGmU5BqGgpsaCjjhntHWNR42qGYxcSyz6B5/JoiHhdnWwSD71uSY1Et3Lu7uTJaR
KOpS0hcx30Dpx1wsu+nu1NbuL8KPlJBYa3oHF3TXm0eG/3a7Qo/v5Ov1Q82s+zc5
HUFV6cb6utFxZOeFg3lO2Dosm9oz0iCQckxSJFdoq/3Tbbh0xfXSRtnNbsjvbm7b
d5xeoEAcOf+CPHcfThJIwvhoQZZKhU6inS8tPIBxtZm8+ZjpJv+tXXzNlgME+lY=
=4Sp7
-----END PGP SIGNATURE-----

--LfQcPIWFRhGivmDw--
