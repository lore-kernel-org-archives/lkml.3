Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3GHQ2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:28:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46192 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3GHQ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:28:19 -0400
Date: Mon, 8 Jul 2013 16:02:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130708150226.GA16401@sirena.org.uk>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
 <1373290980-17883-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <1373290980-17883-2-git-send-email-sourav.poddar@ti.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC/PATCH 1/3] driver: spi: Modify core to compute the message
 length
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 07:12:58PM +0530, Sourav Poddar wrote:
> Make spi core calculate the message length while
> populating the other transfer parameters. This will
> be useful in cases where controller driver need to configure its=20
> framelength field without iterating through the linklist again in the
> driver controller.

This seems fine but I'm going to hold off on applying it until it's
reqired since it'll bloat the structure a little and it's a bit unusual
to need it.  We should do an audit in case some drivers do need this
though...

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tR/AAoJELSic+t+oim9BegP/0QJG84t44al+maP3PrnLkoY
EJwwx9c+VQqsGEQLAPztyIAJQEuCrd6PHcoiqcB4nRvPH2SHr7iqz6GnPtibEZ3k
cUWRvxQyYudl0w6i68WkWGohO+7upWMsi8MJkDFndGRHJv1rvakMLM4NH+JAIINP
YywsYB5ysPLFDT+6P86EIk0S8zzzeySsP8RZ0R3FdDLWng/ZwSrClS/05SAeeAvh
qP28NH5QC5KvsLnXW7VG7fAiW8GDIkZBPobbCTznhqK039kRetHitjR0ozh1bojE
xXBctCxVn97V04qlbd/HH5PRlyBBi04TbRf9MYVWHbApvUEPM72vol15jHF5K0Oc
jW+OuCyi2ev+Cy/uxjnNYDUU5W45C3j9NvPIuGP2wTgv/dXWjnGGCrq1E6EpMGNL
LQngwj0sfi9A2FlsiLT9tb1eQwfCsix3gXOIEiA8ChRLyd9R9ixsUF4aRzW767K/
xkO1ZP6far0z72QhOZeWst6LlqGJBz6+1Ym7QPsgB7YaLbov8hID/ej6iDnzbhJG
lNOOx87yJImlF6MDjBPjmUAMZX8czUXY3Iyd5zhnhhNw/1xfM9oGAwGx9TLZcyHN
TsPF2YvL716e9ujYi2/Jn2zeKjp6ZcTG/AGKfwM2LoO6in90A3i5jwV4kZ/TiYEW
H6w+QzNrbatEcIoRnfp/
=gsIH
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
