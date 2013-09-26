Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3IZDHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:07:55 -0400
Received: from ozlabs.org ([203.10.76.45]:54743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3IZDHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:07:54 -0400
Date: Thu, 26 Sep 2013 12:28:59 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Scott Wood <scottwood@freescale.com>
Cc: Hongbo Zhang <hongbo.zhang@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, ian.campbell@citrix.com,
        pawel.moll@arm.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, djbw@fb.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v10 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
Message-ID: <20130926022859.GL9625@voom.redhat.com>
References: <1379499333-4745-1-git-send-email-hongbo.zhang@freescale.com>
 <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com>
 <524074A7.7000001@wwwdotorg.org>
 <524169E3.7030408@freescale.com>
 <5241CC60.5070204@wwwdotorg.org>
 <52429252.10009@freescale.com>
 <1380159992.24959.248.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qgd2S+2VS1hsWwXW"
Content-Disposition: inline
In-Reply-To: <1380159992.24959.248.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qgd2S+2VS1hsWwXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 08:46:32PM -0500, Scott Wood wrote:
> On Wed, 2013-09-25 at 15:35 +0800, Hongbo Zhang wrote:
> > By the way, I know maybe it is difficult, but why not introduce a=20
> > document of maintaining rules for the dt binding docs? we have dedicate=
d=20
> > maintainers for this part now. Description language from one submitter=
=20
> > cannot satisfy every reviewer/maintainer, for a reg property, is it=20
> > necessary to say "offset and length",
>=20
> Don't say "offset and length".  It's both redundant with the base
> definition of the reg property, and overly specific because it makes
> assumptions about how the parent node's ranges are set up (sometimes we
> want to be that specific, but usually not).

To look at it another way, the format of the 'reg' property is defined
by the parent bus's binding, not the binding of the node itself.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Qgd2S+2VS1hsWwXW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSQ5vrAAoJEGw4ysog2bOSOX8P/27knqdD1mcveFLQPRZp92Ch
8/jLSM0q+JsX9kxNs/Syri7Or7kblg/NhcE4JzlJgFwPVw5QoePwtbnij50azTDD
mS0414Kbk3DBNOeVvP/WQXD+cSF7bxXIlfhYYtK11m4nZDQZViJ8rGEb+YwDmVR3
OXDOYoe8l9PjInNwEm/QcW2FWDKgQvNqMlwVlR2uM8EaRo2372S/y1ePgqPSTH1w
JK8l3ZCYP8Zv5jXVuT7SNFyq9CFOCVFwdf6/eeZMj7bK9qCqKRYA1zo5dTCJnAgT
RSXajamRYA9A2ScSHPuL9M9w2qFICA2XcaXnovcn0iologxSqLWTxzosYBJ9LF+X
Rf36rVT5A8eE5DvgAGVtVRQxB8aWvrUG6DplMvjd0/IcxYEfLACAIxFxItv2+jhB
c9S+U55EAdFeYdHCfjA14YBmGg2EPSb24EcD2Im5LMQVq7RCeEoFl0TRwzUzxTzU
EhTcDl/G2EKO7si34JUADRYkrTxUVbmafbUygH4AlB/o2atbxECVgFAgE+B8s1xp
JwaekYU7WDoTz2as2FsMsnAwglZSXM7wVxAoAHCBNPF3kx/Kj0tjt3TfiMbIIQ3y
xjN4ReWVjmLBDCWlTgjHWkxJyosKuMsgOgPup4Po8vpbQpB6JE67y/W2CnoS0e/T
IuvJsiD/dGTNak4+Y+he
=6ZZH
-----END PGP SIGNATURE-----

--Qgd2S+2VS1hsWwXW--
