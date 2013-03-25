Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3CYMh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:37:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757168Ab3CYMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:37:57 -0400
Date: Mon, 25 Mar 2013 12:37:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sound/soc/codec : fix build failure in next-201303225
Message-ID: <20130325123750.GP18316@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1303251950440.20514@M2420>
 <20130325120601.GN18316@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1303252017020.20514@M2420>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SRTEifjNkXp0Rce"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303252017020.20514@M2420>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SRTEifjNkXp0Rce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2013 at 08:34:27PM +0800, Xiong Zhou wrote:
> On Mon, 25 Mar 2013, Mark Brown wrote:

> > No, this isn't a good fix at all - we're moving the array to the header
> > but still exporting it from this file which is not clever at all.  The
> > user should be conditional.

> Yes, I agree with you much. Do you have some plan with this array?=20
> The exproting seems not necesary right now, How about just moving=20
> the array to the header?

Exactly what I said in my reply...

--4SRTEifjNkXp0Rce
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUEUKAAoJELSic+t+oim9VCAP/RRgb5qhm4rv0XbfZ3eQ2Oeg
vpWL2rKN34fkJTiUOUffecUOU5yynKfQjDrwxiwBvnr1i1Xfl5jbPcr++eSKVwxL
SiQUGNvrtEfyyv4EWq6/J2yQsM4emFMVUYOEVJM9gNuRfHAzdu1MN//S8M4UTA6B
O9wW/2Sz0TXxL+gk0n51kB9AWSh1rX/KeUPjkcM0gQG420LnCR5TY7xX57lIO31U
+oDPR3VKgx6n0L25cwPiWphKn2IhrfVyQVXOw3qrMW9hqaqS72biVK04fhpOQ6bU
fA4S2MqeNt5/0A4nCJ49Wqo020y8lWZkCKVkx37EYr8sJWO/FBhWY/mywjzXpq77
CYyoB0Q3HyI2TaCgmA2/c0f6snlNiTHSg2pajRtBrVnrhkg80BwCIdMSa6PzDAHq
GAOibCRhohPZeTm/wgtP6I2kGyK2EJZyTWivzultcUKM3Fvnhk8IXUNXhVfqa2HK
GG+TFUxlUVXLCsKb/JvvhJGNpnpHxj/thsUOBqB73YNcMFrDDF3COY8VPXxfjqMz
SnoKPG9WWNawiEy1tbfA8LTI3wZ9IUvnxOsmoM9HBILBj5mHM7dBwNatpJh648h6
49yWYPtcG9e1IiQ3GOIL0r7MCBUCe5SP6qnTPYfb2VOBkMygpIRbN69BaAzw/4Jo
MHstd+cS60pdUmDsUL4F
=znhM
-----END PGP SIGNATURE-----

--4SRTEifjNkXp0Rce--
