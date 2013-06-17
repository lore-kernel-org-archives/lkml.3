Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3FQJOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:14:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58127 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3FQJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:14:20 -0400
Date: Mon, 17 Jun 2013 10:14:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org
Message-ID: <20130617091405.GY1403@sirena.org.uk>
References: <1371226328-24147-1-git-send-email-illia.smyrnov@ti.com>
 <1371226328-24147-2-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xhBcNpeZh7WRSjC8"
Content-Disposition: inline
In-Reply-To: <1371226328-24147-2-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] spi: omap2-mcspi: Move bytes per word calculation
 to the function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xhBcNpeZh7WRSjC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 14, 2013 at 07:12:07PM +0300, Illia Smyrnov wrote:
> Introduce mcspi_bytes_per_word function as replacement for the next code
> fragment:

Applied, thanks.

--xhBcNpeZh7WRSjC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvtNaAAoJELSic+t+oim90a4P/1mmR60SXPgYM11YI4VslxnZ
bFpfHSewePsgBHwXU7eByE6Jlu8Qj1wQR1dqb67SMGntPxvrBt5WVSoo/KEWmxq2
t6TMsaG7vaECWRCkAR9tSkN6gXpDm380lxDI/FM3vubUfC5AV2ORRl+t/LFsknoW
oDtlXz4hepv6n9ZE00MJyhwcYRulnYSDa24Tng0H+kFNaIGzy/1AP6sLJWJkBeH9
t0EhrqB2O+OEJJTyTDMMd/XQSMz6r9PWcazNqbWNDl0FKgUcvHcwkN7ZNxyJC3ja
hRS2VNPy+WSfdla3219JkieO4VXbhP7yBbCKGGu/5xHSCEwplOyPeZJ7fxopAwQn
jdTSu1o83eunecfrY7Z3MSSABKfW0/TkrxfonIo0II7q2uJLm2MIYC2t3s4on4NB
DqC1qC+Ju7iiUX/imjzrnSSjQiQjSe3eYHS/rrtW+tDCpMZ9fiFI/494yGqxko28
vATJjLI7Ya09nOMT7UqnfzBh9/TqN/ipKzKViFXbzl0nnfvpZw8FqYU6oqZ+z/WQ
GTvdvhC5Z/Xc+H7HBNyDkyQZZPnnUTI0zGlRCsJ/osseD3ZF47nrtANl1QgLdUiU
6vBELkqBArrXCFi/VJn/5ZYeNuZK3ab5xzu7pFJc+mtLJoS+R/wcW4lV2IohEJ4u
om4ZGZJakCEH2+kxY4E/
=faST
-----END PGP SIGNATURE-----

--xhBcNpeZh7WRSjC8--
