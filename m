Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3KDDpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:45:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab3KDDpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:45:09 -0500
Message-ID: <1383536688.2764.59.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of
 get_burstcount (fix CID: 986658)
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Mon, 04 Nov 2013 03:44:48 +0000
In-Reply-To: <20131030030747.GA12179@kroah.com>
References: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de>
	 <20131030000618.GA5241@kroah.com> <201310300142.11716.PeterHuewe@gmx.de>
	 <20131030030747.GA12179@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3vozOI8/f3p+0Ya4kGo7"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.202
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3vozOI8/f3p+0Ya4kGo7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-10-29 at 20:07 -0700, Greg KH wrote:
> On Wed, Oct 30, 2013 at 01:42:11AM +0100, Peter H=C3=BCwe wrote:
> > Hi Greg,
> > > >=20
> > > > CID: 986658
> > > What is this field for?
> >=20
> > That's the scan id in the coverity database.
> > If you think that's just noise I can leave it out.
>=20
> It's noise as not everyone can see it or make anything out of it, so
> please don't include it.

I think it's useful information for people who became aware of the bug
via Coverity.  It's not so different from a CVE ID, or a reference to
one of the various enterprise distro bug trackers where bug reports
often aren't public.

Obviously this cannot be a substitute for explaining the bug properly in
the commit message.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-3vozOI8/f3p+0Ya4kGo7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUncYMOe/yOyVhhEJAQq1DRAAq5XyNKY7AXYiy/24viTXkxIbHhOSctrN
SVgEwvGEgdMGq7ZCvRdOAogtfv4Ruv67bI35d+UKfHA+hETbcPNgELTmuqbFJpxx
R2aPKfglZa8/84Xw0mmQ17ruB4poHs9gzNT2cYmPy420GLiv4Xjr3DfC/Bxh1B+E
9P4rAuVpmTV7ZLlNkNB7Uhph538+in5U0CeeiW0KgStBBcyssyuZdRV3cHR1qWhA
jus+CiejLCBMRD/KBvLC12fogY5PJ2n8iYHh+evFLLIhKcASWUDi12nOoFXywucB
0h/Bya5PAX/RT6Fk7fw42hkr5CnZLDMHpzIqrbu+UICI71fDPpfhB69mLoNKXHVn
wIGUibM07OXihXqXS6c8AgvpCIpqtugUplEsQb8HxATGTYoLBL9FdTey3HySkJsk
p6k56SkSukiURJ2RqBRyMtFw2tSlDyTONXq+tMHjYupsO+0wY9tGT7Y6+Op8AAk0
ErOw7F+mkl1K27E2ucj/rTzmI3SJ5hZ/3cw3IqcjAQGsi/iNRHeBqO/QzalxcutX
2M44r5kuw5mTfXFVvZwcuNHIUCAeSt8kEkmwQiRTfb8LbaqX+8qhmGADGW41VTg4
xmxXtO2n/Aauo8V4o/UIHSN7k/sMSf9IIu7ewi+PZPzcfG8ByuVOmH27+Bh86jip
VzcfFQdUAi4=
=lXfV
-----END PGP SIGNATURE-----

--=-3vozOI8/f3p+0Ya4kGo7--
