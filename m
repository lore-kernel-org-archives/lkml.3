Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaJ3OEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:04:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45714 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaJ3OEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:04:35 -0400
Date: Thu, 30 Oct 2014 09:01:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: <dinguyen@opensource.altera.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 5/8] usb: dwc2: Add call_gadget functions for perpheral
 mode interrupts
Message-ID: <20141030140143.GE6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-6-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <1414538749-14735-6-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:25:46PM -0500, dinguyen@opensource.altera.com wr=
ote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>=20
> Update the dwc2 wakeup and suspend interrupt functions to use call_gadget
> when the IP is in peripheral mode.

it seems like you're actually fixing a bug here. Those calls weren't
there before.

--=20
balbi

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkTHAAoJEIaOsuA1yqREpIsP/iK3Tsew9mIO6Yk0V4KJfJ4D
mFo/qUTUBqWnBrsRytKoMoJ5XQDF9UlVmnOdueHYNzvc3eomq4ZDFxJuz1OBnq0q
wJ9VeMeBkkdM0MstS5q7uQ/dZ/We6jf6NqFHas8AlCK66bentTlaIq3fb1gcF3kl
M4kv+rtmVz4yfhltcJWTMQSgLpv2izC9QuMcdxo0zPF+Ca/mVuB+PafFtubsY0/P
7fHwtULPtQMchgK8rb2aiA2enefid420E5JWkzoqas1HLyfERG9QH6uyVetY8ojl
9ccvVc/iXhIDUlP8l9Bvz0Yeu2+LJD4zRxcsfNDVn71/73t5gANpM1xy5G0SZfsS
hBJHOg+N/cNZYaglLmOqWz4fV55FH4epm6JtjJKdKFaA0t7H9/atVYNgKtT4fUQo
7GKmFYB+/FakMBIg5ckT+S9BIIeXLGWjQy/nhVNt9g1KEK9uKKX45wei9WCmYefO
fObs1qjRhVENxQv+cRJkFBqmkWJvnQHS6+KPOJHPYwwv+dZ25YiZ895rkS3DcFLG
QaCWZIOyV7GY/QuG/D3vUMG1e+vVmQKEb0VmCcNGym95CH2MSd/04JklOlRquRkk
J/6eg+pMGvTQ1kAWwaSc1lzBQ5oBD2l73BFah+yG+6Px4RVzcKkazDvMw5neDtLG
iMkzJN65SqENLKxjB+JL
=qWBE
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
