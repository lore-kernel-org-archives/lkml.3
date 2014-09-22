Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaIVTo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:44:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:36827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIVToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,573,1406617200"; 
   d="asc'?scan'208";a="577114388"
Message-ID: <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 12:44:17 -0700
In-Reply-To: <20140922192152.GD4709@pd.tnic>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20140922153355.GB4510@pd.tnic>
	 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
	 <20140922184049.GB4709@pd.tnic>
	 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
	 <20140922192152.GD4709@pd.tnic>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V77hLcet7amYoKTqNwO1"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V77hLcet7amYoKTqNwO1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-22 at 21:21 +0200, Borislav Petkov wrote:
> On Mon, Sep 22, 2014 at 06:59:23PM +0000, Rustad, Mark D wrote:
> > It is helpful for using the warnings to look for problems or even
> just risks.
>=20
> That's what W=3D builds are for.
>=20
> > Right now the number of warnings generated when using W=3D2 simply
> tells
> > people to never use W=3D2.
>=20
> I showed you how to use W=3D2 and 3 for that matter - pipe the output
> into
> a file and grep away.
>=20

Not sure you showed us, since that is how everyone has had to do to
actual find W=3D builds useful.  Just because that is how we HAVE to do it
now, does not make it the best way.  Here is a thought, we don't we fix
the potential issues, so that W=3D builds do not generate over 100,000
errors/warnings.

Mark did this approach because it would either spur the conversation
that this is a good idea OR let's fix the root problem.  Instead it
sounds like your response is "life sucks, get over it" and put your head
back in the sand to ignore the problem.

> > That severely limits the value of a useful tool. A checkpatch
> warning
> > doesn't mean to never do that, just that it needs a critical look
> and
> > justification. That is certainly true of every patch I made that
> uses
> > those macros.
>=20
> Sorry, if you need to shut up the compiler by adding code with the
> sole
> purpose to not issue a warning for otherwise perfectly fine code, then
> something's wrong with the whole endeavor in the first place.
>=20
> There's a reason W=3D warnings are disabled in the default build.



--=-V77hLcet7amYoKTqNwO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUIHwRAAoJEOVv75VaS+3ORowP/i/4vQMARJxZikvYuDka9ZuO
EdhJTQ8KBV8X0sw6Duse4Kpx8Kgp034tct7pVIYrliZ96J76m3QwRTGs2TX9kbuW
mhYjtQRAhFzPe+eKRGxooWnazv6x5vmikGUN0z5Ypzn5CYNeAXYdAfwx+zIDhgiB
mGitN0NTKqnrF9BVKZ59d0FciR8Rj0jYjprGZ7e+kEO0BsQceAAIWs7Jzg1mg4Gs
siphna3tBzOmXdxWuFCvUzjpPdFaax82tr5Hev3WdGIEa4fNiNxi4T8ZBJpzrLmd
8SRgW6QWyyyfq3TrPrM2B7ml8HeXKctjj6+mAea2MxnbtBp9IKM6xP9HU6Lh7UTq
hhPRMUyxvDua8PCPQF2BsYfglxjis2/2wuGce+GzRIwc9k1WqlFVrXbkOf6as8ZZ
7FnunUltpID3SDr1J+vPvOIJn5FSzYx2LrDPSlAza+XCKBkvQjqoCBaBp9kQINaw
3Tq6OIP8WJMk3fRHIzMgsLHn77CucC/UPxNDGoTcOK7eH8Eb1zgPFTFDHZKxM732
R03iDc2m4Cr3IHKmlt/+ijZHM4YffKzqkeRXtbGA/MBRfsdg+Ye1gVFclBnYoq4+
EZ945Ag8itlaSlj4Rj1yGIDtHZQmU/YqkrIItEZrU5cCnTw/9RtucWCs5C/zlvsZ
6/UvIxlGWV9hGwCFuScE
=LTvi
-----END PGP SIGNATURE-----

--=-V77hLcet7amYoKTqNwO1--

