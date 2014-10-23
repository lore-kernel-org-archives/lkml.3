Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaJWSy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:54:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35995 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbaJWSyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:54:54 -0400
Date: Thu, 23 Oct 2014 13:52:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/12] rtc: omap: add support for pmic_power_en
Message-ID: <20141023185259.GC21407@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-10-git-send-email-johan@kernel.org>
 <20141010180721.GV31348@saruman>
 <20141022101849.GL2113@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20141022101849.GL2113@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 12:18:49PM +0200, Johan Hovold wrote:
> On Fri, Oct 10, 2014 at 01:07:27PM -0500, Felipe Balbi wrote:
> > On Thu, Oct 09, 2014 at 09:06:31PM +0200, Johan Hovold wrote:
>=20
> > > -	/* clear pending irqs, and set 1/second periodic,
> > > -	 * which we'll use instead of update irqs
> > > +	/*
> > > +	 * disable interrupts
> > > +	 *
> > > +	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is u=
sed
> > >  	 */
> > > -	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> > > +	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
> >=20
> > bug fix, should be part of a separate patch and Cc stable :-)
>=20
> I made this a separate fix in v2 but did not mark it for stable for now
> as no one has been bitten by it (ALARM2 is never enabled by the current
> driver).

makes sense.

--=20
balbi

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSU6LAAoJEIaOsuA1yqREtpAP/j/xB9gFQARrP4hfUnH7sLpP
2WOskkQGha2teOgy9hHfesPN32zcY93Mj9h9WoczBDNxTCSaDEEeF7jBJ1lQ0i1k
TvN0O/y43oyrau/U1bJ1dTAxmYtWqLSVwT8yLfDNYOhb9JRnKRJcvB8FmwZUkJuY
XND22kKniaxjlB1AIW8PYmNrhG0H40KKc4yc1y7U1GzctLcM4OhGxK5MWTAS6dNx
e/scHqsxMzwPdvbmmQkvi5gDRfqJdJe0cdnCZkVisv7KaEbDWQ5GsagOofggZY7P
wb3dnG/eJIP6YzAz+80JI7GeXHAfImCeRaZD8tWn5ADErOCWtBIlwnnDQzz3+iZp
DkHwTfsCXRsM9WM+RdI02Cn/rPQ7Ky2JwqXmqGHd8GyNysIgWWD1HEBO/OxvIwgS
Gn7rS8VSvzT+osUg2SMAPFgTfHTTNLhfJsnl5rmshazZM+/7PjWeL41iFUuAH2Su
MJNxP+NIJ47MAUAgAK7Y8IBOFKy/aNVTQJqPayQt/0ofkW89q1WrvLu8bHouDCC4
aD1DUObucSVpJLYOS/08CNF+RxoJDQVy5ieXTWOCTdJnrOjSs8cjopTN9h/e11mz
QfYEVtAP9Egi66qAjeULTj9RAHq0fk5aJEckx7MGIL7y4EdU61YWV6LJzxmSmegg
AzoaRtN+kBCoI+Xk3UkE
=HboH
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
