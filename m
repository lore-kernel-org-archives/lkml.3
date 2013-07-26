Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3GZSuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:50:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50227 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab3GZSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:50:27 -0400
Date: Fri, 26 Jul 2013 19:50:23 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130726185023.GW9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-4-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lLYmlcOQv78n9rhj"
Content-Disposition: inline
In-Reply-To: <1374863133-6745-4-git-send-email-eu@felipetonello.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ALSA: SoC: Updating jack implementation according
 new ALSA Jacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lLYmlcOQv78n9rhj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 11:25:32AM -0700, Felipe F. Tonello wrote:
> From: "Felipe F. Tonello" <eu@felipetonello.com>
>=20
> ALSA standard jacks already are implemented using ALSA KControl.
> So there is no need implement that itself or to use snd_jack for input
> events only.

This changelog doesn't correspond to the code change - what this is
doing is updating the ASoC jack support to add the ability to specify a
jack index when creating a jack.  There's nothing to do with removing
duplicate kcontrol creation here at all.

The change itself seems fine but it's not accurately described.

--lLYmlcOQv78n9rhj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8sTrAAoJELSic+t+oim9jnAP/iG+7C8fHAL1I61ptK2dL8P4
4WjyK101T3gfaHOn2ApBFqH5WKT/7HaQ0/d4nEwUoxs1I3DsWkQxqydjRtcT/6O+
4qhqAONAWc4B0yyGZPRDwRAeuOC76+tMYQ7OpmiDP4tqFbzJtEHD1wmzg1+PxeLD
jGXJ1MyTtO1u+/U8jMyx86oODqQz5GVVAsg7ti+Wz4D28+s8EBVQwl5+9MprvGu/
1nZsrE1V2c3uvclKiJZ2qlYDs6RKckCRHQZBXwuRp63U7QAhJjJ0/UeiJ1v5paBh
KHdsiQwM7Grsqm3/7BmbOMYh9Pxj/IPGSePDvFncSaYJQzOZXA2kEwJKjmujAQhf
tVmkP+uDJOZMMYD+BoPrrHBhlOAjSfrYR3065MoCDac2XAN3uqvw2zZZc0nucDC6
ig0RXgAt0IcoNOcw5hd6iR/a0JLLq3ySZK67IcAayCVHUrH19XP+vGErSWT06tw4
qkqDjSmjSwOLmHy7/i8XT9Z2fNHGxiE4NM1RV2xBPaxhGsUxgCk/omJaVwD2R/eV
MPtzUJN3pl52L3FYCR+Wj5WFSvoQSKrKSaVXF50rGFzOOVqFgITsUJNNEloTaGg0
ftGWJn7IFf3PG/cKXdn/oapO1nkBPrr4aWPLsMt03cp6NMarAdSxJ6Vcnb2TBts0
Ju9j7meG4Ysnaui5Yc7R
=afiq
-----END PGP SIGNATURE-----

--lLYmlcOQv78n9rhj--
