Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaETV5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:57:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:40210 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaETV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:57:32 -0400
Date: Tue, 20 May 2014 17:57:26 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
Message-ID: <20140520215726.GU32082@beef>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
 <20140520161131.GB32025@lee--X1>
 <20140520190055.GQ12304@sirena.org.uk>
 <20140520202923.GT32082@beef>
 <20140520214439.GS12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <20140520214439.GS12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 10:44:39PM +0100, Mark Brown wrote:
> On Tue, May 20, 2014 at 04:29:23PM -0400, Matt Porter wrote:
>=20
> > Just resent the v2 series.
>=20
> I looked at that but it seems I already acked the regulator part of the
> series and nothing else looked immediately relevant?

The series has cross dependencies (shared header include) and thus needs
to have both the mfd and regulator portions merged together. You had
mentioned in the v1 version that you'd like to take it through the
regulator tree and so Lee's comments earlier were with regard to you
taking the mfd portions.

-Matt

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTe8/GAAoJEOfTILNwq7R4Y+gP/iSar8tfntM3jQEcDadottmq
k1/+QtHNKFPYvwUw2RM2NFE4VulRh1Pv1Qh6uNTeFgXN2514G+CxMKWY8RUoZ2LJ
9ZG1PInq+Xf82uiScy79ytb4jcuaPTIam6RUcMY/9n9mOnbfA01apKWfZT9IzEnl
4xzzjtJRxxAv840mvTyaPd4LcEpLtTsQBqU2YMDyQXgJCFl+AmjuxDfCvJVoxDIb
XQa+IzJhQ5aijLX2xaf7L602TnjizxazDNBh8CA/yY+V/8QfC6T82IF/VBGTsYam
EpUL8LYVVdT6qL0C5FY2naxm1YqxlbZccRtlnKRtgEdvLLzxiOgNhFMGECdt36DB
StuMIVGAD5Y5DnUt8TD24QRg/5BSM5WZ3ZN2UCMNxLeXIeUPKA1tBy+Dtodbxox2
p3GpTnA8C4G6exKNdwx9AIDzfVaEcx+My+V+rJWF8dcgp0yHhHb1DpgZLMqgt5HR
OxrWlnBLhnDifU4vrcRZzX1lYVDGK7XaRpOQ2daaqVkvrDnI6FvCYxhokKLL9kU6
Ch9PqJ8YABkwosteQUHC6wIRL0MxpKdSlOZHHTz4LBxrWYgqEJIIqmFjJsxwZEbE
2R43REgdN/ISFziSMhVmKRWLrMzXh7RMFkZJ8fKCVDTf6hfAJavb8dwQ7McqJ7Ht
JpXOWf7rb+LLa6W/Qcqw
=7p7q
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
