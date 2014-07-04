Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaGDHj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:39:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:50680 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaGDHjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:39:55 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julian Andres Klode <jak@jak-linux.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: insert blank lines after declarations
Date: Fri, 04 Jul 2014 09:39:46 +0200
Message-ID: <2268306.t0PVlUp3mj@fb07-iapwap2>
User-Agent: KMail/4.13.2 (Linux/3.16.0-rc3-12.gfc9498b-desktop+; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140703191554.GA12029@ThinkPad>
References: <20140703191554.GA12029@ThinkPad>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1664320.lmTQ5RBMUP"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:uNote+ql+fMCdWcK9O1koXW7Mc7oanT0v4pnXqfKMwkfYv1k8ha
 9qz8Y5gsuyXryo8N21spoDvmH7yyxEwJyx6ga/KJ8JocP5kpFirQ/26R5WPV25AehDkHDGb
 iXzREzTWbc1jrmBEH2+lrATVwKFFqv1CL8Ch2skxJz7eUemjmgdQstsDwj6cYFAsjKPGucy
 6y4q55apCaF0bwqD2TBvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1664320.lmTQ5RBMUP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag, 3. Juli 2014, 21:15:57 schrieb Pawel Lebioda:
> Hi,
> 
> This patch fixes coding style warnings reported by checkpatch.pl:
> "Missing a blank line after declarations".

thanks. Looking at the checkpatch output, its requirement of at
least 4 lines of help text looks like a bit overkill though.
 
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
>  drivers/staging/nvec/nvec_paz00.c | 1 +
>  drivers/staging/nvec/nvec_power.c | 1 +
>  drivers/staging/nvec/nvec_ps2.c   | 2 ++
>  3 files changed, 4 insertions(+)

Acked-by: Marc Dietrich <marvin24@gmx.de>

--nextPart1664320.lmTQ5RBMUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJTtlpCAAoJEKyeR39HFBton7cIAIsdSvQrO2B+GzmYqBcP/CZI
vd7/MyQUG03NuAf5Zjby6UiSZX8xbVge5lXVMIthKlChLG2azcYB/7QmtmM4Mdux
PivNonXDVJA6do1VaDji3Q2UXn6A8IM01DLEopyQrk+XnmkV8v4S3X/K3VYm3rBP
RViyo2HFR1fax+H3odOLNBExirjMauZWYWzYPZKb3LxBIzTggeyn9ND8aDNFyZCC
Rqd4ghKQvwJL0RFxRmChugg6A0i+PAAmhn/rmjcFaAwnK/hFyUa+JdOy0Saet4iq
jtmYUdvZkjzQiwOCFeltprB959ROBdW1DKjOgJnyCDHa5DYmNEx75y04hg8lKgU=
=TFKr
-----END PGP SIGNATURE-----

--nextPart1664320.lmTQ5RBMUP--

