Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3HALN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:13:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49200 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3HALN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:13:56 -0400
Date: Thu, 1 Aug 2013 12:13:49 +0100
From: Mark Brown <broonie@kernel.org>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130801111349.GQ9858@sirena.org.uk>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com>
 <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
 <CACQ1gAjQ4raVHbMUfPZM=BQ-+SCbOJvxmR_5Vh=xpX592MZo7A@mail.gmail.com>
 <51FA412C.9080900@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jLr73n4HgVP/AII7"
Content-Disposition: inline
In-Reply-To: <51FA412C.9080900@overkiz.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jLr73n4HgVP/AII7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 01:06:20PM +0200, boris brezillon wrote:

> >[changed Mark Brown address from opensource.wolfsonmicro.com to
> >kernel.org (the 1st one failed)]

> Sorry Mark. Do you want me to resend you the whole series ?

If it's just DT changes that don't require driver changes it's probably
not worth worrying about.  If there's driver changes please resend at
least those.

--jLr73n4HgVP/AII7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+kLqAAoJELSic+t+oim9K5kP/1XsqHOy/1ZS4aXvNGG+LaIm
bZZZkWqRr6P2IEdrb5n3XMpBAWX2P+n+d0ZACuCwJ0IsHCBgEc4/LnkkjvhERTZk
OLoxtap+KnfLwLh0QdxpEwfFHrd9uw7Yq06G7BDaXwUb1RdeXgcln9BRqq+LEzCB
UV8pATcge6I/CoZ1CryleIB5ci2v/CNEnpj3vOtV2P1LbrDRbAG69+0x7sHATuVy
weLfNdT6jK8EWhfEWLEFfwEzall/iR0KWMatOj2DUheIVfPghgu/soBGzmW/C05t
Wb7Fg70tYDXttsLZSuMWWUjz/xXFqzzeD5gRN+KdM/FcPcQ7QtKhnlNmM4zfWAN5
bAUDCtzXV10kycvojkr27H9WnfvhdL1gkPtg6lsAbwDYN29KL9SH9Td9ghN2vuKK
kvS09laWYno54OIyWQklG/BlIjXuio2gr623RV8HvpoxREiJ+1B2WkUVnLlQ+wnZ
CNLZkKQhx/a4kDnLP1Ql2Aqu0LRpry9QzzEeSlwFd9EWuZL9yjgJjeQrPMwOpBNo
tplaEgblBIrdq+ORdMkGEJFcx6A6gg9zkUw+p73pLvXUWfC42LOnReY8Sik02mdZ
/DyPa7rYDFGnhTsvmycgZ7eNLSsDUKbT1z486AwzoPgm75Ow2jx0A8dmLqpzN9dD
U9Kylv3e5GjubfTQgtCm
=+7hN
-----END PGP SIGNATURE-----

--jLr73n4HgVP/AII7--
