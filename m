Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaC2MQB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 08:16:01 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:55204 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbaC2MQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 08:16:00 -0400
Date: Sat, 29 Mar 2014 13:15:50 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: tomas.winkler@intel.com
Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140329121550.GA5878@nik-comp.linuxbox.cz>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <20140310145530.GA27230@pcnci.linuxbox.cz>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-03-29_01
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(CC Tomas Winkler)

So finally I got some time to look deeper into this, and the problem
might not be regression after all.. It is caused by mei_me module,
blacklisting it "fixes it" for me.

So for me it's kinda of solution, although I guess MEI related people
might be interested in it..

If I could be of any help, please let me know - at least I've got hardware
on which I can reproduce the problem..

BR

nik


On Mon, Mar 10, 2014 at 03:55:30PM +0100, Nikola Ciprich wrote:
> Hi,
>=20
> after installing new server, we've noticed weird behaviour: when box is
> about to reboot, it powers off instead. This was with 3.10.33, downgrading
> to 3.0.101 seems to fix this problem. I didn't have time to play with it =
today
> and box had to be shipped today, so it'll take few days before I'll have =
chance
> for further research, but I wanted to ask whether somebody has met similar
> problem and what I should check first?
>=20
> The system is x86_64 centos 6, HW is supermicro x9sci-ln4f.
>=20
> Any help appreciated
>=20
> When I have chance to put my hands on this box again, I'll try
> latest kernel and I can also do bisect, if needed.
>=20
> BR
>=20
> nik
>=20
>=20
>=20
>=20
> --=20
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28.rijna 168, 709 00 Ostrava
>=20
> tel.:   +420 591 166 214
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
> www.linuxbox.cz
>=20
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------



--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlM2uXYACgkQ3xdJJrLygV4O5wCdH83//KIHtE0r3EIhUcOhtLzk
Y04AniuL1h+7ge/D48aOd610kP266x9a
=/Jez
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
