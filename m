Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630AbaFUKMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 06:12:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51724 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaFUKMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 06:12:17 -0400
Date: Sat, 21 Jun 2014 11:12:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Message-ID: <20140621101204.GD5099@sirena.org.uk>
References: <1402601652-24641-1-git-send-email-agross@codeaurora.org>
 <1402601652-24641-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDBW1LQyX6Jh6/q5"
Content-Disposition: inline
In-Reply-To: <1402601652-24641-3-git-send-email-agross@codeaurora.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Patch v2 2/3] spi: qup: Fix order of spi_register_master
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fDBW1LQyX6Jh6/q5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 02:34:11PM -0500, Andy Gross wrote:
> This patch moves the devm_spi_register_master below the initialization of the
> runtime_pm.  If done in the wrong order, the spi_register_master fails if any
> probed slave devices issue SPI transactions.

Applied, thanks.

--fDBW1LQyX6Jh6/q5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpVpwAAoJELSic+t+oim9AfYP/20qOOZfppUVQCoZ4EEt3HDJ
hm3cLC6Dd/uuG8h62yMSw/J1L734ccwVbzkosazEd3BXtfD2Q0PzaSRlS56taOf+
Oj2omVv45Nz/QdJkTsxiuDLJ3j6+cCFBWUjZC/0CArvAmgcbTCAefHWwHAt5vCdC
ntETuY7kmlnCHpecG5IdUfoaGJ1deaPLz9/KPhDv2HeJKM62/Id4pR2aKHOC+iOW
khb6ZabBX8BWPk/k6fL/plWcnaMwGyLGkL6iV/ZJ6rMnmph+g7ryxFDwBX9zjVPw
vjwFjkq9EjWXDYkXesFKAhZv57UuZl+6CdOMlz7TcdtfHtbhGsqFDgMzWyrjlHk4
UHoWPoo3fV3p7aWVTg3Ym+lmLvQyWi3FtubNOaNeGMGkuyZzZLLgkNDgR5Af08AR
Y6H21MwSu+7zTswDixigTEF3B1Um/qYysn91WPkAfVSnQCkAPhwOpxuhBNyDT9MM
2ZgzKFjnw/XyTKpLhziA+BitndnHeSJNWajlqaWbQbmhGLgFMWi383G2yB17ZLDg
mYShigpqH3WdaOLu3HAqLh4t+FqNdU/rrgIVtlxTMRgU2h/4J4lKGeHXqUDn2Cyu
6bn7dYSTWMggHrZ94DAfa21tUueZT7xWpJgu2DD12NtfEyuzQYFs/DYTSIBp6jRl
gHwpyLf+sUJs5gADi20w
=oOz9
-----END PGP SIGNATURE-----

--fDBW1LQyX6Jh6/q5--
