Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaAGMuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:50:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59180 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaAGMtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:49:53 -0500
Message-ID: <52CBF7D9.6050602@ti.com>
Date: Tue, 7 Jan 2014 14:49:29 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2] allow xenfb initialization for hvm guests
References: <1388775730-2984-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140103203422.GA2668@phenom.dumpdata.com>
In-Reply-To: <20140103203422.GA2668@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="brmrbF089gFfMnvoao7WWtqq70TPj1JG7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--brmrbF089gFfMnvoao7WWtqq70TPj1JG7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-03 22:34, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 03, 2014 at 07:02:09PM +0000, Stefano Stabellini wrote:
>=20
> The title needs 'xen/fb' prefixed but that is easy enough.
>=20
>> There is no reasons why an HVM guest shouldn't be allowed to use xenfb=
=2E
>> As a matter of fact ARM guests, HVM from Linux POV, can use xenfb.
>> Given that no Xen toolstacks configure a xenfb backend for x86 HVM
>> guests, they are not affected.
>>
>> Please note that at this time QEMU needs few outstanding fixes to
>> provide xenfb on ARM:
>>
>> http://marc.info/?l=3Dqemu-devel&m=3D138739419700837&w=3D2
>=20
> Cool. Is the video maintainer OK with the Xen maintainers stashing it
> in the Xen tree for Linus?

Yep, fine for me.

 Tomi



--brmrbF089gFfMnvoao7WWtqq70TPj1JG7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSy/fZAAoJEPo9qoy8lh71w08P/RlAHiaj9Ece7pg9DMw16o7+
+KRe4v+J9izF2Vj41y70qR2qvy3FM3QuTnhg3caN6xyZBHy2QQwy9Ybw5oolU5TQ
9m8eBCcAsp6+IzE/OuDaRCRupI0u8gcmhxCcIM3+ZSUhNM1gFzYc0be9GVyyj796
lLFBQ6vijkfgZgbYH7QtdwNrr6b3nO7k+LIpB0Yh6D0aY957Rq1mUsFHfm5FMd76
esbnSNnRCMHpOJkWWAlvd4kKJN7eZVzuXq/0zX14s68kqiom5MrxAEDyvL+usofj
NqMn47GH7cgyaGrJBEJ++wf1qdY0wkhi30+DuGeDmGCfVALk6Hk6DvcX+va+pGKH
p/M9mMeFRYZAspfTJjbN7856b2cBP1HFJrEAQZCQXfru9vfYH3ThAj9RhDAp6hr3
nZm4x7owiHuiEX5ohpatWueTxfKhfsJvZ+YiRPa+wTksvruMwofj7HkL1mGPfgUS
4A+xuKtylWZ/98T9uUAQQBMk8StllYTlyzTTHUXPInwQM+ObfOqcv/S3BZ9h4uam
TZhqsO8WMMdRuE4kv3H2ydcLMBft+KEXGCqx1miNf0KumJr5nfKuIxk44lDH5y8T
3JHmc5X/I/lDzPH4ZF5nFvpfWhHHU01pShpTKrlIKOuUbXj0EcNlJYfLZsKbVbT9
RgX/XB1nCsnTbXv74bzy
=EOHX
-----END PGP SIGNATURE-----

--brmrbF089gFfMnvoao7WWtqq70TPj1JG7--
