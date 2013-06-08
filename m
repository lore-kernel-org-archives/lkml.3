Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3FHJOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 05:14:52 -0400
Received: from linuxdingsda.de ([87.106.20.67]:42506 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751780Ab3FHJOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 05:14:51 -0400
Message-ID: <51B2F607.3020204@linuxdingsda.de>
Date: Sat, 08 Jun 2013 11:14:47 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Increase the number of USB to serial devices we
 can support at once
References: <20130606173103.GA1812@kroah.com> <51B176FB.9070509@linuxdingsda.de> <51B1AE2F.3040405@linuxdingsda.de> <20130607172535.GB29371@kroah.com>
In-Reply-To: <20130607172535.GB29371@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XWDKSKEWLDXAAKWOBHFP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XWDKSKEWLDXAAKWOBHFP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/07/2013 07:25 PM, Greg KH wrote:
> On Fri, Jun 07, 2013 at 11:55:59AM +0200, Tobias Winter wrote:
>> On 06/07/2013 08:00 AM, Tobias Winter wrote:
>>>   CC      drivers/usb/serial/console.o
>>> drivers/usb/serial/console.c: In function =E2=80=98usb_console_setup=E2=
=80=99:
>>> drivers/usb/serial/console.c:111:2: error: implicit declaration of
>>> function =E2=80=98usb_serial_get_by_index=E2=80=99 [-Werror=3Dimplici=
t-function-declaration]
>>> drivers/usb/serial/console.c:111:9: warning: assignment makes pointer=

>>> from integer without a cast [enabled by default]
>>> drivers/usb/serial/console.c:122:40: error: =E2=80=98struct usb_seria=
l=E2=80=99 has no
>>> member named =E2=80=98minor=E2=80=99
>>> cc1: some warnings being treated as errors
>>> make[4]: *** [drivers/usb/serial/console.o] Error 1
>>> make[3]: *** [drivers/usb/serial] Error 2
>>> make[2]: *** [drivers/usb] Error 2
>>> make[1]: *** [drivers] Error 2
>>> make[1]: Leaving directory `/root/usb.git'
>>> make: *** [debian/stamp/build/kernel] Error 2
>>
>> Despite that broken driver, I just gave it a try and the patchset work=
s
>> as expected.
>=20
> Thanks for testing, I forgot to update the console code, as no one sane=

> every runs it :)
>=20
> I'll go fix that up now...
I just retested it and it works as expected.

Thanks, Greg!

Tobias


------enig2XWDKSKEWLDXAAKWOBHFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGy9gcACgkQ2CMMiSvcNgXr8gCfaaEcZ+JY1WqoXyzYqgbdwmLW
9NoAoJeOgzkXQVslqOOafe0qUdW4B9VQ
=9ncW
-----END PGP SIGNATURE-----

------enig2XWDKSKEWLDXAAKWOBHFP--
