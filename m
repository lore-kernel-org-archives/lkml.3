Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3CEFXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:23:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab3CEFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:23:11 -0500
Message-ID: <1362460980.3768.394.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 2/2] dmi_scan: Refactor dmi_scan_machine(),
 {smbios,dmi}_present()
From: Ben Hutchings <ben@decadent.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tmhikaru@gmail.com
Date: Tue, 05 Mar 2013 05:23:00 +0000
In-Reply-To: <20130304200930.GA27246@roll>
References: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
	 <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
	 <20130304200930.GA27246@roll>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-S1tiPWn3Oh9UQwrdlz4m"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S1tiPWn3Oh9UQwrdlz4m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 15:09 -0500, tmhikaru@gmail.com wrote:
> 	Forgive me for bothering you about this again, I know that -stable
> has a policy of only accepting patches once Linus has accepted them
> upstream, but I'm curious what's going on here. Is there something I coul=
d
> help with to move this along? I haven't seen any discussion about it sinc=
e
> Feb 16.
>=20
> 	Of course this assumes that I have not missed the patch going in...
> Tim McGrath

Andrew, did you see these dmi_scan patches?  Should I repost them?

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-S1tiPWn3Oh9UQwrdlz4m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTWBNOe/yOyVhhEJAQp2Rw/9EaEjviDoGWu7j1ffyZZTPQtqyCmbgR5c
SewoYw0LJOLpdwY5ycDiCSqKJ3lWoQoEgzy0oRIseqiQo/5AmSVd/dZ8AvJceT8S
Kemmh2JY1gEruDLt+iiD/b5fEaF942mTSPENTSrJ9NGMnlJcUZo4ES/SYP9fTOUM
1Bg0oQxp1iRnN4aKulvd4nioL+pUss/4q+ifnheUMiRXji71b5In0H9rzWfwE1ZL
nI+vG7F2wdZaiqWCvIYBOv7iJH3GL1S4ehRYlGpgF1JAAZXVdAs7OiRJoVxj1QEe
YLaiCF5UK0Pw3XUP0EGMzHbcl/xHl/OgxgE0h2l4Bqa/rCeNPn/ky61Z4Sp+k0EJ
DWidnkIyIj6o85NtyQJdhg6xYlVnMV9e5tLtOzp48HQRS8mVg3T3B/oxxEiUQrzg
Me4t8OlbpW0IXDXqVrUpKhn+T199B/ekYDIfq2u+UmgTmSBbAmO6QlxjlbMZ7k+K
rem0MtsiqJvo36nOo6cGq3og8TA/5g6GQAioB/8VON3tyZYhMkEhQtg+YujT4YQc
sUn2uWQZRbkT2ApnoUz0Efi5pDB1qtXt5yS00jb51OCx9ti14ZOI2SBejRq1AFVF
a05h1/ZcrPhsSqFF2GlyJ9DxmBl0Jdd1Q+KTOgQIB3NoJZNn0Mm34sD4BqsvjD87
/ims4/9AF98=
=AyGo
-----END PGP SIGNATURE-----

--=-S1tiPWn3Oh9UQwrdlz4m--
