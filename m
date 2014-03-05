Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaCEE3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:29:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55967 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbaCEE3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:29:13 -0500
Date: Wed, 5 Mar 2014 12:28:07 +0800
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20140305042807.GF13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-7-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1YtYzP3stTOlsn9I"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-7-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 06/11] ARM: s3c64xx: pm: Add pwr_stat bit for domain G
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1YtYzP3stTOlsn9I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 05:02:11PM +0100, Tomasz Figa wrote:
> There is a status bit for domain G present in BLK_PWR_STAT register, but
> it is currently not specified in the driver.
>=20
> This patch adds the status bit of domain G to structure describing it.

Reviwed-by: Mark Brown <broonie@linaro.org>

--1YtYzP3stTOlsn9I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqfUAAoJELSic+t+oim9ehkP+gOXyGk78hMlouZoxks7zLAh
j4kVUoDMQyFVMVi7S2v+e009JW8sdvZeA932CcTsRYpYsoxXtBk5NVHOVdRoRFeq
GTDhySPzmzw6zDgOpkHhMbuQid2Mq8opymPKpVVUH7MTDI718CAuOKAHIcBIeFMa
19W/gXIAbxGL18VLGBMHBrvrKJ+YoEaXm7PT9CO7UuPcCBomeUER8OodmoiITQfU
1CZQ+Q/Lz1Pp5mHhiEHkBtqCqijIO0sE+X8lfmFlcw15lVx5Czokqx0ZWJzFYA0S
kU5yd6pXTFr9lO1Y11hMB1NpyqR78KAQKUYUTb9B6mNVFYzu6Bam4jADMX6RE+e+
3Y4JqFW/kWKv2v0qLNynKKDhadonY9M2IiNo/2erlmqNFNHX49Qn5G+v6ql7FFVN
zV1MmJH+rf+zcZ9gDPiTT9kFEqa96dwpjsn/yai0p+CGzFK4cod6/c0d+fa8SCO1
b9dKADY7BMpa30rX/d6J4hjEbOzaKKL01SrApZdfGLDs0KlnlHSA3HNtZ6fLQghZ
kKQ362mGOi0MKyq9rjw/PNNUFfTe6LBWO5FnrA7oSENNBuHusx3eXyKqsvQMsDlz
O4KmjjvyTOMNkdVQyP8fMhUvV7bCKFvUM0EwT3Bd4oQqMIPjzcCbc3Yx+4OFrgts
M8NN0AS5/SNlNwXkLr5i
=KB3w
-----END PGP SIGNATURE-----

--1YtYzP3stTOlsn9I--
