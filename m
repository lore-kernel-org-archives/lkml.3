Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3KOP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:58:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36987 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3KOP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:58:28 -0500
Date: Fri, 15 Nov 2013 15:58:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: levex@linux.com, Caizhiyong <caizhiyong@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Levente Kurusa <ilevex.linux@gmail.com>
Message-ID: <20131115155822.GN26614@sirena.org.uk>
References: <C3050A4DBA34F345975765E43127F10F1C08BAEF@szxeml512-mbs.china.huawei.com>
 <CAGG-pUT22xoksid-2GmJsDmVQk8gR8zHvAr=r3Z2E4BLf+1jJA@mail.gmail.com>
 <5286215A.4020009@linux.com>
 <CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YEZ/b5VMxfka8q2"
Content-Disposition: inline
In-Reply-To: <CAGG-pUQWnFN1pGFGw9BaE7kDt9ODfpCfmuNB1vV0Jn=mTXTVXA@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.56.239
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Fix 'ret' would return an uninitialized value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/YEZ/b5VMxfka8q2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2013 at 01:52:19PM -0200, Geyslan Greg=F3rio Bem wrote:

> +       if (WARN_ONCE(num_regs <=3D 0, "number of registers [%d] must be
> major than 0", num_regs))
> +               return 0;

"must be more than" but yes.

--/YEZ/b5VMxfka8q2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShkSbAAoJELSic+t+oim9u8gP/Rf2jt5P1HtumHQdw6IHl6XT
qHvn/JvfcqP3wcss1tEGjl96gYLbr9CBnG9rErJ6yqDncSPTDLa/RwT7gok2IXST
28/Zzwiyz39wXdiDkBITM/VhahGKLAudL5NKrIlLNAjNNc58tvOOpCpjDZDcmZEd
55CWodjNbVrfIhLpGE/2u3Qui/p7AFYCA574GMgdtbRKgcmYk+niylLlZ+58NSoS
if7Pnf8YDh4WefQb0W1vRqKWwMG9CKMhWyFH7ARJDONHWFwZ4EE4SKsdj3UOi+oq
WRtL9SZpVg7XBc1jnvzNs8rbP9PN4QH1ec7IcjOboPub+1J+Usd2GFbYE0XN3fFi
LCYK/X64d1DOmR8+e4IU5NEbP9rrlk6y7fXBkwZlY/abSysBPG25oMj99NzHx0Pi
rZa6Pb7yS/AJg3Vchf0ufUjZj8NDhrH2EevqBfwB8TYGuX6NqE1hXUonNsbyCU8B
XlXSRGfzSQ2aJRrJuMjrh/Jcy/1u0pPr7k8MT89w6fV5Fzqw2fswDmjSnfvD94jB
wxINb/aVTuI9c+eX0eWnN6k2WVIsWJSFJaDbVEZ7nyQ6dPEg5uT6x6Z2V3629kR5
RsAkt/wERO034EjpN5FrZq5ACFlDYSnb/IAFQbIYC5iRVRPMDvOh7VnyNOH1HrJs
yaP3Fp8VWXWs9Uo3/LU7
=KW2q
-----END PGP SIGNATURE-----

--/YEZ/b5VMxfka8q2--
