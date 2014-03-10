Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbaCJPWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:22:55 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:50380 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaCJPWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:22:54 -0400
X-Greylist: delayed 1642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2014 11:22:54 EDT
Date: Mon, 10 Mar 2014 15:55:30 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Subject: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140310145530.GA27230@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-03-10_01
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after installing new server, we've noticed weird behaviour: when box is
about to reboot, it powers off instead. This was with 3.10.33, downgrading
to 3.0.101 seems to fix this problem. I didn't have time to play with it to=
day
and box had to be shipped today, so it'll take few days before I'll have ch=
ance
for further research, but I wanted to ask whether somebody has met similar
problem and what I should check first?

The system is x86_64 centos 6, HW is supermicro x9sci-ln4f.

Any help appreciated

When I have chance to put my hands on this box again, I'll try
latest kernel and I can also do bisect, if needed.

BR

nik




--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlMd0mIACgkQ3xdJJrLygV5C5QCgiSwKV2z5PQYYDh7MqCjZxXAk
UOwAoNqFYbA+2NbT+MyBa5s7XKH8ZGf6
=aX0r
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
