Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaA0TfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:35:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60169 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0TfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:35:03 -0500
Date: Mon, 27 Jan 2014 19:34:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140127193457.GR11841@sirena.org.uk>
References: <20140123163428.GP17314@sirena.org.uk>
 <1390499847-8822-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="562f9N4fbIs+fPrJ"
Content-Disposition: inline
In-Reply-To: <1390499847-8822-1-git-send-email-nm@ti.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--562f9N4fbIs+fPrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 11:57:27AM -0600, Nishanth Menon wrote:
> Certain platforms such as DRA7 have quirky memory maps such as:
> PRM_ABBLDO_DSPEVE_CTRL	0x4ae07e20
> PRM_ABBLDO_IVA_CTRL	0x4ae07e24

Applied, thanks.

--562f9N4fbIs+fPrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rTeAAoJELSic+t+oim9iZEP/R5nR6txXjzrDDL0R6C0VuvP
3tJ0GUpfYWhdEUjQP58Ow8C8Pd8+qmP6MheQc1lpH5Xhorw0e4Ccb7drO/KwN20m
Lzbo95eHLZV8sNYXf0lLcs0erSZbgbGtIHmpp5YBfNHeP9WbhnoI6Bg1wGDkssoO
+Mv6BH7GzWCjHPsdUPCDH5e3fQgG5fJ0NB1qzmlI8WAXDjKS1vU+2V7p/ZUVZUPk
ik9Sk5I62jVWiMqjwwRTB6+jwS49IS3GI6oP4qqzNAOGaFnABlASVtMUIYCtnnHc
X3Q6m9maz/1Ip38fcQmSi4Uh/faIUsDAI2OJbFC897+0fIN/dFU7f7NS7DDQibRn
Kc1x58Mu9RY8RiqEMeTsZuxMpoDfIX4+V+b/CEeAbiNiCbwFs8YhBhgPlZ+9rsTQ
Ev9/BX2QK6vJ4IOrqzY1fVAM1BKnfMS58AQjzd9jq6rttR+i+HjCwGvx6b9gcuhv
g33swG2Wpxo9QypPJMZMSDWiesuJK5BUDkL44vDgbKUj8xSGquP4Y94n51inpB+z
qMyhsLJfSKTbaT58bW4df1AofXXIf/0c5xfSeDQDuun8UCOnIYcLOXtPVDUvwmLu
Lb+MPLFoH7gm2+4i/RFZpvSy5wlgcUwrQfXKcLDWuDmwKImAZK02tC9k1IrhDEb6
PqyVw6eZzhBbDRRMqtjH
=S9HT
-----END PGP SIGNATURE-----

--562f9N4fbIs+fPrJ--
