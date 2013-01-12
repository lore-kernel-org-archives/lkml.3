Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3ALBBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:01:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36448 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3ALBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:01:13 -0500
Date: Sat, 12 Jan 2013 12:00:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] consolidate per-arch stack overflow debugging options
Message-Id: <20130112120053.3362ae67bf2d3b2cc6042aa4@canb.auug.org.au>
In-Reply-To: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
References: <20130111170043.D7CC39DC@kernel.stglabs.ibm.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__12_Jan_2013_12_00_53_+1100_GccIWkScKcKPRPQe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__12_Jan_2013_12_00_53_+1100_GccIWkScKcKPRPQe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 11 Jan 2013 09:00:43 -0800 Dave Hansen <dave@linux.vnet.ibm.com> wr=
ote:
>
> I'm looking for some Acked-bys on this from the various arch
> maintainers that it affects.  I'd like to send it up to Linus
> in the next merge window.  This is part of a larger series to
> clean up the "Kernel Hacking" menu:
>=20
> 	https://lkml.org/lkml/2012/12/17/306

This should be added to linux-next soon, if possible.  Either directly (if
you have a tree I can fetch) or via some other maintainer's tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__12_Jan_2013_12_00_53_+1100_GccIWkScKcKPRPQe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ8LXFAAoJEECxmPOUX5FEcUgQAIEgVpp0+NP6diARhjdrV7/8
USY0TrR71zd+DghoRnWzI6s6uXw6nE0kaE2AftwjGhPh0tJnboJxNx43a7gIGWez
PMDvGF99rBJ9MN/zgZ5M9/96WpAJ2G6Dx1OeYcHQ4rJjKoX2iK6DBwXbKmhQJYPM
7TDCmdU2gVSAB+0sWHHC6RhOiwqiEBTEsPvGjxj84Do5spAjU01CBZeuSJdJqpoO
/CSeDR4tBHTm/H96cDOatjuzJ2T4fRb/kSOgQg4EPj4hMf+DsIK7DVBzLvvuPy5t
nKiTzvadZTzVoO9ReftGYm8cKB3fFzpAVu+O1jpmynwqIQmoZcr1v9Qo6ooOuLKe
E1QZ+dId2Msr1DHtCeM/x5lyKnJjoKfk19GwV3i958LOwSd6acVGUaVMj5uSVeNW
rlDoOYOZg27L6l7Y49Sj5omCragGbBRLjOD/w+HBK+c4SXWdLu5ZDU1jcIvqpfQO
UffP1Uozk/hnzLYFDCkBhPH/uyu303RDHlGoR4CL7TL+8006Qm/CueV64RsQm5j1
mtgU4VNsaEp0bv0aCj1EmqazL5FC8JtH3+wOEMzL5SCT7QiYa5VC7oKvW1Twhkx+
aC2y0t5mwxRFd1fmdT+s0PRfalzAyntz1RMrVaOvZ/VbGHlcjCUy/E+gjcAHV68h
ol7tTuoSngnAPz4NV3C1
=yNZr
-----END PGP SIGNATURE-----

--Signature=_Sat__12_Jan_2013_12_00_53_+1100_GccIWkScKcKPRPQe--
