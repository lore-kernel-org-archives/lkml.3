Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab3BHBLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:11:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47943 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759559Ab3BHBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:11:44 -0500
Message-ID: <1360285890.5374.76.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.38
From: Ben Hutchings <ben@decadent.org.uk>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2013 01:11:30 +0000
In-Reply-To: <20130207173630.GA8355@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
	 <20130207173630.GA8355@roll>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GWRW7NjMGIe27SEBcfrl"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GWRW7NjMGIe27SEBcfrl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-02-07 at 12:36 -0500, tmhikaru@gmail.com wrote:
> 	Hmm. I'm not sure what's going on here but ever since I upgraded to
> this kernel my CPU use has always been at 100% - various apps (top, pidst=
at,
> conky) give different reasons for this, conky&pidstat claims things like
> X/the most active X application are cpu hogging, while top seems to think
> the majority of cpu use is being done by 'sys' - the interesting thing
> though is that my loadaverage is staying very close to zero.
>=20
> 	I know that this is far from a useful bug report, but to be honest I
> don't even know where to begin checking, so I'll start a git bisect of
> 3.2.37 vs 3.2.38 tonight and see what happens.

There weren't any scheduler changes in 3.2.38 so I can't make any better
suggestion than to do that bisection.

Ben.

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-GWRW7NjMGIe27SEBcfrl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURRQwue/yOyVhhEJAQqTSw//UqwqBwMDFTU6N+miACmH2HZGLtmEDDpC
xJw9/iQp7iYvCnyzSYwUW28zQ3cE3MOZzhJkWNPJjdOamt9+dNJ3TA97JPncjJWu
gue+qsag7iR/BPhUYoyjBubq4NZo+7Yz/SlZ9GGZW8SOcrrwIFLjiLRT9AzOFcz7
8S5htduUuJylZ/C+FYOofnloiggZIuyIVuiPams8y0VYtFn0fy7p+AEyEn0OpjEJ
hTcslkpM0yjMlSYoShXueE6rGc5Z3OmJgCh2MgM7QZhkE+GcBxONGs2W35F0WsZo
+xqnhSGOKeAMX5+35GGfwYMUcCUeebzAPKeHOzqxXN7R0EnRnejPfP/FhNzRPVWC
y0Bmq9LXOAt5y7or3qS3gomly1+CU+CXzjW9vH5TyHSPEU9mqEkaFq7wiAi6Zeg/
4Mk0yyGv4WjEohLjrrcMd8WTkG4ApCqTl5kEGNeGbnE0463na468Vm4SGtZ50foK
JxgKkXGNVaO5qrfpHbZDOD4+6UtAzt5S3SlfwcaZav4ObAuiS+qVyVSxQ4EdyUFq
V1EHIBDB6qdlIZJVN+CmluvSHHJfDCj0HvmJLvuZw4WkXKv+04i4yUaGUAR7TtIy
gb8tKDg/ZyfxVzxCZgmJrrD4w9hOpO1QApFgAYWoZn90lDfk0AiRUru0Wpd6z27p
TIb7wNVl8d8=
=SVvT
-----END PGP SIGNATURE-----

--=-GWRW7NjMGIe27SEBcfrl--
