Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934843AbaGYRDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:03:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:39016 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbaGYRDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:03:33 -0400
Date: Fri, 25 Jul 2014 19:03:27 +0200
From: Sebastian Reichel <sre@kernel.org>
To: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: net, phonet, rcu: rcu hang within gprs_attach
Message-ID: <20140725170327.GA4024@earth.universe>
References: <53D1865F.7040604@oracle.com>
 <8427f661d1aa5707ee18596e812fd3c5@roundcube.remlab.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <8427f661d1aa5707ee18596e812fd3c5@roundcube.remlab.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 25, 2014 at 10:43:46AM +0300, R=E9mi Denis-Courmont wrote:
> Maybe Phonet should be dropped though. As much as I like to have my name =
in
> MAINTAINERS, I have not heard of any remaining users for up-to-date kernel
> versions. And with Broadcom shutting down what was Nokia Wireless Modems,=
 I
> doubt we will see new users ever.

The Nokia N900 modem uses phonet and is supported in the mainline
kernel since 3.16. See drivers/hsi/clients/ssi_protocol.c

-- Sebastian

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT0o3fAAoJENju1/PIO/qasG8QAIDapWz/6Ws51JmNEqKe3iND
an7X/hzcUDUKvVvVtKAUM042iJ/euFkeisdc1QcI2MtvurF+tJlRh0zc3tIG3mmQ
xcjsxWepO17DvjbB499/+a/lYSfYXae7/wPsXDQuGipLfI79Zg5MUPEUvzuGlBnK
ASMVNc5C5BIRHfQ2w5LSiLnvwgB0xFhOvVCb1YUofcNui8JNFI3Fd1J0FfSdG0RQ
fFADTde4vn7lTPCNj1ltEPEM177hZW1HLpMENugi/sLF7wTixEtusVOrT15n4yVL
oNb3SzaL1dW2+kFQBsfDygsEJR8DHb9n+3Rx8aIGcbKvi2yXJL14Pr+capQUC3K0
71jlcQSE4nne6vVucPQtNjynRRcyyU192kkMkiT+NbEtXMdE6ZN0kCffENcrrJ08
K3Uhi0iyqSjzUj/LuHzh4/kp9MiGpiLAWP7m8Kc/47aovFVZAYMxsMKQpxaX4ooY
f0j0Qzgpp4yHx4ACc0BLZZwkEKp9hmwKEZBgNYSV8g9gU7GUXP6j5CmcNBTYiQOj
+Lp9p71dFQ6VEtGotrtg5hb0rk6x99kkYEWeT22ntI1fnyFzTRjm8l6dC1bBnj9j
f0zGvpa2v9dXPsxxTkjoHFfDte7lRfwhigA70HQ69Aeyu8zusBf3le5TSnByL5Eg
X5RoJ5qKxc+FYelhrT1S
=Il4e
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
