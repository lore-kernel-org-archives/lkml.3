Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbbAZUoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:44:15 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:51957 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbbAZUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:44:12 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Mon, 26 Jan 2015 21:44:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201501262016.52079@pali> <20150126203751.GK26493@n2100.arm.linux.org.uk>
In-Reply-To: <20150126203751.GK26493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1752650.yApU9X6Kkt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501262144.09223@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1752650.yApU9X6Kkt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 26 January 2015 21:37:51 Russell King - ARM Linux=20
wrote:
> On Mon, Jan 26, 2015 at 08:16:52PM +0100, Pali Roh=C3=A1r wrote:
> > This patch will cause that decompressor store full ATAG
> > structure into
>=20
> > DT tree ("/atags"):
> How about something a little more radical.
>=20
> Rather than trying to squeeze various ATAGs into DT, why don't
> we add a standard ATAG to contain the DT and pass that
> through into the kernel. This is IMHO how we _should_ have
> done the ATAG compatibility from the start.
>=20
> That means we could get rid of most of the libfdt in the
> decompressor, and instead resolve the differences in the
> kernel.

This sounds good. Now when I patched decompressor myself with=20
Revision property support, I wanted to ask same question: Why to=20
convert some part from ATAGs to DT instead to pass both ATAGs and=20
DT to kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1752650.yApU9X6Kkt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTGpxkACgkQi/DJPQPkQ1LeMgCgvVcDi8yWo0q6eOaExsVRrzYC
SAwAoJ33BWBshXvfiTOhVMyq6wMKfWCN
=8oTz
-----END PGP SIGNATURE-----

--nextPart1752650.yApU9X6Kkt--
