Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaBTDy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:54:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46806 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBTDy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:54:57 -0500
Date: Thu, 20 Feb 2014 12:54:31 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220035431.GV2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMWhbafIcL4/B+XH"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.224.205
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/17 v2] Input - arizona-haptics: Fix double lock of
 dapm_mutex
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMWhbafIcL4/B+XH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:12PM +0000, Charles Keepax wrote:
> snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
> it externally as well. This patch fixes this.

Dimitry, are you OK with this being merged via ASoC?  The subsequent
improvements to the infrastructure and fix this more generally build on
top of this one so they'll need to go together.

--qMWhbafIcL4/B+XH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBXxvAAoJELSic+t+oim9kFUP/2Tk4eVDR11CpdJ5zbO/y/k9
GdJ1NRQ0wDa4Xu3gp7CG02QvwpQVA/5Nk0/Yko7kf6hWp1nEMDJGQLrGBZRgHMZ/
NE4Npd1ua2c7xqhUtple4vMARFL5ks63nWc9m+LG+vbKbosdxY9b5oN/YWnMVZEJ
BQQt6jxKx6yMg+UG2kSzrt40AXO+9BfBahegUnfhPNqre7GOHo1moxNxBv4uMwsF
fMX1oZvNmQQYAZq8LKhsNYlNRYLL0u5C2Fn9Xmj9SIqhGFmQNH8jaRcoLgnEgZWs
RUS0fkyT+bq6NG6nNweXJp+dcz6HaYJrJ3MMkBz76THSSO+bWuKBR0VD6I0fQmYp
nC4CvK08enT67qQmz0cmLu27aQfGVW5qNa+93pkkILgecfTxjVMaujEcDhTUzBVi
q042BhmJn8W0+i0QuW4oIumC8E6BVQsGfkEdJBqZug8+/pz1j0B/MTwpK9KVWfIC
LvoarYvP9DuHbBE/Yz91I7lObL1JzAgdk9RlAc/xr34dmq4FbfnabBM3b6X9Zu48
F78xJmVe1NpRS697SSX4U+D4DMvk1SOFQqzn2g3KrQ4JdK60uK21/ocRpQ6DvaM8
aZ0l5AOCGyLgHs3Yathvv5prPgnBElo6JleRQodVjcfFWBPtRCsPV6oU41PttlvW
WxnAicuihrmEyb4MCepV
=h/iO
-----END PGP SIGNATURE-----

--qMWhbafIcL4/B+XH--
