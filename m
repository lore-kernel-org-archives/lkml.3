Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3JYIXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:23:53 -0400
Received: from ring0.de ([91.143.88.219]:50035 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3JYIXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:23:50 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 25 Oct 2013 10:23:45 +0200
From: Sebastian Reichel <sre@debian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] iio:light:tsl2563: Add DT support
Message-ID: <20131025082344.GA6425@earth.universe>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382565063-17083-1-git-send-email-sre@debian.org>
 <1382624835-10228-1-git-send-email-sre@debian.org>
 <35B50A0C-D1F9-4D87-86DD-951BF71F2903@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <35B50A0C-D1F9-4D87-86DD-951BF71F2903@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2013 at 10:32:36PM -0500, Kumar Gala wrote:
> On Oct 24, 2013, at 9:27 AM, Sebastian Reichel wrote:
> > Add Device Tree support for the TSL2563 driver
> > and document the binding.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> > ---
> > .../devicetree/bindings/iio/light/tsl2563.txt         | 19 ++++++++++++=
+++++++
> > Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
> > drivers/iio/light/tsl2563.c                           |  4 ++++
>=20
> For the Binding, assuming another patch to add amstoas to the vendor list

I embedded the vendor list update into this patch.
Should I split this into its own patch?

-- Sebastian

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaiqQAAoJENju1/PIO/qarswP/0XdLEadIAinJ3OX0TQ9khGR
vFQu11ieFfvIsDFnR9igugu7G6E8awpN7oSU3QoF+0Oy7s4Xz/8OXAc/oUSJu657
LpfzZ2UgkKbX+miydhkFxe0+ZsCcrFEwQsQZMVr9MdnMBC9pyV36kt/pmywfMeP6
P7ypgIvJnxoOnKxXiZALQszDwfF3FvpBw2RIE8gKmZt3UcMjGu+IGCO++WZrDuX3
bzbVaaoUioWxfx1tAN8bUXbqmyKSxB3tYcaq59ZmBz1wmXFLyRPKAQjjsG+rYOVB
AKdnvvwyKUamf42AoHLFhX1mrv4Q1On00m7UrHs+wGFU4Bb/HxamReX9sAbTMWCg
X9xzvSVVvC3yX78moiJo26xjLQ15bb1qu5CcCizk/TUfUkg17o8BZjRJOhXJ9/xt
lWxjqv145VN3TosIyL1f4bwHTII1SW61/z/RHnwXXiigTi77K9IteBWtsUBZj9kP
eEnBWHbCnbLx6otDxV1bGCb2RDIIrqQA8W/xOpUO2Qp2Jra7DVF+lW/rriKPGwAl
UfWhfRjs0foEnkjXGRScHaOF98IZu06l2jtv2li0g/6WZkBGikGaHDeBBiEgBqf5
PmJ7dnplfyIzdDce4YgctjRTshjmVcVu/6O9qV+YnGOTBgnAQn6fm3oU9QkUEGl3
Da3XDQP7/CoESlySHqiz
=YlRQ
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
