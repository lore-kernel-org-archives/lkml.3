Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3F2DBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 23:01:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37882 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab3F2DBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:01:39 -0400
Message-ID: <1372474889.23847.56.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [04/26] ARM: 7755/1: handle user space mapped pages in
 flush_kernel_dcache_page
From: Ben Hutchings <ben@decadent.org.uk>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Sat, 29 Jun 2013 04:01:29 +0100
In-Reply-To: <20130626223554.GB25104@schnuecks.de>
References: <lsq.1372214158.657310117@decadent.org.uk>
	 <878v1x4510.fsf@canonical.com> <20130626223554.GB25104@schnuecks.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ExQq2BQEVTrVykx4pbsI"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ExQq2BQEVTrVykx4pbsI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-06-27 at 00:35 +0200, Simon Baatz wrote:
> Hi Ben, Luis,
>=20
> On Wed, Jun 26, 2013 at 10:04:11AM +0100, Luis Henriques wrote:
> > Ben Hutchings <ben@decadent.org.uk> writes:
> >=20
> > > 3.2.48-rc1 review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Simon Baatz <gmbnomis@gmail.com>
> > >
> > > commit 1bc39742aab09248169ef9d3727c9def3528b3f3 upstream.
> >=20
> > Simon suggested Greg not to queue this patch for stable kernels as it
> > breaks no-MMU ARM configs.  He will provide a follow-up patch that
> > should go together with this one.
>=20
> Fortunately, the follow-up patch is upstream now. It is commit
> 63384fd0b1509acf522a8a8fcede09087eedb7df (ARM: 7772/1: Fix missing
> flush_kernel_dcache_page() for noMMU).
>=20
> Thus, please add that patch as well. If it is too late to do this, my
> suggestion would be to queue both of them together for the next cycle.

I'm including the noMMU fix in 3.2.48, thanks.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-ExQq2BQEVTrVykx4pbsI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUc5OCee/yOyVhhEJAQow/BAAjO8Nv8UFHMMckifUrKMnItb0urURV0ku
3Gb+uX1YGZdxcDQSM3TgkYv+XAq4yXt7NhGBo4Oo85c7frY0NyuF2HrQqk51GL0S
F3oU2BCkM53D1Iy5tUHZrsKTPjP52Iv3tTwDEsQlrWriSQzfbL/MdG3OrCG70Lzt
ZFfEUS1u1RUdjLMlPbTWIHVVtnw37VNz97ijYgV813Eiyx4NK8NLeE9tPIjFSZ3y
g4j7eqk6fvAiQSgsBPh1yCbxn4OUOBhuEKTkPaG74wGM0S/RYR/Ij92LaMUQOn3V
nXx02w3tjrukqbjsOqCDulqX7QYWrLnBVHXbl4rD9T0qUKokzQs0RMNLINbL5dTE
6aYD5mG4NSwVzksLBdQNJYpOAGzsxEHWHtI+VLoxnyyCuG2MUOsZB7B5rX1PavTl
ktcyz3tb8WXQ/puXuqTbK5J1g09MwgAXI6pycVbbTdii/LHQyyeSWfNfTtmaLaQ4
Eam+yqyH9+k5kUm+c+JDrfllsynfEaY3nvIcYhcarEEmsJ6p7v48voFKcok9Rt9q
Pn82Bqg/w4bjI8ZT6gCUfCIBOU8zZIDNQobZnesdvoPlwzGYSmoq3CnA02YoTJu5
LXlj/VS23IusSJdPFIGl56bfYuaLLIGpOUf0rq4Md+85lNIzw280jUM1QIjSssyI
n5e6s2Ihm4A=
=nhQx
-----END PGP SIGNATURE-----

--=-ExQq2BQEVTrVykx4pbsI--
