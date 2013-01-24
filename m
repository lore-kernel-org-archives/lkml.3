Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3AXKDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:03:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54227 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab3AXKDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:03:02 -0500
Date: Thu, 24 Jan 2013 18:02:55 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "rob@landley.net" <rob@landley.net>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH V2 2/2] ASoC: Davinci: machine: Add device
 tree binding
Message-ID: <20130124100252.GE4955@opensource.wolfsonmicro.com>
References: <1357293277-25543-1-git-send-email-gururaja.hebbar@ti.com>
 <1357293277-25543-3-git-send-email-gururaja.hebbar@ti.com>
 <20130104122612.GM4627@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB50DCF@DBDE01.ent.ti.com>
 <20130123154804.GB4565@opensource.wolfsonmicro.com>
 <1BAFE6F6C881BF42822005164F1491C33EB52FD9@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EB52FD9@DBDE01.ent.ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 09:33:34AM +0000, Hebbar, Gururaja wrote:

> So, by just using the SND_SOC_DAPM_POST_PMU & SND_SOC_DAPM_PRE_PMD I can =
mask=20
> & handle one particular voltage.=20

What makes you say that?  That is just not true.

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAQaiAAoJELSic+t+oim989gP/3s05LPnDp1GYNt6NHZKILPC
BWHP9plRUyXYc6ErgL67ohO3tPMQKRLo8Flp5F93BPXDLRVRurQXk6Nw+Ctk7IOF
5i0UMFxDYOpZ9WllQf57FPsqcL1L4LUpZWsX9SCVg/VEqurk8uxtG/e3Pty/jmIl
O+dQH/PygFQx/TDiQqGBpv7SLv1vW2QCyLLy1KXUb4EWEUV93xLHwmbcA8TM3/cJ
FE0hBvGELoIFvQIJSeN83wE29qMw/Ccr9+hDSH0ZFHbzSlNcIFHFcGu4Rn5nn5Ch
T96ZMXKPwqfefN7Kbpn2AYKXGl4HdhwnWJ3D7JWEUe/fGlwDk2r8oaxPYb7dNTPJ
3uZ2ww+HDNBsKv/LpMoSJIH+fgtG4LNdhRaO0mYfDsYkq3osUWuo07E8lhUbM6ig
wj5JoydLuH10auhobokeCTeJQydLokvFHF3NXH71B3FrOT8g5c/SjEDeybi+JO/B
5viN+UL7eSaFajyAbwthCTn3aBP2KzDLd8waI6gptEEiiKzu7hunuKuK49z3h/7q
FKUXl48Zb4lBKDMlVtLo6xK9V9fCkhvoROXxKCYigX2IQCMUxRDBNnClgXDQxx1M
zOJTstQgwHyK7FjDzwAD7ZsA+4p4hcUfpyMPCga2WBkRznef4jLHRg6iBis6NCQ8
mhfFO0iGMzhUgptP6ISv
=UMWh
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
