Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaJCCXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:23:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:54678 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbaJCCXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:23:44 -0400
Date: Fri, 3 Oct 2014 04:23:39 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: remove deprecated IRQF_DISABLED
Message-ID: <20141003022338.GA6361@earth.universe>
References: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 01, 2014 at 10:28:55PM +0200, Michael Opdenacker wrote:
> Remove the use of the IRQF_DISABLED flag
> from drivers/hsi/clients/nokia-modem.c
>=20
> It's a NOOP since 2.6.35 and it will be removed soon.
>=20
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next&id=3Da26a42508157bc9fda89e3b1d64e47b9e4b55c30

-- Sebastian

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJULgiqAAoJENju1/PIO/qaRBsP/jrl+02hrQE71BnKoIoQANrT
2Ffk2mSguUecJVIm9kKAB2u+z3MTlLRZmWWugpeSoSc6nZY6xp4H7ol2fRgxfUjx
ILrh9zwXmSxmD5J8XfGOzQavRXYh1an75awRXPeiLiL1O38rDZo06mTCs56ZogG8
kNWZP9BHSpsz9bzCZasVnnW8IBJg4PANnkL6LCZRYwKLHURkNS0xL/YB33wW43WT
2a4XUJNMohK6wXFtm+b37+enPZgsQVXP7CC+hVeqfZ6uAtnARMQYYfLRZ4LdkQ30
yXHWw9jmmBxaaWOUMN6vxqTtwc0O/aT2fqmHBBOJvnDBHl3sEZZMgRcPtVRfeYe7
2ovKPU07KytRcdO5uAM3VvgWCoQWq+GVbs5B1QNe8J0jWchSXtWW7cCowBcBb+MN
EkrwOfeO2Zqk4a3Ljmpntm06tdUcINmtyITzcAz+a6PK0+/HxKtLtI4QCyk73z63
FEiK0Le2BigdK8gC7xSoObjvrgu/FTec/IvO3YrjYdA3JGui2kljYKerDzFdcAw4
gaX7NzcgTC9IjmYXnc4NOgTqLt0iz7MSTLGAJsA7BDcu+VI9lFez+8D7l/ufHYKA
diChSRilGzSHylMFTAj5LFFAaTdUJcRVZPruEFI1c1Lfqyfr3qKqUUNmdaiogmly
yAW4EZMJ5R/I70rHsrih
=z7I0
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
