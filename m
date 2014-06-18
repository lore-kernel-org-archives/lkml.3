Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaFRUU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:20:28 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56161 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbaFRUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:20:27 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Date: Wed, 18 Jun 2014 22:20:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500-generic; KDE/4.13.0; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201406182122.29623@pali> <20140618200053.GK32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140618200053.GK32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart40092506.kqQJ93DvGd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201406182220.22818@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart40092506.kqQJ93DvGd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 June 2014 22:00:54 Russell King - ARM Linux=20
wrote:
> On Wed, Jun 18, 2014 at 09:22:29PM +0200, Pali Roh=C3=A1r wrote:
> > So without this patch DT migration for Nokia N900 cannot be
> > done without breaking userspace - which is not
> > acceptable...
> >=20
> > Also I still did not know why DT kernel does not report
> > Revision number which is passed by bootloader via atags.
> > Any idea?
>=20
> It was a concious decision by the DT people to exclude most of
> the ATAGs which provide that information.  Only memory
> information and command line ATAGs are merged into DT.  Every
> other tag is ignored (as there's no place for it in DT.)

So how to read Revision and Serial number in DT based kernel?=20

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart40092506.kqQJ93DvGd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlOh9IYACgkQi/DJPQPkQ1Jj4QCgxa6XtchMJpt+QIXPuo/wL1jh
nnoAn0YIIqC1FYUfzY8U6ikxTMdUt+du
=6y4W
-----END PGP SIGNATURE-----

--nextPart40092506.kqQJ93DvGd--
