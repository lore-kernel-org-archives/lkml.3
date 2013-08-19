Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3HSMLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:11:30 -0400
Received: from sauhun.de ([89.238.76.85]:36183 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3HSML3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:11:29 -0400
Date: Mon, 19 Aug 2013 14:11:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: balbi@ti.com, Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130819121123.GA4540@katana>
References: <51E50217.1000507@yahoo.es>
 <20130716090300.GG8880@arwen.pp.htv.fi>
 <51E5137B.7000302@yahoo.es>
 <20130716094212.GL8880@arwen.pp.htv.fi>
 <51E527F7.4080007@ti.com>
 <20130716112746.GN8880@arwen.pp.htv.fi>
 <51E537A4.40300@ti.com>
 <20130716130058.GD15036@arwen.pp.htv.fi>
 <51E57211.2040001@yahoo.es>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <51E57211.2040001@yahoo.es>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

> > Which means your original patch starts to make a lot more sense. I
> > wonder is this is really what we should be doing though - breaking out
> > of the loop, I mean.

Yup, that is fine. I applied the old patch with Acks from Hein and
Felipe to -next. Thanks!

> It looks like TI's i2c-davinci will have the same problem as i2c-omap,
> and will need the same change.

Somebody up for this?


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEgtrAAoJEBQN5MwUoCm2ttcP/0+JcvKzt55RYxT/w4U3NKq5
IiJ+pQjIKyf//T1FQO2dAdiSq4Z2hXU0Z7+7ZNFkTHLhkXOvSoSDZnRBn3fNJKq3
Z5UfyOu5kIz+DbtoK1X3hXeGGlVoasEihw8Ptq0V3xZu6TpRf779JOlPNDBAZswY
Lg1R3KB/BU4vJ1Gi4w3LYSu0RaFCC4CHwhKT/+ZdSTUuIyWP4tZy8peDH09XWYRi
ZCKo0AdlasaPfRayOWZvcHDr+wdTChIdY+UyMPYgYtqTqTjDCCddgDK+yWPH8Lwi
OiVXxneAFnKRjpGCOsWIu7LSMlcRAkb2uk5BRV07VJxFSkm10fMy/WiGq2wubiqu
B620bTOWRVCjFYMoOvKR2rcGFh9umV42MLqbhBdZVSms2cG6+fkWD8g/LmUMCVc3
kOJkuLiop8k1142vjcMWEqVbhN7SoshP9nYGvRf3MLT/ctM00lRSjeg+kP63F65v
03X0PBF0+pEeXuc07hi5BylUtBE+MpBtMtC5fXnj41KhlzSE0ZBqRk+1EjEzC9uy
VBqK8cOSfoExTSPRp3Xu5C22FmTJwDq2EJEHxAJ3s3GGBIi5c/pYdBW8xbXSOJSG
28uSDL2sFMs99qrCEJQycCJ1p10OQ9RXfXP1KpJXDLszpS7Fesps4gExlo/kpRMs
ssP6gFzfWtigXYEoe0LR
=PZST
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
