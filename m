Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3C0W5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:57:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47813 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754999Ab3C0W5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:57:20 -0400
Date: Wed, 27 Mar 2013 22:57:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Xiong Zhou <jencce.kernel@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [patch v2] sound/soc/codecs : fix build failure for next-20130325
Message-ID: <20130327225716.GZ18316@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1303272127400.26487@M2420>
 <20130327133915.GU18316@opensource.wolfsonmicro.com>
 <51533AD3.9040809@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KO6AnYnUdC9Z3rW+"
Content-Disposition: inline
In-Reply-To: <51533AD3.9040809@infradead.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KO6AnYnUdC9Z3rW+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2013 at 11:30:43AM -0700, Randy Dunlap wrote:

> Do you have a suggestion for a kernel config where SND_SOC_ARIZONA
> is not enabled but SND_SOC_WM_ADSP is enabled, which causes a build
> error in linux-next?

Yes, as I've said several times now the user probably needs to be
conditional.  Take a look at what the code is trying to do here...

--KO6AnYnUdC9Z3rW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU3k9AAoJELSic+t+oim9ekEP/1jGVQTZh3FHDQ3WL/u1RXxL
zDjI7CQCW4qJE3aRd7hNrwpv/9oyAzr1ACOFhuLc/xEN8t9d89HLSxfEwWLPC7QS
ji1RxDlDrjHkX0MI/PlU6raqhRkPc05NCBaKKAsJBK0cd7ceMEc/PuTBBoFKqYvs
ulvPFBaySuRa+Tse9eFizYwFcUFggPoF85GyHsMtmnqVQdzEsIn3LgbGRqSsvosj
IiiV0PNnGoOi3oos23NfaY8VT6lqnERoNwXaM5U8fLh2Vuofy3MAZISKJWksLtrr
k87Wj0ZHSHUqwPRkx2NKrki7OXhsIAAn32RN4e2sjcVA8BKc6WTCTuX9TrI+YZ2j
U8LrrbXEon8Fu12xPZSI/lCsMKWPDa+ZvQx10mfvzzKfR1ZGMNvKwFTjRCKNUJZZ
Aw61EzZrxHbp3VnopBcCndq8886toVjIYIXUaAihO7+aOv/OB7ervrAO9ZIab3eF
LcQF+vORIoR/V26nTzSop9hmxUgZjl2/+W9/hv/P+ae7RjRMey2DR7fvOFnpkgjd
Uh9q/gqkqIBjqvPJbDqSNkCWUOYf3p/XwTkX4PlmT+aQR+7qqTs8gYgnnHSxvWcH
dLooX6REnimykGlAPmS+qr3ZCPnsHocZ1OO8vC4b/9NzWeG54Mm3OEmuGizDoZI3
d+I6pKdX8Msk4o5YSwEy
=d/bn
-----END PGP SIGNATURE-----

--KO6AnYnUdC9Z3rW+--
