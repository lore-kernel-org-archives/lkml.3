Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3FGGAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:00:30 -0400
Received: from linuxdingsda.de ([87.106.20.67]:58001 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737Ab3FGGA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:00:29 -0400
Message-ID: <51B176FB.9070509@linuxdingsda.de>
Date: Fri, 07 Jun 2013 08:00:27 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?windows-1252?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Increase the number of USB to serial devices we
 can support at once
References: <20130606173103.GA1812@kroah.com>
In-Reply-To: <20130606173103.GA1812@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TQBOOKKROHDNBWPSWVTH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TQBOOKKROHDNBWPSWVTH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hey Greg,

I patched it two times to be safe, but I can't seem to get it to compile.=


  CC      drivers/usb/serial/console.o
drivers/usb/serial/console.c: In function =91usb_console_setup=92:
drivers/usb/serial/console.c:111:2: error: implicit declaration of
function =91usb_serial_get_by_index=92 [-Werror=3Dimplicit-function-decla=
ration]
drivers/usb/serial/console.c:111:9: warning: assignment makes pointer
from integer without a cast [enabled by default]
drivers/usb/serial/console.c:122:40: error: =91struct usb_serial=92 has n=
o
member named =91minor=92
cc1: some warnings being treated as errors
make[4]: *** [drivers/usb/serial/console.o] Error 1
make[3]: *** [drivers/usb/serial] Error 2
make[2]: *** [drivers/usb] Error 2
make[1]: *** [drivers] Error 2
make[1]: Leaving directory `/root/usb.git'
make: *** [debian/stamp/build/kernel] Error 2

thanks

Tobias


------enig2TQBOOKKROHDNBWPSWVTH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGxdvsACgkQ2CMMiSvcNgU0nACgy7956EHf/L3JFaT0wzfrj4FS
dH8An3rh2yGqYhhA/bWBL7tT85HtrMjb
=Q09a
-----END PGP SIGNATURE-----

------enig2TQBOOKKROHDNBWPSWVTH--
