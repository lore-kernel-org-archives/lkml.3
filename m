Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903Ab3ECJDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:03:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37720 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858Ab3ECJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:03:37 -0400
Date: Fri, 3 May 2013 10:02:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, Mike Turquette <mturquette@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>
Message-ID: <20130503090258.GG4945@sirena.org.uk>
References: <1367515215-30753-1-git-send-email-nm@ti.com>
 <1367515215-30753-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <1367515215-30753-2-git-send-email-nm@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/5] regulator: Introduce TI Adaptive Body Bias(ABB)
 on-chip LDO driver
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 2013 at 12:20:10PM -0500, Nishanth Menon wrote:
> From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>
>=20
> Adaptive Body Biasing (ABB) modulates transistor bias voltages
> dynamically in order to optimize switching speed versus leakage.

I've applied this but please note that I still have deep concerns about
some of the discussion about controlling this from other regulators.

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRg30/AAoJELSic+t+oim9GncP/3NEkoeofdTRdgmFPO1kdgGB
V7/vInEISlsssB26JwmkdR8U5RFyQHoOOsSZ+0iDkljRsaTFm1TRVpRcRiYgoiFh
SnKTeKoVPd/ElWToodrHzNfX8a+7WKLfyylgvH+sOeLlSK12+IaSzQt7+Y/4sQ0E
uavcEVTtZXdk92xZ7NNIM5HWiDXnZUtpfO+saNTY8dIZewQ8Lhpk228jVfUYx18r
d0wOSQGCtpST6RtdlzLOgnr4asNyoS22S1mJmQd5qWbn5+nLptdqMHDpRkVYgrEk
DEZ3shmUIJKfjGIHqDEo6/RHlwz0wuU2OqBSVbePy1/pz/taIwfV2ljxDxa7Qua0
RSQkmX48k70F9NPC34g/RTBocNjBxqB6K8YZezKOBYXo3JRu0ub7tdC+yawUg7fC
pGfIGI1CBIC68FFDVbhW6PyfPDMohE6TUVPBVSOV2KW2eI3LhGA0sCP2E0mWpHKo
filJjW+TGKBV7M+re6/Fch7JP7dbU9ercBofRa1H/aGLHVdbWIcRkc/ioXzO0s7r
cT4AFV59CCkC66RgAsKE7qViTodJOQUSI1MN2p6DE5NS6RZPXaKjaL7KXLSVIW9u
0IVukE/GT8wVtPIZs2PL7YqXlHuIUInxZihWfsHR7YY6QhBnci2wuYb2WTbahumI
d5iOkL2mwU9LDQmkqlN6
=WHVM
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
