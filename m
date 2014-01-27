Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaA0ABf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:01:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59827 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaA0ABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:01:34 -0500
Date: Mon, 27 Jan 2014 00:01:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Thiago Farina <tfarina@chromium.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Message-ID: <20140127000129.GQ11727@sirena.org.uk>
References: <1390780632-12798-1-git-send-email-tfarina@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5ch3vXimoUl90IHM"
Content-Disposition: inline
In-Reply-To: <1390780632-12798-1-git-send-email-tfarina@chromium.org>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Make use of rdev_get_id() function where
 possible.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5ch3vXimoUl90IHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 09:57:12PM -0200, Thiago Farina wrote:
> Signed-off-by: Thiago Farina <tfarina@chromium.org>

Applied, thanks, but please split up patches between devices.

--5ch3vXimoUl90IHM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5aHWAAoJELSic+t+oim944IP/3aPHG3sxbI6Gh8Z9YfTf/8j
epq59cCAXdWk9txB1INEeWMNEHYEMrrSIw9boyipioUD+qxM1UIRJlZrAvTFgkYS
7pOrZFNzZ36fo+KbTZwGQXc8ijA0aj7JLUSrKQp8zl24a+zK6yCVnUq6EiMZcaPg
kXtgR+pvkivyY1hlN/hyLnk32EZem+729V1hxIAVBcliyKPptJWMaIDXhcqmfd5E
76skV9zORlHBrTOsIbB48/3OVhCvWWwIgBFWA3oWxCLS0Ti+iJm3oEBqmvq/S/BD
Z3zAN8K1le+cyc0YTAA82emEVtE5/Oj05gZqgHPdZy6Ey3AfepaKEvvXQGmU+fgH
1koGCb47FLrvyiaHg3HKeDWQ96BAG80PgcHIVj8UGAqDjwWHVKvIWAUWCoswTSvP
ApLfQUt6YKNdz4ldqq1bDN3u0xf85OwmGqjuXLOde9ooNjhUPQl5OzXxV5tXOKnQ
1IVEL5HbGZCRPMFepAsfu7y5kTXtlh+RJFnmXplequgnXcM1OVMEbjKJyCQ0IH1m
BAjm37miI00AZSzQ93HUauDluNLjF1gkbindS+2FFub98mzlmSYX9mo48f+pb1EP
5Iei752QcQh5cYuZqjxX61BF4emBsfuxB5MAsoyFyMBr22qvk39p438LQjbNh+he
Qvc9LKgxzw9tD/0YxoHy
=SpGK
-----END PGP SIGNATURE-----

--5ch3vXimoUl90IHM--
