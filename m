Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbaCaMLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:11:52 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:46931 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaCaMLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:11:50 -0400
Date: Mon, 31 Mar 2014 14:11:39 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140331121139.GZ3339@pcnci.linuxbox.cz>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CnCWQepWw43huI++"
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-03-31_02
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CnCWQepWw43huI++
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

sure! count me in.

n.


On Mon, Mar 31, 2014 at 12:05:20PM +0000, Winkler, Tomas wrote:
>=20
> >=20
> > Hi Tomas,
> >=20
> > > If this is a server platform can you please try this patch
> > https://lkml.org/lkml/2014/3/25/396
> >=20
> > tried 3.10.35 with Your patch and now I can see following in dmesg:
> >=20
> > [  +0.000290] mei_me 0000:00:16.0: Device doesn't have valid ME Interfa=
ce
> > [  +0.007656] mei_me 0000:00:16.0: initialization failed.
> >=20
> > now reboot works as expected. Once this hits ustream (if it hasn't alre=
ady),
> > this could go to -stable, do You agree?
> >=20
> > thanks!
> >=20
> I definitely asked for adding it to stable. Would you wish to add you tes=
ted-by to the patch?.=20
> Tomas
>=20
>=20

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

--CnCWQepWw43huI++
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlM5W3sACgkQ3xdJJrLygV7zGACgyRc9mwur7hfUHB8mLPT44k9M
hwsAoLdxU1osXpEOfp3Ooasmoela4Pse
=/HgP
-----END PGP SIGNATURE-----

--CnCWQepWw43huI++--
