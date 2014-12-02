Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaLBOQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:16:08 -0500
Received: from sauhun.de ([89.238.76.85]:42217 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaLBOQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:16:05 -0500
Date: Tue, 2 Dec 2014 15:15:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Subject: Re: [PATCH 3/4] devicetree: bindings: Add defeature-repeated-start
 property for Cadence I2C
Message-ID: <20141202141548.GA5883@katana>
References: <1417514749-24319-1-git-send-email-harinik@xilinx.com>
 <1417514749-24319-4-git-send-email-harinik@xilinx.com>
 <20141202111907.GC23671@leverpostej>
 <CAFcVECLtPx6shBXJbg9Uf_8fnhkMoO1zpoxGcdda7PSA7z_2rA@mail.gmail.com>
 <20141202125203.GA4072@katana>
 <CAFcVECJwFoFd6GrmF282CG+fELnYb=FNCTDq=RYKky_dHha=Jg@mail.gmail.com>
 <20141202131611.GC4072@katana>
 <CAFcVECKMqACtumHZGHbToUUSjd_dWCcLbu=_ZjNnnGdAZQ_3fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <CAFcVECKMqACtumHZGHbToUUSjd_dWCcLbu=_ZjNnnGdAZQ_3fg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > What do you do when disable repeated start? Sending STOP and START? If
> > so, this is really something different than repeated start. By using
> > I2C_FUNC_I2C a user expects repeated start, so if the HW does not
> > support it, we should say so and don't try to emulate it with something
> > different.
>=20
> Yes, we send stop.

As said before, this is wrong. Another master could interfere between
the messages when using stop+start. This is no replacement for repeated
start.


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUfcmUAAoJEBQN5MwUoCm24eEP/2PWa38vuNrBPiCUbz9wxgOu
z/2F/nNcMkD/iPU27G7oS6ujtFC5ntgrixjo3xsuGO+NvlbqVtEBWeChoxr4dnBX
2PGTumCXpQFAjNW4vn2crqIwAdf6s26VRpyWrXYId6ZI6TqljXB7pz477KGuHTdx
bMbOI2m9KbNdHt8Oy+bknyKvlBHEQw06KzOZQSCagvWd1+wDAvlsASb9yy8uERFH
atHK3oP2GgV9pJNrCjZqCH0u6GQisRpW+KGSPGnMo+zRrxqq8ek/LD3jkDjvDrC4
gX4x5oIS/wWzHnEP1PPdd7ZsMMZqzYG7ExjpxC7XkvalEuvY1M6BhQr4XknVQJy5
/xBHpmT/OWiwW75NjUi3wqys+dsZXPdPsKOcKWZbAVMUUT7vffvcAZ45y3PulHei
rF7UXGjaNPmmtrg81GMBKR/7XK56eIvBeHiycLLdiHQmklusUoAg2D6KVy7Gylf8
T2WwTcR0aStS8ZbtqDT12JudJKbRjXK4g6ov1ZEAbkKRMuw7kpLi+kcmJz1Q3gZh
FpPwMFB+F403v0sGj7OCOe9FQr7Mnpb5jT+IqDKuBMN6IIbu2y2CoTX8RhAz4894
4YDPyFLe0wWQKl1m8ZSLCwWCJewSDUTMx5Fv0HpcAoOJ4yWeNn+VOeQY9STbMFfw
4cZU9hb9Uw6jUEC5RUKa
=rfTF
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
