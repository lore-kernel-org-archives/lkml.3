Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaLERio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:38:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:59746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaLERin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,523,1413270000"; 
   d="asc'?scan'208";a="649040247"
Date: Fri, 5 Dec 2014 23:09:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 34/61] dmaengine: omap: Split device_control
Message-ID: <20141205173902.GT3411@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
 <20141205142702.GF3411@intel.com>
 <20141205143359.GV30256@lukather>
 <20141205145642.GI3411@intel.com>
 <20141205170744.GW30256@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <20141205170744.GW30256@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 06:07:44PM +0100, Maxime Ripard wrote:
> On Fri, Dec 05, 2014 at 08:26:42PM +0530, Vinod Koul wrote:
> > On Fri, Dec 05, 2014 at 03:33:59PM +0100, Maxime Ripard wrote:
> Ah, right.
>=20
> I have no idea why it haven't been picked up by intel's build bot
> thuough.
possibly no defconfig enables this

>=20
> Anyway. Do you want me to send a new version of these patches for this
> trivial fix and the mxs one, or do you want me to send a follow-up?
I am halfway thru series, if I dont find anything serious I will fix it up =
and
push over the weekend

--=20
~Vinod
>=20
> Maxime
>=20
> --=20
> Maxime Ripard, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com



--=20

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUge22AAoJEHwUBw8lI4NHDtsP/1Z6kM5q9zuxXk1uF072GXDM
Z4FAdikzsETe6rediv2PMBioYClcOc5rjAqdnU5PRGTw97NBKRZygxkzCFLDsd0H
UAbr4bDuau5CABqSZ4gDPxH81gmpYqoPEOlum9qmcKWyf0H6dAjCqy27wiSMec8P
D1Te6u9Gz5FIJdejGSPIDvx37u7IV/3m0+Oc5xaxfCSwjlgLff+u6Zw+VhRKwT1K
YdKD9S4As7iI8MtD8j2aqGXNnh7q5Ytj/iE7A9S6Cxo4RHbO2l7BtXHZI1qO/fR+
HTw8jiCRjRRisCa+8LoxcspnIQEqzPvlGe6Rgluus6Vaxk6WAsVYcvqtkM6+BfQg
K8Sk1AP2pVul1Q2MTNuurWBt6Nx1POUaFUFJM4EdOkYTZAnmMywBOSRk27PspIru
im6C7DuPogOrAAHFBaxwG2B9lMTnFmqEldy38x1RlsG+K40ikZAXSDfUz3zpvP4A
QG+glj81ZCrEbCW3XUxJC2vmc+7SrMwmAxsdfkVsRK2B4YFmIgli5AtsXxcBhPfq
vkzaF/0lO96mijAycM5E5SgCED08FlUH+TC7kpXDYSTNeriX7dNv17SsXqIjdALf
i/UwXA2dN5F6/GqY6In3bPjVOPiuwGqNPpNyM5pzXz7VAzP0AspP8E8GoEEdzxqL
37ADB0Lvi7QIE98KZLnT
=mHP+
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
