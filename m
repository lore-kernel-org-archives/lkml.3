Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3FLOOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:14:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41662 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FLOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:14:34 -0400
Date: Wed, 12 Jun 2013 15:14:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Message-ID: <20130612141409.GE1403@sirena.org.uk>
References: <20130601210511.GT16790@sirena.org.uk>
 <51ADAE78.4050900@ti.com>
 <20130604093816.GY31367@sirena.org.uk>
 <51ADB6BF.6020205@ti.com>
 <20130604100511.GA31367@sirena.org.uk>
 <51B5A14E.6000500@ti.com>
 <20130610100330.GO31367@sirena.org.uk>
 <51B5B268.8090908@ti.com>
 <20130610124924.GU31367@sirena.org.uk>
 <51B8345F.601@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/7F8UcOhwbEJvS7n"
Content-Disposition: inline
In-Reply-To: <51B8345F.601@nvidia.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/7F8UcOhwbEJvS7n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2013 at 02:12:07PM +0530, Laxman Dewangan wrote:

> I think ff we really want to abstract this stuff then we should have
> the two different regulator SMPS10-OUT1 and SMPS-OUT2 as there is
> physically two pins in the device for output and controlled
> different way.

Yes, that seems like the most obvious thing here as far as I can tell
=66rom the frankly fragmented and obscure information but given all the
confusion that seems to exist among the people working on the driver
it's really not clear if there's something else going on.

--/7F8UcOhwbEJvS7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuIIpAAoJELSic+t+oim9WOAQAIpdv+CDg1wZvYNByuIoCrPe
45yjIFHS+yyYcm93Yd/gO4Ol+rf5AooItTnSjs+0hdM+Tv9dBbFBG73LKKFphc4D
7YgxnZ1RNyu2zZyeVOT00MWVfkNlZv4+39cAaphXVNg0utliEV6aCzW+1Y9B7t6Y
R7JCTff91bZqBO0DGp71sTMWLYvx9zbkx/vfyJKjajMgQ0uaWa3qOfq/WXmbscLH
nuwmaHw5Sxwaz1jMagFlupx53TZMgIrpPuGDr6j2I0idT4fsXtx5HRHf+gmst/Kd
Q+famyWnYS0XtBaa2k0PrvNb55RUixIXCqCXQVrKE7KUVIzXcgp9hrmmnRti+RtU
9ve70xP10LGS2HLoP0emP1LbZYyC30PQGG4rSUj+x3vQ4Yfw3iR6zzRo4W3jf4Rk
biSFA5yDITFDBdfci14OsOIgVN1vnXVNHhP64J6go4AzZSr7PCInmjXhIzpcHaWt
YaIShIrcE2DmFzhtTBHxasLqYrZJljUWrO+0eJT9iA6hDzRPOyJ5N1VePdnxpx71
WFsjCSiyLpdnUYZy68YlQjX0dGV6RFYsjMasXsya9Ql0kXaTUHojTcN29or5WX5c
5DoDC5ZojR29Lac1XcVx16xXPmuRE1tg7aGIUIzm5WqgfnSURcf2aYldBz1v/kNf
CBdw7Ek963pG3gefhmm6
=Mv8o
-----END PGP SIGNATURE-----

--/7F8UcOhwbEJvS7n--
