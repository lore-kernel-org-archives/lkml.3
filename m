Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbbARLHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:07:12 -0500
Received: from sauhun.de ([89.238.76.85]:53866 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbbARLHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:07:09 -0500
Date: Sun, 18 Jan 2015 12:06:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Arend van Spriel <arend@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150118110658.GA1113@katana>
References: <rjui@broadcom.com>
 <1421451737-7107-1-git-send-email-rjui@broadcom.com>
 <1421451737-7107-3-git-send-email-rjui@broadcom.com>
 <54BB795C.6040402@broadcom.com>
 <20150118094741.GE22880@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20150118094741.GE22880@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2015 at 10:47:41AM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello,
>=20
> On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
> > On 01/17/15 00:42, Ray Jui wrote:
> >=20
> > [...]
> >=20
> > >+/*
> > >+ * Can be expanded in the future if more interrupt status bits are ut=
ilized
> > >+ */
> > >+#define ISR_MASK (1<<  IS_M_START_BUSY_SHIFT)
> > >+
> > >+static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
> > >+{
> > >+	struct bcm_iproc_i2c_dev *iproc_i2c =3D data;
> > >+	u32 status =3D readl(iproc_i2c->base + IS_OFFSET);
> > >+
> > >+	status&=3D ISR_MASK;
> > >+
> > >+	if (!status)
> > >+		return IRQ_NONE;
> > >+
> > >+	writel(status, iproc_i2c->base + IS_OFFSET);
> > >+	complete_all(&iproc_i2c->done);
> >=20
> > Looking over this code it seems to me there is always a single
> > process waiting for iproc_i2c->done to complete. So using complete()
> > here would suffice.
> Yeah, there is always only a single thread waiting. That means both
> complete and complete_all are suitable. AFAIK there is no reason to pick
> one over the other in this case.

Clarity?


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUu5PSAAoJEBQN5MwUoCm2SkoP/3BN2XB1RMlEMPr7wJR9+H6a
IWeWsj0GdxF0dJpThrxF40KNgmxWyJojprDTO3scKI/Gl8uMvTkWedsrnrAkwHSC
mRJAWFUucxVv1WLm9yuK0azceXeg1Fft3ovhTsgEKIapaVW/NIex4JvQUj6Gpm1l
oK5SS1ZarMxE+8pGT4fOwmYoqJUyAWVkAe6ajD2vYOoS4kRZpzSPN47Ty6WcKlU2
nhyQjEAgCtP6bp4hN3jzuHfVe6jpxjpmmgrVYDxqaC0ZH2SnIpekKxqsjk7fX3TH
gcuiwwG7ckhfy2vMLim9F9YBD4wQLe/hjFhGaH0aTLbrKMsQol/xw0CnEW3/FZDf
i0sD9Ho5hRjxUV9nSFQxBQKRPGrStRbM6gnFQDCgdwA5BLmZDpYjsdIYNKn8fCkh
/xV9vDRCciP6UcHVimlhV1xLWcr4QU+wTK9/Sev242B/2Zd+v28GpaMyz5aMDpca
3dpm7Lu37QgmgDkPqdp+Df1vT7+tdBZYfho08qvvZPWIjIOGeZ1PfClcTSxqGcPn
0muvuyZLIt+dr/HjuDk7WFewjstjStQFAeHuACHrzOxLt21baE+HWmKDTxbFOy6o
B8ZlSVWZqB00YCDTQnUcPlFFtL65DebEry5sO8qsxdN+vRC8fMPYANpByZOkDSaI
XzSHnUaN46/H1sSivKYx
=Kwf3
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
