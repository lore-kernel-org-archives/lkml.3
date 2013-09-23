Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab3IWHbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:31:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35413 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3IWHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:31:05 -0400
Message-ID: <523FEE23.3010503@ti.com>
Date: Mon, 23 Sep 2013 10:30:43 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the fbdev
 tree
References: <20130923122856.0a3dbf72a44dfef1238d7a1c@canb.auug.org.au>
In-Reply-To: <20130923122856.0a3dbf72a44dfef1238d7a1c@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="28jeBTfKc6NqHBBtb979RANTenTO3hlo9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--28jeBTfKc6NqHBBtb979RANTenTO3hlo9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen, Jean-Christophe,

On 23/09/13 05:28, Stephen Rothwell wrote:
> Hi Tomi,
>=20
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/atmel_lcdfb.c between commits a17c2e7b704f ("video:
> atmel_lcdfb: fix platform data struct") and 5e8be022fb5b ("video:
> atmel_lcdfb: add device tree suport") from the fbdev tree and commit
> a5d58be0796a ("video: atmel_lcdfb: use dev_get_platdata()") from the
> omap_dss2 tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action=

> is required).

Jean-Christophe's tree seems to contain some old commits, never pushed
to mainline. Jean-Christophe, can you reset your for-next branch?

 Tomi



--28jeBTfKc6NqHBBtb979RANTenTO3hlo9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSP+4qAAoJEPo9qoy8lh71T0cQAIqsOR5wc+ztUiUvOZ1j9gzw
36woOr+nkWv617/Dbzfw4zAqgBgdQRvv0kvBo1Zu+p860g5WLj+LxiQ9+j+rr49B
R+21Zxvo3W6ACLidCQy6uG7Kg2wo1Qj5+rEPsFuKiinip+PiPAy8Cter/TSGn1D5
H7f8nK42By0fHCMFkFsITl0klo2d7TLFU6v6BLAbPKaOo8IGnSL09f3vrEOTMfzM
LOYRVXFru7rZyEaMCIjnqp9GfIq2yve7mUkxxw45Ep5MYROTOJUNI2oXm71k5mN4
zAqQltOhNk34K4qUGwXPUUC3jpDMb0qkAeoq/hmsyEbQX4j5Ak1jGSabB8/pCINX
ynlHvD1/f8Gqg4gISXugwH8gjH9sWElNxSbAC0YHybBNl/YcKWRWCUSOWJ9rgQcN
14WHM2CxwEGVRsoQnQMMz7+wpDbRjClWPAAYntaDT78yNOc37jAvUkETsSURuMPO
L/KGtpEE8MH7n4sWHwsJWbjnsTlBPWooeT2VwaEyjr1Q//yAwld5/OD24zTrs5kF
df0KwOjMqt2VK9sAfDgKKgH5MCcUQlRm0u9XFFpHoqfLwRS5twwHaIsknRcQo1AI
P1rS+Kols9CTaMv9+00GsVhWfxXaJ/XzjvgqORn5OfMh3aRnhDLgqnN0P8ixyvKp
uClHNoHPnYnGwvSUoD7O
=Fu+n
-----END PGP SIGNATURE-----

--28jeBTfKc6NqHBBtb979RANTenTO3hlo9--
