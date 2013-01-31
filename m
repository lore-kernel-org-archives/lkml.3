Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3AaLat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:30:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab3AaLar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:30:47 -0500
Date: Thu, 31 Jan 2013 19:30:38 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 1/4] ASoC: tlv320aic3x: Convert mic bias to a supply
 widget
Message-ID: <20130131113035.GF11078@opensource.wolfsonmicro.com>
References: <1359631394-9511-1-git-send-email-gururaja.hebbar@ti.com>
 <1359631394-9511-2-git-send-email-gururaja.hebbar@ti.com>
 <20130131112414.GE11078@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB5A48E@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zjcmjzIkjQU2rmur"
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EB5A48E@DBDE01.ent.ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zjcmjzIkjQU2rmur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 11:27:07AM +0000, Hebbar, Gururaja wrote:
> On Thu, Jan 31, 2013 at 16:54:16, Mark Brown wrote:

> > As mentioned when you posted this before this patch needs to update the
> > machine drivers using the device too.

> The patch-set 2/4 does the same thing. Since I have da850-evm at my end, =
I=20
> have modified that machine driver and sent-it as 2/4.

Two problems here.  One is that the update should be done in the same
patch and the other is that you need to update *all* the machine drivers
using the device, not just one of them.

--zjcmjzIkjQU2rmur
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRClXUAAoJELSic+t+oim9EpIQAIUYX4o4ixs0ed/xnJUVQVcA
Ep1sEUz3mGiUQHakiulo2cfc8BSRI+WuAVapxT2QdH+CHVqXW1k3SIUxfSIurTiD
4kjWRtUyIcYn2WubbYqVWvPVcojsfEfkQNxxLgTpDWQFfoSiQHYVZaK+y22kFbmb
Px6v+FJ864eDo7wlfQcM6K2lXYA5XmbYDZIxy19+2cKz3+CsvlOQgztL1Pb6Tvw4
cnovIA9iCWFWiyDoHW6oPLmACBL42NKMlL8AEsURXcVlbI5qEfLIVEALmgHCdYJ9
7YM9UQz7G+ykKYRILyOAMwNrdX8C0seM7gDDU/rMB21yVTbO0OGsiAC8DPIROBdL
ap8AYhPt+OazCjqxNn1xKI7+TUZ1mXdfa4xMAI2bG/gOaDwPcSF+fLOSgDytFczK
38sXYQjlawanhiTH6JwjKH+GUEh98WV0hRz2PwKGyhAYo1/OM09JtKN+49Zd1kJN
Za5E3/pg86ehF2bjaGAQpQrrH8zmf7ckw9ViVrKyPonVnAo+Ewf8iCdsnnRq11PT
JZ1jU+MIE9oqSkd70fmXioDfMttRscUoHwW3Xh7bttid70FKpfT9qvmqBA/FRP+a
zAea+NUtAqaXrodE8TUKimG88aLM6/OU0pmgS/N3diZJZSZql+7W7tH978MjkxWU
TMoGhyxaGsTe8/qCV6Te
=x5pW
-----END PGP SIGNATURE-----

--zjcmjzIkjQU2rmur--
