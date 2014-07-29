Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaG2SZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:25:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33348 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaG2SZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:25:40 -0400
Date: Tue, 29 Jul 2014 19:25:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140729182524.GZ17528@sirena.org.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
 <1406651339-28901-3-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LC1YWv9qPTwZNmWR"
Content-Disposition: inline
In-Reply-To: <1406651339-28901-3-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 2/5] regulator: core: Allow to get voltage count and list
 from parent
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LC1YWv9qPTwZNmWR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 29, 2014 at 06:28:56PM +0200, Javier Martinez Canillas wrote:
> Load switches are modeled as regulators but they just provide
> the voltage of their parent input supply. So, the drivers for
> these switches usually neither provide a .list_voltage handler
> not set a .n_voltages count. But there is code in the kernel
> that assumes that all regulators should be able to provide this
> information (e.g: cpufreq and mmc subsystems).

Applied, thanks.

--LC1YWv9qPTwZNmWR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1+cRAAoJELSic+t+oim9y9gP/28pPZSR5MGdyetLh/Smvhd9
fkWoPkM++JG1NS3IPseKIT3E9hFLeaM4H+EsOpnjMWfTYieA7Axedd/gHFnn04jn
+XZAtqVr3UI1iOpJ8n8UO90fedmTDquyo4lG64xCMqbDw0W5+EFJLFGti5Ix2fRd
qBavBcSYDBjjjaP8TQ4JCmyfMrvSOy+bCzPUSBwKiV6CAtqDXZ+GQCm0DMn3BDLd
chzEXQwqtPv5CElZk8XypbytbMrMbEXIRXXWngEoiOvgHInaWKqTqRq+umwB0bQ0
GGxJA57/ZD1y+zBzFZK8gMf3xIXz8/HEGOcWlBysVg4mF1ZNN2Fz8yWvl13L0I4J
06MIYJq4NUN1SGZKtk0cYcsCWFrigZTy6/7kI+dtTwVrhoZWiTBF8JqsKJ5w82ja
mV1b+jA/clfH1BygV0NrOzD5e+KGwvce2FIKw6llRZpxPwN4s8AhO3WqTwhB7dDh
71g+wEQwQNqoLa70Y/9cS4F4cqV3sCU1YO/SPrvImC8Z74j/Xv3pq6qEe+TJ1hu+
R5lNYJzNRTdnvsgC/P10498vmRmmcG2elBdkg+5j/OCQqpstrGn+Bij1wGx3kLV7
NzaR3IoQmvv23sqUF4Lz8y/xL19mO370xrtRoFu5tKlToSlHPCk/spayycct/h6j
bqKfo/z2bHF+omq1/dNu
=ilPJ
-----END PGP SIGNATURE-----

--LC1YWv9qPTwZNmWR--
