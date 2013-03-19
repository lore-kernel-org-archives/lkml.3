Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab3CSHTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:19:37 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:48326 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab3CSHTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:19:35 -0400
Message-ID: <1363677512.30246.8.camel@scapa>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
From: Yves-Alexis Perez <corsac@debian.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, kexec@lists.infradead.org,
        linux-pci@vger.kernel.org
Date: Tue, 19 Mar 2013 08:18:32 +0100
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-eUMu4ZYo4BfAZvVev1OO"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eUMu4ZYo4BfAZvVev1OO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun., 2013-03-18 at 17:32 -0400, Matthew Garrett wrote:
> This patch introduces CAP_COMPROMISE_KERNEL. Holding this capability
> indicates that a process is empowered to perform tasks that may result
> in
> modification of the running kernel. While aimed at handling the
> specific
> use-case of Secure Boot, it is generalisable to any other environment
> where
> permitting userspace to modify the kernel is undesirable.

About that, did someone looked at the way securelevel(7) is handled on
OpenBSD? This is more or less the same thing, where there's a desire to
distinguish uid 0 from ring0. They're not using a capability but more a
global state which allows more or less stuff depending on the value
(securelevel=3D-1 to securelevel=3D2).

Regards,
--=20
Yves-Alexis

--=-eUMu4ZYo4BfAZvVev1OO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABCAAGBQJRSBFIAAoJEG3bU/KmdcClL0gIAJRs+oqqdMUUXqQFHoXRqSD9
LEcmDlaSh/QAkPr7TQjYMS40AGoY9j4aUzgNlCsQjXjGLYCledGtiZP2rUTWUEfV
5x3vxb9Kv9rGb8GJ6LieRwqvoDEmtOg9nUbnr7/iHtzYYmuEhWUOdki2XuQ2n85q
dO22Pd6aXtWQzFL/l91oHTOll9VB2iIwnKzUcQLpW241Be238YSB5tqD6Gc5yN4E
uFu+NN7lDxSNPYa57WJvaPXQTwMtDBJZV2RekeLp+5DEVCPDjoXQP2h/KxUTmhBj
EgvcQ8fxlKzb9UHMUDsFQHIRIpozCOuvVzIZdjZU0jSDEh9duNPmoMr4oOYIKm0=
=z+Fj
-----END PGP SIGNATURE-----

--=-eUMu4ZYo4BfAZvVev1OO--
