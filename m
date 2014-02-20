Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBTL0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:26:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47255 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaBTL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:26:33 -0500
Date: Thu, 20 Feb 2014 20:26:25 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20140220112624.GC2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-10-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBBFK/xULxfgnvFI"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-10-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/23] regulator: rc5t583: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SBBFK/xULxfgnvFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:10PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--SBBFK/xULxfgnvFI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBeZdAAoJELSic+t+oim9wAEP/0unBFtLGDcCnN0BWmnwK861
/N+hejbCDdTQ2y5/dYQJTTF1sIN3feN/YLk2jWFjZIPLtF+RMvtHLYhYfPz7/MKq
TnGcVqYPeNJbanmph08X0uhWEUy2QmwPqxvZx6BFDNQWabqduBDC/LJwsUeOB8rJ
R5pjWn47pO1vl5j05LGtgt4FTPweAET14bdcQEhHG1voSdanyWBNbuKbAAEZrFui
ZJ0YzCDQ2EgHKG/ntjkw9oPNyo1aY32qn2K4Cx5idS9vUbzMIybxDcTibnpPs94G
B40tCQi0bH4mj287JxbbekcRCXHtcK5w7ra4lorzIdpchQefrXPnKIEG0wuwI1S4
h+ng7m2Rc0E3g+Csg+o9wqSjmVMQvkNuhQvlrd6k2U3pWyq1oOcrgmlPFz+HzkJw
EXzVf9FdEb1JigUNsV7rT0VRDtkHoqEbuVpOFaPJGyLcyxNnQQ47GHGonav0n5eM
9un74vLJuwmvqmF/FB8RcBwI3JBdr7ALXySovx7ZfFqPTj/HxwbY+n0+PE5Eu07F
80sIi/DHpoyN8LyWgAH5KLw9OpO7y5IVo2JNLpS4cUsrD3p6iHIqQxGntru1Wwq0
k63jSz5Zwo336UI8e5Tz6r8Dy0/DSD5lGVWc4yvs0BBZPJ698Mtt8wfUMC5lJlRl
SPJHkDUr2fDlEdXHAgWA
=eGT/
-----END PGP SIGNATURE-----

--SBBFK/xULxfgnvFI--
