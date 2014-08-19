Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaHSU0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:26:13 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:51908 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaHSU0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:26:11 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [UML] 3.16 build without optimization fails
In-Reply-To: Your message of "Tue, 19 Aug 2014 22:19:58 +0200."
             <E1XJpsx-0001oD-AE@www17.your-server.de>
From: Valdis.Kletnieks@vt.edu
References: <E1XJpsx-0001oD-AE@www17.your-server.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1408479955_2094P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Aug 2014 16:25:55 -0400
Message-ID: <21315.1408479955@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1408479955_2094P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2014 22:19:58 +0200, Thomas Meyer said:

> Can you give an example function that relies on this GCC feature?

cd /usr/src/linux && find include -type f =7C xargs grep __builtin_return=
_address

--==_Exmh_1408479955_2094P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/Oy0wdmEQWDXROgAQLTPA/+KhvF911vHckppc6ZcxJBXEmaExXX/i3P
8Ox4jKMmu+iKUS+M74iDgtVVed1LjJKRyE/PuRBxo1rSpv8O4z9Mn3+vtFTcaNiZ
dyyuUgzQwNwTxMrjmm7dHrtBlm5i3nl9BxZh0E4BEv5M60Fj39ygXsru7c1kP34z
/ktWmLQAeiKqPuJEG9R9xR4g54IlV7sOA6vW9x5e9EU/2YGkFbZ0KjhZ7DK8krHe
YOCQ9Nev3L8AXP60SEUSIrktK8AG8ujkpD9bqb+lDCdj0eN7kVuALfcPxjyQvlAA
arSFaAlaUDcHzj6h0pLCDykUJNz/R8X0ylS+H7PCauFWHX3tbrTdUpVJhf6rciY8
tkKPc3aiSYQspseVxaxPg8yUOwxUOXWnxU4fle9yyC/yqDWe0QFfZnLd59A20jU7
ndOxNYyagjr8MCCqWfKEWeLFi1fcgjtJCwqZEecUlIdO78rRLVq1wjfCH7pHxQBz
oLZH6+LvF7VNClX06NEF+dQpK+QDC1eH9CAim3dPVEB9CoFgT0eLezSP0Jur+DGh
WgE3XEjx7fx3Qgl1jjon7YrVQLxdgpEuOka0B68Qyc+ytrSjJpuzxfoZce12QAqi
OrFkNGiLgsVALxSYtHOa13l+27XucN9GFmJM4eEsbJH5PwnnqLVpTLoayYHwxcaP
H/ZE54eiLDE=
=5j+9
-----END PGP SIGNATURE-----

--==_Exmh_1408479955_2094P--
