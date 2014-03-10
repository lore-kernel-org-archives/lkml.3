Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaCJLQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:16:06 -0400
Received: from ring0.de ([5.45.105.125]:36981 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbaCJLQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:16:04 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Mon, 10 Mar 2014 12:15:56 +0100
From: Sebastian Reichel <sre@debian.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Marek Belisko <marek@goldelico.com>, Jonathan Cameron <jic23@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv2 0/9] Convert twl4030-madc to IIO API and add DT support
Message-ID: <20140310111556.GA14667@earth.universe>
References: <1393702365-26429-1-git-send-email-sre@debian.org>
 <1393970751-18157-1-git-send-email-sre@debian.org>
 <20140310104356.GL14976@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20140310104356.GL14976@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 10:43:56AM +0000, Lee Jones wrote:
> > TODO:
> >  * Wait for feedback from DT binding maintainers
> >  * Wait for feedback from Marek Belisko, who is testing the
> >    changes with twl4030-madc-battery driver on GTA04
>=20
> This patch-set has stalled.

Right. I waited a few days for more feedback.

> Can you send a fresh patch-set (not linked to the old ones, as the
> thread is getting very complicated again) complete with all the Acks
> you have received?

Sure. I will send it later.

-- Sebastian

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTHZ7sAAoJENju1/PIO/qarngP+QFMKaDGSsi2vFIFZ49/BFLk
VE9GXXGXgOot81lPqa2wJ97AmOgf5c4QWYGLsM0U+mufoWPGW3vZVKJm7HqNL18s
jUKy4tY6C5upZWnanrB25InTS59emNF+8ggWtS6fgyf4Mea4CyOj4k4wvJeLSJFk
n0thpL6PZMBn0bU3HNEVfLp7QHfA4lHQfl3Oh4W/L23UrH6Mlk2EaPBnaLVqCMOf
QbaIxwQYeTWBItEhxPfA5YNcCRhWDr7QlxMcQ35CLuwVXxYX6cgATq5YBEs30u3O
ZEhwo3MmVdHfv1XCrPsKfqO3bmnTJb7ouRuV9F4MzgeiCwF41cHzmxSTTyQGMMTR
kNzkVX00yIo+Gy5RLhvxV7KZ7PUIVRn128pkM969IeDO+4SMLJvmkcWKaU/MQSyG
ZiEdLUny9Do7EkYqXRQEzxgREloHR/RGu23WTtUR8xfcnQtzKBnexrlehCnK25Ls
rE4D/iuc6KDOtl0mNV7xHPIEqY3Pw6LF1Kouf7YaKamPgYsRXge/WU7i+8HJmsHZ
17BxNp0NXESlXc7hIZAyoLg01GaoHZmJQFii2ft3RCu47joNOUp7Hh6tAxCNdM+S
lr0sf8duIdGxkOuL2gE+sogvvsUNoduAF3WRERW4h1/YPHG5t8e3Kz5Ve5QVMWWc
snl1faS5QCb9Xf9MCApK
=BX1t
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
