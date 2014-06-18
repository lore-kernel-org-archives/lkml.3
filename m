Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaFRTKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:10:06 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:61804 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbaFRTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:10:02 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Wed, 18 Jun 2014 21:09:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.0; x86_64; ; )
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20140618190108.GI32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140618190108.GI32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart26477218.tLSLmNidOV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406182109.59059@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26477218.tLSLmNidOV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 21:01:09 Russell King - ARM Linux=20
wrote:
> On Wed, Jun 18, 2014 at 06:54:24PM +0200, Pali Roh=C3=A1r wrote:
> > Machine name from board description is some generic name on
> > DT kernel. DT provides machine name property which is
> > specific for board, so use it instead generic one when
> > possible.
>=20
> http://archive.arm.linux.org.uk/lurker/message/20130726.132850
> .53d47576.en.html
>=20
> "If userspace wants to get at the DT information about a
> platform, we already have ways that can happen already - we
> export the DT stuff so that kexec's tools can get at it."

Userspace application does not know that kernel using DT. And=20
also it does not want to get DT information. Only board/machine=20
name. So existing applications stop working after migration to=20
DT. And because legacy board boot code (without DT) is going to=20
be removed for ARM in near future this will permanently break=20
existing applications.

And sometimes it is even not possible to fix userspace=20
application if is closed source - binary only.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart26477218.tLSLmNidOV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOh5AcACgkQi/DJPQPkQ1LKZQCgu9SzeOwRnt2iq4jUkCxJtcQE
C1IAnRPRpKiUNGmRvGHYtfVs6VidUBaQ
=Ex1z
-----END PGP SIGNATURE-----

--nextPart26477218.tLSLmNidOV--
