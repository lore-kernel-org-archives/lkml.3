Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbaCEUn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:43:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19854 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbaCEUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:43:26 -0500
Date: Wed, 5 Mar 2014 15:43:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.14-rc5-tag
Message-ID: <20140305204315.GA11758@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-=
3.14-rc5-tag

which has exactly one patch for Xen ARM. It sets the dependency
to compile the kernel with MMU enabled - otherwise - the guest
won't work very well.

Here is the diff - which has to be smallest I had even sent to you:

 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

Uwe Kleine-K=F6nig (1):
      ARM: XEN depends on having a MMU


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTF4xMAAoJEFjIrFwIi8fJnG8H/R/KRidP5MinKT3ne5Y6QI2s
ubspqD1KtOs39kKjZQg5Z8m14efBdSTZh7WiV2CrPuZVAkqgR9QPFRr+4w2uQJ19
26iyuaHP2HB+YKPBwxohNWZECFAJEDqlZK0Xngh98y8aD5rRC7Xk3Wtev+IfdoQT
3WwefXKYW/+TiFiXhv86hTKnpvxk9GZ64spYoKd/Nxms4V8qv7w7KOa+CM7pVyfP
PqS/qvzmv1vdT0dDzLumh7FMWNmkvLJ6Z+PpqTNN3emcPsTLOkjORS4D1M6xE88U
cvMNDBrND8Klu6dHkGPV97dfyFq9Zn+XmK5rqpPERjBcDxm0ia0lQK/Sz0WF4bA=
=OF91
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
