Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaLVLpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:45:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43728 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaLVLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:45:20 -0500
Date: Mon, 22 Dec 2014 11:44:38 +0000
From: Mark Brown <broonie@kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Mengdong Lin <mengdong.lin@intel.com>, kbuild-all@01.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Vinod Koul <vinod.koul@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141222114438.GA17800@sirena.org.uk>
References: <201412212239.7lsK60Dq%fengguang.wu@intel.com>
 <20141221144043.GA58352@athens>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20141221144043.GA58352@athens>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: fix platform_no_drv_owner.cocci warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:40:43PM +0800, kbuild test robot wrote:
> sound/soc/intel/cht_bsw_rt5672.c:273:3-8: No need to set .owner here. The core will do it.

Applied, thanks.

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAQlAAoJECTWi3JdVIfQ9oAH/AnI3uZgKfenTphJsmZPIieF
/vhoL6OVwIhqJEWY8N9EngmlMWVtEyV8eRVpG/ee1unSKJ5GW9IdZ2vOH/OcANag
SDOpup4q2mK39ZvQBWPN3ruPXTNAcOpY/SkqLH1KIMDUZqNXZ1EE5ZIj1FNfbPOr
haG1tmnP7r/hQ4Y+MadqltJBjfR0oJaU12bzTnwvdGdCXyOhKv0ZdZpYB9ue8kcd
l+yheNuQ+ctfBRlywYkbgEAPx85sVObGmewtOqj1K7o27Rzg3kF/WttTb9tsO53P
k9keCN/K0FDPpQs9IJUkya0VcBG11oUKzFqXqYkmdO4r2x7Iq0+eWjKXBy2UxQQ=
=ME5Q
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
