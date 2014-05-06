Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaEFUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:14:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54856 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEFUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:14:29 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: intel_rapl: No such device
Date: Tue, 6 May 2014 22:14:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <201404261224.45353@pali> <20140428035157.6e9458e6@jacob-desktop>
In-Reply-To: <20140428035157.6e9458e6@jacob-desktop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2005404.C325AhxMKu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405062214.24768@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2005404.C325AhxMKu
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 28 April 2014 12:51:57 Jacob Pan wrote:
> On Sat, 26 Apr 2014 12:24:45 +0200
>=20
> Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> > Hello,
> >=20
> > on intel haswell mobile cpu it is not possible to load
> > intel_rapl driver. Modprobe will show this error message:
> >=20
> > intel_rapl.ko': -1 No such device
> > intel_rapl: driver does not support CPU family 6 model 60
> >=20
> > Is not intel mobile cpu supported by intel_rapl?
>=20
> intel_rapl should support this model. I just haven't got a
> chance to test on this particular part.
> I will send out a patch soon and CC you.
>=20
> Thanks,
>=20
> Jacob
>=20

Hello, do you have something new about this?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2005404.C325AhxMKu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNpQqAACgkQi/DJPQPkQ1If7wCgnbnL1Pt0jSAuA9ewx4SoMMBj
LXoAoLRABqyxX4ZYlEDoI6N8TQCPq8MQ
=k2+K
-----END PGP SIGNATURE-----

--nextPart2005404.C325AhxMKu--
