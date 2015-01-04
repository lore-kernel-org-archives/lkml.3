Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbbADXf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 18:35:57 -0500
Received: from ozlabs.org ([103.22.144.67]:37493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbbADXfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 18:35:55 -0500
Date: Mon, 5 Jan 2015 10:35:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: bad commit in the luto-misc tree
Message-ID: <20150105103547.40ef87fd@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QjoA+God3wI5x42Qe2XSAaJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QjoA+God3wI5x42Qe2XSAaJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

I noticed commit 7d032e5b1042 ("[TEST ONLY] Force RCU NMI nesting") has
no Signed-off-by ... I understand that this is for testing, but that
is *not* what linux-next is really for.  Especially given that that
commit is x86 only, it should be used for unit testing. not a wider
audience like this.

I am also not sure about 9f29ed3365cd ("[DO NOT APPLY] rcu: Make
rcu_nmi_enter() handle nesting") ...  (it is, in particular, not
Signed-off-by the committer, you).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/QjoA+God3wI5x42Qe2XSAaJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUqc5YAAoJEMDTa8Ir7ZwV5PEP/1yIvM6RS5yimfZ3WNr7XpNQ
o3ep9ci6f6FNeObTGPP57Hjk9OvSyj4pmSXxJO8sanjUUfadISbfY8zZggjXK80q
Uy8EHL+EFkU+0TnmXhiOcmoVPXnJ2DYWb2wQAzd1CNz5RKcCXabI43q2GCbrjT2T
XtWlYEwpdiO/MdjeyyijESoVhsH71Dttn8H5pepZB24H2n8IX7jrqVkbAkO6li/Q
rpNECF7IOB5+MKgLLb+D70Dv2smfm5BIpED3mugpDletR0RxBvOxfLnZ/0HzeRX/
lCe8rBE+dit5wyV3SF4NovfgAlvhtMbqejyY7qFfj/STQyWaFX55KDZPan0FWabE
9gUeZJIZtmCjihGhTUgK+t4ZJV5+89aC6XdYMlUmWYGTCTQdooH6riNw7dmcmdVU
aWkqlzKl4Osr65Ev/ScT/R1CqlJmbDJa7CllLnzJu0zxVR+EFAWWsp1JOWN3v2lu
xuhnOEpEjvqTM2ZyDIkkKgkXTJu8uBeK0Afra4lDOkA+AsQy00EPwoHHHxnqm3hB
o4z5yOYFE51xLMU6a3WYrQEPyu2PCRGZ+MBjodx6e3jLgM/g8dFrjMOBx74Ml1XV
6w5CDDhke/A9U+awb7pYp0i2Y5m9qLubzXpHE4yEym76DoKJvEPoB+MGJuXRRafx
kh4ISf9yjHYyIGt1hMvS
=AAKt
-----END PGP SIGNATURE-----

--Sig_/QjoA+God3wI5x42Qe2XSAaJ--
