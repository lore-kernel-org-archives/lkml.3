Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3ARG4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:56:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3ARG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:56:54 -0500
Date: Fri, 18 Jan 2013 07:56:45 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: sh73a0: Use generic irqchip_init()
Message-ID: <20130118065645.GC17790@avionic-0098.adnet.avionic-design.de>
References: <1358424013-31306-1-git-send-email-thierry.reding@avionic-design.de>
 <20130118000517.GI16740@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20130118000517.GI16740@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lrtWY/meeB8zN2QcvfIXdsoYZV/02fVg4TcCOTjk5lR
 h+fFL7cl0i3GqZRk1VopxpZMA199KCymnJKYYC1Ke5iTkhxBFw
 UzGpiBED+6H+pgjMnd1KpCzrrk7PLTEbIfkh9LJuhhW/kZiY13
 SMPcxuZ9kmQHY0xDpsBnPjiibDjzBjfv3JyGsKen25uPPZw2Xk
 b5Tpgfrt9URSQWl0wE2/FT8gnBwy7UDlv3PBTAIfSF/N7GgDba
 Rhn7OG/kZtEH2BiUCULs2TgEIBqJMSBvvcMQUsTT/g7d8t3+jJ
 gC7/H1UCMVCQWQiyS8raMB49D+BfI1yhyOi5j9I0n9inrKM86Y
 zTy2BQpNHyNat4yLW5+dH780OVSha60t8wxghrLs5YvCV3SHD6
 ve55Ih966y4oD2mgy660axOkhudvHPET30=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 09:05:17AM +0900, Simon Horman wrote:
> On Thu, Jan 17, 2013 at 01:00:13PM +0100, Thierry Reding wrote:
> > The asm/hardware/gic.h header does no longer exist and the corresponding
> > functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
> > respectively. gic_handle_irq() and of_irq_init() are no longer available
> > either and have been replaced by irqchip_init().
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Thanks.
>=20
> Due to the hairy upstream requirements of the arm-soc tree
> I believe this patch needs to be split in two. A 'board' patch
> for board-kzm9g-reference.c. And an 'soc' patch for the
> remaining portions.
>=20
> I'm happy to split the patch myself or for you to do so.

I'll resend a split patch shortly.

Thierry

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+PItAAoJEN0jrNd/PrOhmZYQALEowQjk2phBY3OJbRC9Y0ws
t/8wG78Eax7eHMCDuj91AbkuAV8timoq7UmI/8uu0q+zbSS3nuZEa3VnEX+BfCk3
9VAca1Kfl+HWvoaBVOZwhuvKV3UcLM7OyHxY7XND0GRSweMG5g2BnGhgBdcYeWmO
Y3nDaXSzQAAssbEOgjwTX62buR4rCcbeOP/aw5PSJ6U9lRVJekg5OfYDlTu50JcH
31PFnDbWA6n0ELKQFqBlSVxkirYGNAdn4fWV52gB70Kf6RrLLNcG6UVqn9vhJ1O4
WSgCanIKc+g58330xOy0/Mfvs3JqFr2F5JJmLXgJZ4o/8fJpqS/t2LXD3Asvq0KP
+H8dHQcnj7akg+Belv+LRg/l9mNax1aBmFKnB17M7bgOnYtL8fG+a/YAUyGCtmqL
pza1FH8P7f6a7ZbjGLR4py/67DkFowWW0ojmxu5c1oYaPvH1S2uPP2f2iGaCD4bu
c6x3FBwTT1Ixv0Uo6L3PU9+kBoMH7fhc7/D2n5dNqZSxm1cI+dI1XMKPYS/Hh4Dd
GVRa1zQSmAMXawlY6NU449oEcB+V5Jb7t8H7Y20QWFmY/xfQY6KG2R8wAcQyPLTA
hJ2x1y84+u+igdmWerlGp3EqM89t2oHpjC3hEHDduL3WoLvwzrEUAu9Xv0rBGeOG
cjgFsm8ROg7nl4MC6mlb
=x94P
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
