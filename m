Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaCLNpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:45:33 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54353 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaCLNpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:45:31 -0400
Date: Wed, 12 Mar 2014 13:45:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140312134504.GT28112@sirena.org.uk>
References: <1394580837-8331-1-git-send-email-mporter@linaro.org>
 <1394580837-8331-2-git-send-email-mporter@linaro.org>
 <20140312133339.GC17461@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zEZ/xSI4p+aogqML"
Content-Disposition: inline
In-Reply-To: <20140312133339.GC17461@e106331-lin.cambridge.arm.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/5] mfd: add bcm590xx pmu DT binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zEZ/xSI4p+aogqML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 12, 2014 at 01:33:39PM +0000, Mark Rutland wrote:
> On Tue, Mar 11, 2014 at 11:33:53PM +0000, Matt Porter wrote:

> > +			rfldo_reg: rfldo {
> > +				regulator-min-microvolt = <1200000>;
> > +				regulator-max-microvolt = <3300000>;

> Are any specific properties required on these children?

Regulator nodes can be completely empty (or missing) - for most drivers
there's nothing driver specific, the standard binding covers everything.

--zEZ/xSI4p+aogqML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIGTcAAoJELSic+t+oim9G/MP+gPBVSG2FiZW4w7xLnc8pz1z
binJKDBIciF2B59ylfrSsJzC6bEaQEMiJWlfk1ZEmiQEVMYwaUbZKT89hJXBJ5j4
1CyBSWXcaObwUd2HQcxmLu/FKGlHnCQo0H/FQzvk3kTu/OhqnGFCzC1vp5AX3e3e
UEsPu06DUTeLKfxMI6lDjzP6gYzo4VskJD/KeNPn3kJNrbq9U5mIJzUlgoTZyn/t
rgzKBU+z9+Rfjq6cGapMCh5q3Vt2BBNyNKFxzBuJ3dyTQevJvVYndml7xjwuBDju
bH81c8KXMn3xBR9rp/rln0mnCd/t3fMP0ujy2brRWL1VwYsO7vYcDXRGuHz2ilRk
OxdJ2YjXa4ssT8VQtJWNfdEhVC7hG7Rgt/n3jPTjRESOQqhZzN2iv423wYZ2pUqn
NPmR7mfYHw49NYcxVc1HYe2QugzboU4c0v7NS7/hK0icV3yr5bQKjWrCN4aF31oD
rxGgtm3FrakBCJF4gTXbA3J8INnBtKxXEVNsHNHldr5noSmFqh6vyDSoziMNfkWh
742DY2XsNbNzApa5QBGkZSq6QXZcH+/UxOOVwWKLlOW48tKNCLaF+ycLkvxXL177
/Q62sCWr4PxJDJyoLn1VNh92rKWsd6IwLEsZCsWEdH6d6nv4yHIy8pNwekOedse5
86p4kx9sX1VvzaH6gHvb
=3OKP
-----END PGP SIGNATURE-----

--zEZ/xSI4p+aogqML--
