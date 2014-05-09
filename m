Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbaEIQKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:10:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55484 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaEIQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:10:23 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v2] radio-bcm2048.c: fix wrong overflow check
Date: Fri, 9 May 2014 18:10:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.15.0-031500rc3-generic; KDE/4.13.0; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>, hans.verkuil@cisco.com,
        m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, Greg KH <greg@kroah.com>,
        linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
References: <20140422125726.GA30238@mwanda> <alpine.LNX.2.00.1405051534090.3969@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1405051534090.3969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2631387.AxMYleU8kP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201405091810.18289@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2631387.AxMYleU8kP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 05 May 2014 15:34:29 Jiri Kosina wrote:
> On Tue, 22 Apr 2014, Dan Carpenter wrote:
> > From: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >=20
> > This patch fixes an off by one check in
> > bcm2048_set_region().
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: Send it to the correct list.  Re-work the changelog.
> >=20
> > This patch has been floating around for four months but
> > Pavel and Pali are knuckle-heads and don't know how to use
> > get_maintainer.pl so they never send it to linux-media.
> >=20
> > Also Pali doesn't give reporter credit and Pavel steals
> > authorship credit.
> >=20
> > Also when you try explain to them about how to send patches
> > correctly they complain that they have been trying but it
> > is too much work so now I have to do it.  During the past
> > four months thousands of other people have been able to
> > send patches in the correct format to the correct list but
> > it is too difficult for Pavel and Pali...  *sigh*.
>=20
> Seems like it's not in linux-next as of today, so I am taking
> it now. Thanks,

I still do not see this patch in torvalds branch... So what is=20
needed to include this security buffer overflow patch into=20
mainline & stable kernels?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2631387.AxMYleU8kP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlNs/eoACgkQi/DJPQPkQ1LyvwCfW2bD3mNnIkopKovNtmu8Ln/w
t+YAn3hyS/hRtclc3eHqR1KaAg0DrT+4
=26FT
-----END PGP SIGNATURE-----

--nextPart2631387.AxMYleU8kP--
