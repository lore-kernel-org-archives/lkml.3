Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaEOOX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:23:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:50132 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaEOOXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:23:24 -0400
Date: Thu, 15 May 2014 16:23:16 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/5] tsc2005 DT binding
Message-ID: <20140515142315.GA15716@earth.universe>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <1398470179-20880-1-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2014 at 01:56:14AM +0200, Sebastian Reichel wrote:
> This adds device tree support for the tsc2005 touchscreen
> controller, which is currently only used by the Nokia N900
> board.
>=20
> The patch does not update the reset pin handling for platform
> data based probe to avoid merge conflicts. The n900 platform
> code will be removed in the near future (3.16?) and the driver
> can be simplified once that has happened.

Ping. It would be nice to see this patchset in 3.16, since its
the last important hardware component missing for N900 DT boot.

-- Sebastian

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTdM3TAAoJENju1/PIO/qahKkQAInrLPv8Si/nxIsWEynE8RYm
YjHrOzkU0EiN/RPB3DT1wZNSnAHgJ9dEiAtuhjGYBssE5pyJIdTFG7LHrd3x2jvD
pS2pNlt8ifzzaLoB+a3j9d+QGhDejJqJ4sJKUmxSDga4fKnyKpsruV3nOM6WBruy
vSisJKT7pK9Rqq80vtKfISN1TTs0qAnN8RXb0oNoyesrVNOHzwqn5h3impuBJ0k5
/hd/bL3MR1F5t7MbhONYuK0UIGyTDFAkZXndCmOu90f0TOeVc/oGx0HQMEUjZSv4
3Vb/RRQTJEzoQ1vXVpiOcZ7baa/FnzF/eONt0+bRDKsrk8/THtXdAtODeZWsVzYG
Ey/lIco41Z1A2vRhe4umzOsG/rFszk8xYKSPAXNUaEqvAB44Dq7jQlp+nqcG0JYM
3Spn/pLyba1HFr/c0ftTovyEWDvqpUrtoUhZZS1cOu+PqHGPa4jV2LIR29rqIDdq
GuHE0ZQrvZuz3IzUC0m1TfTLeGBKMerjEAjZW+WxyrI0VJ6i9aGKx8X9rO7FiHNx
BusBvlSj0+NvNPwq6bleOdaGbwB35ZZGmAPo7GLUm+asbCoQii6bAHHo4wStR1xS
MNRRFsysWdbqfrKGHR3INGD8EzFXWrk+/AL/B6YiUqp7JPj8g3L7Uf+ow45EuN0H
lMWsoixXgkxqzhtj1aOy
=cPDq
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
