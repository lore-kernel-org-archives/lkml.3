Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3JIJC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:02:29 -0400
Received: from sauhun.de ([89.238.76.85]:44632 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3JIJC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:02:28 -0400
Date: Wed, 9 Oct 2013 11:02:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use deferred probing with the device
 tree
Message-ID: <20131009090220.GA2646@katana>
References: <52540DF6.6050407@nsn.com>
 <20131008213642.GB29121@katana>
 <87vc17km2m.fsf@thor.barco.com>
 <52551441.4090503@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <52551441.4090503@nsn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > WS> Doesn't the non-DT case need fixing, too?
> >=20
> > Arguably yes.
>=20
> Yes, and it's also a one line fix. Should I do it in a separate
> patch or should I change this one and resubmit?

Resubmit please.

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVRucAAoJEBQN5MwUoCm2LHUP/iv4ZDwAtjLdMA2CaUSwHbm0
JZuNAlUg4wcBgCD6UzmE9MZe1LHRixQiJOO/0TLnY4TObkMOOFdgqlgRYMWoWFPG
zhjxDNG6bOC+jP0sC2HdEwrWEZ+mO3ZJs1YfIYvlSbTDC36EmMWb7bJR5HfE1wfq
4MnkUpJGNMTlxAhOOqlX4f4WZbqp477KAD233AFo9HW7WosTN+BihiED7EpzovNV
tpFYMYla/E6qLSPQ505r3nmUgQkyy+YnHKpaD5Cl7yKlO19ozfutzwjcSFqPMS+d
3Ap4GMzKpeOHdj+ycOCx+5zV/NOjuMLXt6IAKm/heYM5bwRXrRqiSUhhVgstTNii
kFB7zvMAFqk6X1xFlDxChGJjLB/bWtMGosWO1Lzigv2Wt5n/Dv87jZH4mDJrVCYV
VZGU9AXsYaGYm3lGqM2TUUb2bgGg/UW2ts1Vd1smsM2uD5jZDbmjgR163O/rKJM+
c27FT2ucM5IbjUvkrFJyvJSuO2v3a+WChie78+qA5PwufbbKyAjIaxaIRMB0ptoh
EIO0toieZxKHSOxzre5XKE2yxKrT6ljFTk5Tlz9lTXwoLfGWgksGflHpi6ZHC219
R72XyzVrD5Wt88CLWqkcG1TsGAOIQU/1x6jrF9CagKklbsK0iJP7gS2jhm3Q12ik
hNVCCiErJCu1M+1tkR7R
=1xDJ
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
