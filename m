Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3JGLNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:13:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50256 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3JGLNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:13:41 -0400
Date: Mon, 7 Oct 2013 12:13:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20131007111334.GK21581@sirena.org.uk>
References: <1380809197-7759-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCF9ydJxlAJsfRTu"
Content-Disposition: inline
In-Reply-To: <1380809197-7759-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: get regulators node from parent node
 only
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCF9ydJxlAJsfRTu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 07:36:37PM +0530, Laxman Dewangan wrote:
> The device tree binding of Palmas regulator driver says as:

Applied, thanks.

--FCF9ydJxlAJsfRTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSUpdbAAoJELSic+t+oim9dYMP/j3KovWXGVI8UaIreIn/dojh
yjKRftW3Q/JIbJbcf7+off6NtM7G6WuAl/FFHzZAGIC+yTX5R35nu99KFYcNA15h
g3cNF6OGrEWdsNHsIt9wZCF/sqCtf89hY71WACMRl0nUBBlwdv/OIyCiDkzZy+rM
NDVddzKt4Qe8spJntepSQNmIVtiJWLbgp+astMKtJE6NmjmcZYZV+GuHFOAwzB0D
A3x+WxzvRA7C4gGWT/aOObsboJAkrfGS1qE2cdGiBzdQyHtMkMRczwa7NPPHORlj
X3gqUBlA76PJdv9MfYpautaurM0jqX7qzqeHQONvUXBgn+21r1QF88b9ZlJi0ZTn
oxV2oGsxVItP8hAtY021Sdh9dG7TB5AlsIthl1AUmsSx05KcLg/QtiMNMlPOrtJU
btqTbtVvpOJEUr31bgiiulUjPDMCthwumq+9jfCRT8kqADCrcEKvOTmJw3xa/WFS
oH5xmhq3UTJVgzvxWcBbgXmJuithzvZDbDKr7KM+lj6DQ61s/oriG5E1KHPecA54
MUIcT3lds/vakWFMnbnFlnRATGnK1yxNAiCOnvfdsv7fxUESydqsBg+9rPVf618N
Z3sqT/ZglHKQGzVCOu6XUQsbWSErFBft29dHCX3I219Ou3/6D3N4Pgv7oT9xEiMA
i1KKkSmfIQdGdp5GDsR9
=V0I8
-----END PGP SIGNATURE-----

--FCF9ydJxlAJsfRTu--
