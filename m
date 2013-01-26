Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3AZALN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:11:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38847 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319Ab3AZALL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:11:11 -0500
Message-ID: <1359159055.3146.9.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Bug#695182: [PATCH] Subtract min_free_kbytes from dirtyable
 memory
From: Ben Hutchings <ben@decadent.org.uk>
To: paul.szabo@sydney.edu.au
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        minchan@kernel.org
Date: Sat, 26 Jan 2013 00:10:55 +0000
In-Reply-To: <201301252349.r0PNnFYF024399@como.maths.usyd.edu.au>
References: <201301252349.r0PNnFYF024399@como.maths.usyd.edu.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-U4D6W87p2oSthp7A5dG6"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 78.32.9.209
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U4D6W87p2oSthp7A5dG6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-01-26 at 10:49 +1100, paul.szabo@sydney.edu.au wrote:
> Dear Ben,
>=20
> > If you can identify where it was fixed then ...
>=20
> Sorry I cannot do that. I have no idea where kernel changelogs are kept.
>=20
> I am happy to do some work. Please do not call me lazy.

The changelogs are in git repositories.  But the mm maintainers are
probably much better placed to identify which was the upstream fix.

Ben.

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-U4D6W87p2oSthp7A5dG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQMfD+e/yOyVhhEJAQoCjRAApmuWAB1UAauxqmKbDWWRCvFIuDQldoAb
UTfvrNAKBmxiJhZCrL5MuKQ2JcFfB3O0FRf+WlFECQPmLoDkMGsdurp16BJAiMeZ
XE2NgIKi81Q8sH6CpM3zcAFiz9dMMSbTr33YGJJ5HCXXw1VvvwnAk4oozRDakXSb
eyIYYZdyzpVzutdB3K3gtb42i5YnxGlu47e0hJcQWDrQOIskBi+kvKAOVLaTJSA4
MqOV5X5wcofU6l4wqqaPItsFXYjwlkRARNndhIXyUJ4FizNyYv7MRWPv2jGfBIxv
UKrpxEPHa1RWTMHuFZw//Ngem4qD50Toin7iAE1zrD4MYOybHMPXHRqBJ9WOAZRo
MD6+9i6wE/q/CAun+zNWUMFnWc7Tj2djtBL4//BDm79mO7x3fUnvZxMGEwFynkLH
bJzYAQpNbodwSMadPr5RWiJ+JhMgsfIUcDUYDxQ0Wdn3ttDslIoWfnoV8OlTamid
LccOghlf8sf7Uc5Jeq/joBLwL++zGZBfg/HSw7ElgwaVJAW634zwme4bkN1W7WB7
iSmF3QNHEev/71KWOh8ViHiehdY/APGZHj3+1aMlxZXCxAIyW/1Mxh7lHU5582zN
wkdJ/TIdW6titgYP9CxAgeAY0yOmmdzGZniesG1XTLNKKwxFe8sC+SIIX4iyyvcu
Qr+UP2MxDmY=
=LTtq
-----END PGP SIGNATURE-----

--=-U4D6W87p2oSthp7A5dG6--
