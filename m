Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3FYPgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:36:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33941 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FYPg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:36:29 -0400
Date: Tue, 25 Jun 2013 16:35:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <20130625153531.GE27646@sirena.org.uk>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
 <1371737138-9340-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0CfcDg401mapelP"
Content-Disposition: inline
In-Reply-To: <1371737138-9340-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 03/10] pinctrl:st: Add pinctrl and pinconf support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W0CfcDg401mapelP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 03:05:38PM +0100, Srinivas KANDAGATLA wrote:
> This patch add pinctrl support to ST SoCs.
>=20
> About hardware:
> ST Set-Top-Box parts have two blocks called PIO and PIO-mux which handle
> pin configurations.

Applied, thanks.

--W0CfcDg401mapelP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRybi7AAoJELSic+t+oim9FA0P/0iJa8Ju5H5xK5kh6NeaP84x
CFrXACgHv/BG8cNtzc7q/o337dssp64KyMn5c7jLdExigYKyU9Uc3OJu0SSDwecu
gOh4SES6QQs1B704eDmc1Gf4I6pSHxx7sLdFvH/UAGkeL20Clkh/KU+QhxUZKrjX
CqUlP89VsRU21NaKKHLTMGH3oJO+pvU8e3B0kf7RjrsSuA8Pr9K3VZxQM/Z7NvLy
MAX5tw05yt2dPCbJBXK5jQUEkXPSbMKkad4HGlLKPGgXhNC/hSGwPpWo0G84IBIZ
SI/hLoFlGnPtPqHuQebTi7kaSR04eB8zcwBEEQprdZhrys6ARhY6iwoIcohM5yh9
bu5nI5+J7KUamJ9G/QMHJCpprPJqOkhTk8hP06pgu9sBs0dE0T/qW9obz1cMNDN0
lJlDI1z4KFoc2PoorKsi/JBujfENjijMOECG6rWt/TTieInRE8Fh+JQmE81LiQef
qqRduNxOCAWnj9upB0qy8AdmrUmJ4gnnu4D9R9MahItrF1ivtZySUpfCRikE+abT
XlxBdGxMtexgPJY2CIdW1ymEW4ls+BDMvBQHtMqeG8AN9xOWXJ6Ovm4iCK1Iv6Tk
CgeB0A1NvquhXi8nkbeQJQjCogEUxKq4oq5zODSk/OuYUnx1XhdwQ/U1CyUMomSF
55bc5vbU507t7lL1LxYE
=R48h
-----END PGP SIGNATURE-----

--W0CfcDg401mapelP--
