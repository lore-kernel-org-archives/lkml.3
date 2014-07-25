Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaGZABT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:01:19 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:44941 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaGZABS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:01:18 -0400
X-Greylist: delayed 2525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 20:01:17 EDT
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.16-rc6 Bug with Sound?
In-Reply-To: Your message of "Fri, 25 Jul 2014 18:57:33 -0400."
             <CAPDOMVhgNzCMAr_XxVPec=p_hBP4piKLVzw_1O+tUFOxNzzQ0g@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAPDOMVhgNzCMAr_XxVPec=p_hBP4piKLVzw_1O+tUFOxNzzQ0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1406330345_2052P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jul 2014 19:19:05 -0400
Message-ID: <27687.1406330345@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1406330345_2052P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Jul 2014 18:57:33 -0400, Nick Krause said:

> Hey guys after compiling and running the kernel in the subject line I
> get no sound
> and a message of no sound codec could be found. I am new so this may be
> a  missed needed config for sound or it's a bug. I am attaching my config
> to help you guys out :).

You want to *really* be helpful, you could tell us what lspci/lsusb/etc
say your sound card is, so we can tell you which driver you forgot to
include in your kernel config. :)



--==_Exmh_1406330345_2052P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU9Ll6QdmEQWDXROgAQIDbhAAmPZtbP5gPsadOvs310JeD9dPCQzAKQVV
R1fxFO3NsELZaGWpISkwFgXfbAi+1Drmc3PNsGLyFZ1DhpW45wwASKW/qszHIe/u
d4qz71mj2ol6rFugdc4T0Dl3xZHjMinnsiWzz6ulPf7n5LOnH7ZuYMmdOGhu/eQk
+mhusEd1j++o6QmQdaxdR5TKlbMTlRUXgExiMfFKm3j1oXL5nrT1g6ST0R97WPko
GIBKSqs3DPLpTd4okIJSfaKTLElpRM7gE3wtcktv0JTfRXiEFG7th4ibJOU5rLe6
RhrLvQ8g9hpCkkxVBNaAcFol2k5AaLFiSoIGxhiiyoLk23gyKYybj23DxtaT/bT+
iG+vrwipuP4ZTTlcOiI0dzInE92Iu5I6ecyvAbYf+oX5KyHLwoiEbxz7vz4tk43W
jNiINCE+MRHRmrRuJC8ug3uNT7G3ExSTzilVS5VoN0n1E9pMwT3HUD3tIVm9C7JR
48THQ5pJBXnFabRyZ2FJRXVNPFnkWCZksjF+AS83Yrx0PfSkjyPhcmS8D4APu0Oq
FRotj1ca1iSm8B0cti7YBoajcbuKOiKwVnWwLo5tefAFbHy0n7rQR347T5icG513
T29svgszOqlRfTM8EyHBgV2bG3c171MwMO8a+ZLIbRSIks3s0AJ9HfHsZUa13Mb3
nsj9kTGIwIs=
=1MEU
-----END PGP SIGNATURE-----

--==_Exmh_1406330345_2052P--
