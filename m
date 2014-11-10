Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaKJNr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:47:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56271 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaKJNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:47:28 -0500
Date: Mon, 10 Nov 2014 13:45:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Anil Kumar <anilk4.v@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        peter.ujfalusi@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20141110134548.GR3815@sirena.org.uk>
References: <1415537114-9642-1-git-send-email-anilk4.v@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0p6fkQojZ86Dx7oG"
Content-Disposition: inline
In-Reply-To: <1415537114-9642-1-git-send-email-anilk4.v@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: davinvi-mcasp: Balance pm_runtime_enable() on
 probe failure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0p6fkQojZ86Dx7oG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 09, 2014 at 06:15:14PM +0530, Anil Kumar wrote:
> If probe fails then we need to call pm_runtime_disable() to balance
> out the previous pm_runtime_enable() call.

applied, thanks.

--0p6fkQojZ86Dx7oG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYMGLAAoJECTWi3JdVIfQTl8H+gK/cfvzkG0eHQ2fzjLswA3v
QFZsS2nm9EJWB3bLJEV7JhAYyTeMWFHepv/pmMiANBi2pL0ZbbYRS1gH9A9VJy/U
+VDnhgn5KNBod7musETF24x+Nshba5BXoOyF9Btr2xEXHkOv4OgwhCtupU/c4YCc
f+AZtge6mm8TpCKrbHOnV5L8mmvZobHWerD5/f8g4ZohI9mWGtwY+0B03SnVQGu8
4vLXcu3AWJH3HgU0Rw8ARae1s9/VYKOlifoVqdwI2PCGucSDSsvwq6G7OSIvQMcK
+7Zrkwxb+h5xY4YQY6gX4pVSm72S1frfOXo1ckuH9Nhf0MisLz7LzJo0cnDicwA=
=cq7Z
-----END PGP SIGNATURE-----

--0p6fkQojZ86Dx7oG--
