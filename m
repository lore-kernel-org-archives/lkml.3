Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaJMNUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:20:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50753 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaJMNUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:20:35 -0400
Date: Mon, 13 Oct 2014 15:20:13 +0200
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20141013132013.GD27755@sirena.org.uk>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
 <1412940935-14721-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9j2ELPqTsVbCO5A+"
Content-Disposition: inline
In-Reply-To: <1412940935-14721-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 2/3] dt-bindings: regulator: Add regulator suspend
 state for PM state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9j2ELPqTsVbCO5A+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 10, 2014 at 08:35:34PM +0900, Chanwoo Choi wrote:
> This patch add regulator suspend state to constraint in dt file. The regulation_
> constraints structure already has regulator suspend state field as following.

Applied, thanks.  Please use subject lines matching the style for the
subsystem.

--9j2ELPqTsVbCO5A+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9GMAAoJECTWi3JdVIfQbucH+wQpzSwg67+5517dw+H0tos7
dvMBXFmRc1eiHqbgIK1eN8MiJt165gTyNMdj1FO0Ithk7s4f4dTnHWBrsSAOYhg4
Ypzr30Is5SYpsa7B/xNc2Lqa2tOQDMgJLUrq8vQ4jlDQzyfCH8HNPLFLyijFk4P8
5d5TMkq1RP1GNgXvsWo6j+POM/8iObyGHaq/DC4sd7nUkgHv8mfbQzEgtzGuXMiz
3Et/QlqPPEQ/gzTickYnoYPVEax9LUuDxY4RDn+3X9ODQULz2UUMb1qIN8x0NxGt
4x3JSIMQ0eb61H3CLPzuQZctJVh1ybYXVpaLl3gNICtTRLw05ZbALjGAA9iOtnY=
=FHEH
-----END PGP SIGNATURE-----

--9j2ELPqTsVbCO5A+--
