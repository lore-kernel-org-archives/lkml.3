Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaJKJUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 05:20:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbaJKJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 05:20:08 -0400
Date: Fri, 10 Oct 2014 20:30:13 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Cc: Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/5] ARM: sunxi: Add basic support for Allwinner A80
 SoC
Message-ID: <20141010183013.GQ19438@lukather>
References: <1412773376-25212-1-git-send-email-wens@csie.org>
 <5435F8EB.2040407@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EguBBKnZWdUQS9Kz"
Content-Disposition: inline
In-Reply-To: <5435F8EB.2040407@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EguBBKnZWdUQS9Kz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 04:54:35AM +0200, Andreas F=E4rber wrote:
> Hi,
>=20
> Am 08.10.2014 um 15:02 schrieb Chen-Yu Tsai:
> > This is v3 of the initial Allwinner A80 support series.
> > This patch series adds very basic support for Allwinner's A80 SoC,
> > a big.LITTLE architecture with 4 Cortex-A7s and 4 Cortex-A15s.
> >=20
> > Development is done on the A80 Optimus Board, the defacto development
> > board for the A80, with the accompanying SDK as a reference.=20
> >=20
> > So far I've been unable to get the board to boot from MMC, or
> > using Android fastboot. I'm using Allwinner's FEL mode to load
> > the bootloader and kernel+dtb image over USB. Notes on my attempts
> > can be found here: http://linux-sunxi.org/User:Wens#A80_Optimus
>=20
> Tested-by: Andreas F=E4rber <afaerber@suse.de>
>=20
> With this patch set on top of Maxime's sunxi-next branch, I get as far
> as searching for the rootfs.
>=20
> CPUs 1-7 fail to boot with -38, which I guess is due to the vendor
> U-Boot not yet supporting PSCI.

That, and Linux not having some SMP bringup code either.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--EguBBKnZWdUQS9Kz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCW1AAoJEBx+YmzsjxAgwQgQAKDRqEl3NsG6VU4+p3LrU5E9
xOfQh4+1zM5qClotka/kaOu31CHyz3MqnI+Uer//SgbZLwS/cli4NuDD0QLYdwM1
z8GAiBZZGvVQPsoPBQJxTk0P4MDBRQg97L0MzgVASemU1kpZ9O0cv/CGX9d8KBpu
KCNRO1JLDBxviEvrSaL0vmiqcD98yxYZ///MAbpFqm+K5VSvWDJcjAPx2Ve6jZki
fVzcK25hoG1FFlg9TUf/BtnNrEGsmA6kl9B6fLc3GWZ6kepYkpfxqZNuiftYcMlB
2Q6hP22k6U3bip05/sT9zziS9J48eyObHx5KoAMYrPz8f80s8IyqKrExR2eg9eV8
3ze5J7a9lemQsvmDyXzqqWsbgBfPhT09CSPGNmywSqwwdLMD93A3lHdPBRZPFzxl
LAXcXVvyVGbqLJW9WZMsoA5E9F8Me1rq9lfJxBoCeoo00lxIsnpw0wqZMi81260R
wObu1Kwe6zUIvQc26JQOKYfZnhePMpkDWwDfe5TQ12fJjhDH2//8gXq4lB/3cnaT
LaLbshftv2g43aiVv55siGZDgXCzcZCJqnMymSnAKMezwoucViXQH0PWGn0MkYeE
knOt4oZr0UIYNmrYlBYWvb8bK3pHohx/Lyk4y/1INs8YHr+MyJdA051RrZvXeWOD
wfqsNNMMvVdXZBszprs2
=qV4M
-----END PGP SIGNATURE-----

--EguBBKnZWdUQS9Kz--
