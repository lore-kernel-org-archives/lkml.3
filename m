Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3EKMZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 08:25:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab3EKMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 08:25:38 -0400
Message-ID: <1368275129.8310.21.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [000/118] 3.2.45-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sat, 11 May 2013 13:25:29 +0100
In-Reply-To: <87bo8hd8m4.wl%satoru.takeuchi@gmail.com>
References: <lsq.1368193179.973009354@decadent.org.uk>
	 <87bo8hd8m4.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cPzSJABa3c518Z68glIZ"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cPzSJABa3c518Z68glIZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-05-11 at 21:05 +0900, Satoru Takeuchi wrote:
> At Fri, 10 May 2013 14:39:39 +0100,
> Ben Hutchings wrote:
> >=20
> > This is the start of the stable review cycle for the 3.2.45 release.
> > There are 118 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon May 13 12:00:00 UTC 2013.
> > Anything received after that time might be too late.
>=20
> This kernel can be built and boot without any problem.
> Building a kernel with this kernel also works fine.
>=20
>  - Build Machine: debian wheezy x86_64
>    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    memory: 8GB
>=20
>  - Test machine: debian wheezy x86_64(KVM guest on the Build Machine)
>    vCPU: x2
>    memory: 2GB
>=20
> I reviewed the following patches and it looks good to me.
[...]

Thanks.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-cPzSJABa3c518Z68glIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUY44uee/yOyVhhEJAQrpQA/9GObeUwuKvpGsCUDV/Qi4ugU69CUp9kaS
YRNgtX/PaVqjsJBMvq1riIoap/zAAbgHYssQOQiCJJbJlltPUEJ8hv4LZApitbFK
gC+oava4WZRikjcj9FAGXa0zdTSk973QO/Mn/gdU4vdOZzWT6vR+XnD2VCrUXs5U
4lX68ffPaQ7hmdkWG36TIgmxnwwSe7qd+C3IPcDJ5BbEipdjRiytTeuOOh4DbxCk
xgggDzfuVrZ9HE0ZOZTHzStYfIL5532+CpYInyT7Qn6pMj7lx2DDd2zoM9TFbcO1
Itc9A4mXASJrStD876iHaA1yYiZwGEP0eTX4EFP5mgdlUGJSUotm1wuMJr185Eq7
ccdrpXJpZOwBpcL3nDnxwyOdH2HRmyLIlZJC2RManNb5QzWdM4yvtEl3JyRpgoXv
27YwDKOA0OVNXsXrffNdz5LYphdjIyLPOeDRVss9aDbpAI2qbCJSR1irB3K7CcAf
4fG6VCNRZtrw01x2VKqvzYAuPIS6W97CSl9KGPVnjO7GFhIBsc7l2X0CS9qf2qB8
B2LX/ZOvm8zdaOZ/Juqz5cwGOLqqiFelBLtyzZZ+H8fZ6MP+K5yNitO0h7bsr5Cs
y+IvfJuKYYIUPohODQSGbcg4tj+QN+Ba9z7Ck+1J15K5gI0O369WzAZRw8M7oB7c
rGu8pnwlIbM=
=GPnQ
-----END PGP SIGNATURE-----

--=-cPzSJABa3c518Z68glIZ--
