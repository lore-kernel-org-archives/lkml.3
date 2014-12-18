Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaLRJDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:03:36 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:50972 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaLRJDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:03:08 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
In-Reply-To: Your message of "Wed, 17 Dec 2014 18:20:21 +0000."
             <CABz95_C1UzbRMgjDKcrdRzr2VGvAwmvWBRrP2116k3CQx+2sRg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-4-git-send-email-pali.rohar@gmail.com> <201412101251.30610@pali> <201412171854.00902@pali>
            <CABz95_C1UzbRMgjDKcrdRzr2VGvAwmvWBRrP2116k3CQx+2sRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418893357_3430P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 04:02:37 -0500
Message-ID: <17858.1418893357@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418893357_3430P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Dec 2014 18:20:21 +0000, Steven Honeyman said:
> On 17 December 2014 at 17:54, Pali Roh=E1r <pali.rohar=40gmail.com> wro=
te:

> >> > Dell Latitude E6540

> >> Can somebody else with dell laptops test this patch series?
> >
> > Steven Honeyman, can you test this autodetection patch on your
> > Latitude E6540?

I'm not Steven, but I have a E6530.  linux-next 20141208
reports fan wonkyness in 'sensors':

i8k-virtual-0
Adapter: Virtual device
fan2:        83070 RPM

I'll have to see if the patch series fixes that.

--==_Exmh_1418893357_3430P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJKYLQdmEQWDXROgAQJNOA//fJHDaYuvj+kgTxXctIPJBkNCgXIx43li
8JW5btNOLNAhYjm6Wi/BGcsDVjSbyJyCQ9CZ5IUp7MEOtgkhPMC6Pt4OL5MyJDrn
sNBxI2JaGFW2ClbaUZX82XKo5REFCJytu8ha7J22wykvvOoCKwllQB8WL4rsI5Ro
k/BrcO7AgYjnb6W2C9pWXftSoFIiA/Rr+yEKsuUIaN4SEHm9DMDFkVc4JCPJpGKL
zENtGkDipBFFcpIrg/Mq4Dj3x7rivwFq3pIj7qm8HX+fI5ewNUO4WKY3aM24eAwH
2xJHoNaYl6cNYkhudlJv0gUWcHuH0bmcH2KGzJqLcxSCZGdbUio4H/wgvAA7lmSh
JaY5DMEZGKkktLm31lVvqWzC/eKYUGTWFdFLoYP3V/F7SCL9RP47i523LqpIrg8Y
Fz5g70NxobsGyMC2hBS86tBZSup//9JLqO6tbDQvipvYqWzvANTlA128HOvmWzV0
AmJ6Dcbziv5UEVVz7OHovFMuWq2Pjcc+sTGBDKGVq0LZzSL4NAvNNuQhrJ18947m
RI7CN9GQKkBITaZCmjzb+kstlSuspBA8mvRV1ckRTqyKxqVDc7KMPA/ckaqfYsob
/qSBKJtonpu4btHxz1IWKlu/zFQPxXUfs54LfR6rw8virt+Hl2QAUHyhfLj6XbEb
gkekh73wDZc=
=WLlw
-----END PGP SIGNATURE-----

--==_Exmh_1418893357_3430P--
