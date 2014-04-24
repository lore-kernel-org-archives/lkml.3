Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbaDXScj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 14:32:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44149 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaDXSch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 14:32:37 -0400
Date: Thu, 24 Apr 2014 19:32:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140424183218.GH12304@sirena.org.uk>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
 <1398217214-12204-2-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pqw+uiQfrV1nNtFa"
Content-Disposition: inline
In-Reply-To: <1398217214-12204-2-git-send-email-zlim@broadcom.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] arm64, sched: Remove unused mc_capable() and
 smt_capable()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pqw+uiQfrV1nNtFa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2014 at 06:40:13PM -0700, Zi Shen Lim wrote:
> Remove unused and deprecated mc_capable() and smt_capable().
>=20
> Both were added recently by f6e763b93a6c ("arm64: topology:
> Implement basic CPU topology support"). Uses of both were removed
> by 8e7fbcbc22c1 ("sched: Remove stale power aware scheduling
> remnants and dysfunctional knobs").

Reviewed-by: Mark Brown <broonie@linaro.org>

--pqw+uiQfrV1nNtFa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTWVivAAoJELSic+t+oim9uUEP/jwVZuKcnD9zbfGwtawHm9RR
xsj3l4cPRmjsvCh35sDNJL1kldWcZsAHX5z/gv9qux4MbifmEPzSVema1cwdOoLr
4RpygC9xkvnZAYwTnBs15DH3zVDTEMxSSzYAvNQCRrLCBNpfCA6FAvcuiUUyvLZ7
B0rMZGJ/Du9sxWSoRm49A+sa4qSMpW53fmz13zMdVAUMY4Ac45H5X/EUgT7ZtswQ
zO5PYNycTv9PGOCOb21HubQVECWoq1qF8XCFexNHH2X9ylGwCe0dcEJnBg62k61T
Ib0yJD2H8ZWBDNQCxwauwXbD7XTNgBYRTxu0fnNWLmhlglEvSLZP+b72mK42PSLL
odeGqhT5WlDts/D8k/ed0MM4ZJxh8SLyK3Qo503Iza0DT05st4qqoSPANxeE0DVV
mBKSxsEWOs7Gc1XPmdn1pwdZA9DXCBlBE6QLiufM06a3nUwUz4soWptIiIl5aWnm
bIwVf7EYJn3YoHGRTDQGd6wHYgSvQF4xj6bVkGlEJdG17uXadeuYvD23YHLstpgr
Vk66lbpqqVwYMkMXGbT3C2k7bNEfkC4LWLNouvAwIdq1iQWlS69ERVLuNrKMEhIj
ZwwRetonWpl6sKMJjerYUk5a3cy74THzqe/+O03YtVrk3KWz0GyrITVMY6AJ0i7B
YMAR7+Z68eueOnaarqvG
=/fn0
-----END PGP SIGNATURE-----

--pqw+uiQfrV1nNtFa--
