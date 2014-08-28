Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaH1PBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:01:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38085 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaH1PBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:01:30 -0400
Date: Thu, 28 Aug 2014 16:01:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140828150105.GB29327@sirena.org.uk>
References: <1409230104-22750-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <1409230104-22750-1-git-send-email-geert+renesas@glider.be>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Allow SND_SOC_WM8978 to be selected manually
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 28, 2014 at 02:48:24PM +0200, Geert Uytterhoeven wrote:
> When using a DT-based multi-platform kernel, there's not always Kconfig
> logic that selects the right codec driver.
> Allow the user to manually select WM8978.

Applied, thanks.

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/0QtAAoJELSic+t+oim9B3MP/1OV+gOwt0lH7RQbzJL/bVen
txlonhecLw2M9U20ESpg48o5ZaZz1/1zm15cKorZc3iUiJAPICXKD9/JaVqztMGE
xIF1MPemIqRm2ziCEJ9RvqlFjPSSVcUaJCX30pwfLlDYpBtNrw2y2w6+W6eKkivy
yZEl2M89n7QdmEHX93vabd5NlUsgPrYo9uFMgTUbhxzJD0Ogs0ebA+Xrgq7cDV4D
7865DpeV+5Lj0OnwjWhAzujphxPls95n1x/8iPjvej9+1BEnELOpLiFYtCSg3uHx
wStmwgb6auvaR/KU1wssATGlpqYQyjD4WA6M4g0mjZce/uaFk1jamk6X0ItiEbwJ
uH9hq7KIvHcgeTW9+HElhVPEOVOoEMNM/Mo5l/63JIKq1mhKz6SBNc9MQCw4gQYz
mWC9T0KA6JTzflUdAdlJviYIfQ56VhfZ8Fax81fhK0+i1jmW4s7+ExXq43AfWGbe
YJF6OGLfIxg5ICsfF1WCoNJAVBRC+E7RGdGRCp9T3epOa0/289QUzHAoPCCdCFnf
iQMHV9nPgWIO/qa131ZbkCzKvsyb0PbALp8HqbHh9ACDb5wwrIspuJkgKpFJetMG
uj/+5mGukvbcCh0/NszqAh9+FseHWIY8OV8p/ZtPKUJVEyLT50vsLOU49OfyvZQl
8tJgbS/KEfI5HVm9I8ks
=Etaj
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--
