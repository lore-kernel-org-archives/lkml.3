Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaBSNIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:08:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36329 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaBSNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:08:20 -0500
Date: Wed, 19 Feb 2014 22:08:02 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219130802.GV2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ae33tdbaUHKlI+oB"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-4-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/15] regulator: max8973: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ae33tdbaUHKlI+oB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:00PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--ae33tdbaUHKlI+oB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKyvAAoJELSic+t+oim9sR4QAJKzBFgQ+b9gwKqc9LpMHD9S
jCgDuIhVWOeNkn3pFd6ERa9ebLTkZEekBFLvQBcw7f5/6MPUB1Esd5GYLxQ4mzn8
uq/xQnPt3WABfM2fruTsN6ejvsTmDeNHOJYgmUiTu/pKwmSWgxgfcJB1XbKN3o/T
AatSilcDdMrGUCBOnpPXS97uZ71luB3U2fL9HosCtd4tnHn0PbLhIrFq63x2qjow
zHoXeHzbdc8SAsdU7f0uVPEyRbk9+vPE1ambrPWNuMGkEGbD5E/spTXetdoQJ6NM
7H2XHK+A7yjYpg/FdwQTm4/mJug3Gt4P2ccgrozK5HNe7maunKvtF7+eSrcTUo4q
7lUxTLoz9PltG4RO728NTOH+Sc9OqCKgpexi/eYxKLtI3ZI/eGJptTDvDnHuOOLR
hWHSRA1x+sR+UHjSprUvBTs0DYYe2+tsGjorvTd2eyitw5PaQo0NUjtcJyDmDEqC
BJ5sYfVPib1XcSO3k5HbvqHDg4SvQGyfznDQ6riNNnqIqgv+2tU6LyN8p2cJ77O0
WbVL8L++ajwBx1+MFrhsgkn4Mu5/sxJIVw8OiD+JOxAepEIkiYcPytUl9ZWZ7G7Z
rvgwe58smayXg0KKUpveM/0avgzn0xh81VZWk3H0F+GwVU5BbmgMTm3mpp0gqIh0
6BpnsCpppyRMJwmDusnC
=xE3N
-----END PGP SIGNATURE-----

--ae33tdbaUHKlI+oB--
