Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534Ab3CZPY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab3CZPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:53 -0400
Date: Tue, 26 Mar 2013 16:24:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philip Avinash <avinashphilip@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pwm: tiecap: Staticize non-exported symbols
Message-ID: <20130326152445.GB28997@avionic-0098.mockup.avionic-design.de>
References: <1364309698.4090.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <1364309698.4090.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zQO16dU6ygTxmdQH+1x22uU652mpOURSpFCbf2X/BSW
 GHViokj34LnzaHcWYLlMqoVMHr0cp2FPmL1Y2Ei6pVAcT81yHP
 E5z1sCKsQ4ktV07Gx7riS3Wku3R9vsxD4TnwXKAxMCQ4jlOWi0
 bbQ8RIqr+fJSqpDwS/BJ7lMtZBy3YJ+b+TtSmoDuPYg/R9M4OX
 zoRd3pTqhjplOW/OstY6pDPbe3I6bkfaG5A3s1Wt3SaIWmxARf
 CA3k92l1Chbq4cKiCVcwLaPuvmob4XpbqT+xeHc289egM22qCC
 6WRe6An+kTohxZbv3+9hL/1zHkxZlg8SiMImbVCJW7EUdzO701
 X6Q+hvgZyC/GhRT9+1cEuK2ASgEVVwZ+6l6xzlgH7vhEtv16Lg
 lVXmXQWIAsW2hxIfiH63y24xgfkXC/+vFMSjOF1ulkR2+ypNi0
 HIK+S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 10:54:58PM +0800, Axel Lin wrote:
> Both ecap_pwm_save_context() and ecap_pwm_restore_context() are only used=
 in
> this file, make them static.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

Thierry

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRUb29AAoJEN0jrNd/PrOhko8P/2LRfalugH2JI/1U04yOGntM
/nmsFcXmWzazA41VlZpzVkWnUmJyD9iOporYrVDClmDIfB40rImazrua5ujsxgal
L2dZcIV4SAaX95HJ7dY/0D2xPUEWnMi9mak8F5EK15d1Dk/olFR9ZtYV5/EIPh4m
Fy1jwB2tPmWvIlRU1ul0LC+YR9pMFnogRVPsg2b0cnyr2xJ5Awaq3jHt4pSKJkQ5
VzcyMy9G/OcBcPWEEb0EVI3bxSy2v69EL2Q2cjhvZwtKfEwDUNAFqGRjiaiuo0Js
srDWaaE9sH4vcT3GklZ3gKq/B/HW63CpHO8jFBDnDpWpvJTRjzuzX7XROpv+NtD3
74yNB5att6buuTGzsGZDpaV1XY5XnXLcbab2cPTqpz1P0pG4OxBhHsqVrJtLCpsS
lN/rFO1+Rv8jfP4/nhNRjWGurue4twEC8LxNsu07Wyzy1N8Cpf/+WDp03s5Pg5qY
bJapDYjLJaEZiK3Do2WIglZ6i6cvOknUOLPXCq2oLQwMyr75JNzuYskVW1p4G1Ah
2nxms1Uuir/3UBZw1o3naj4ld8g+2TbDj3I50YYlaPOURCAlWJu7ikZ7u91o1kDY
5/TwV5S+I5tODpImrSNODUGFHrr33xW8jQ4i/bqjjv31aU5sW6JD0exwJDDYulWD
Wx+eDQKH2LnkAlN5WmBI
=A+oy
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
