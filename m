Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaCTLyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:54:14 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:45935 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbaCTLyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:54:12 -0400
Message-ID: <532ACE72.6030807@kernelconcepts.de>
Date: Thu, 20 Mar 2014 12:18:10 +0100
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@karo-electronics.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] Input: edt-ft5x06: Add DT support
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de> <1395234563-11034-3-git-send-email-LW@KARO-electronics.de> <20140320093719.GB14420@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140320093719.GB14420@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xqvuqOQtrhkAKdn4NtqigxkfFc2kKccsf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xqvuqOQtrhkAKdn4NtqigxkfFc2kKccsf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20/03/14 10:37, Mark Rutland wrote:
> On Wed, Mar 19, 2014 at 01:09:20PM +0000, Lothar Wa=C3=9Fmann wrote:
>> +FocalTech EDT-FT5x06 Polytouch driver
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Required properties:
>> + - compatible:  "edt,edt-ft5x06"
>=20
> Is the 'x' part of a particular product name, or is this a class of
> devices?

The driver is intended for the EDT "polytouch" family touches, which are
based on a focaltec controller. The current line of touches uses e.g.
the ft5306 as well as the ft5406 focaltec controller.

> It's preferable to have a specific string which another similar variant=
s
> can claim compatibility with (while also additionally having a more
> specific string), as this makes it possible to handle variants more
> specially in future, target workarounds, etc.

I chose the driver name since I wanted to differentiate from other EDT
touches, which used a different controller. With hindsight it was
unfortunately confusing, since I get quite some request from people, who
also have a device based on the focaltec controllers, but with a very
different firmware (and communication protocol). They got tricked into
thinking that this driver would be suitable...

If I were to chose the name again I'd probably pick "edt-polytouch" or
something like this. But I doubt that it is useful to change the name now=
=2E

Bye,
        Simon

--=20
       Simon Budig                        kernel concepts GmbH
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen



--xqvuqOQtrhkAKdn4NtqigxkfFc2kKccsf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMqznIACgkQO2O/RXesiHCNyACbBPXVJSQzQv9OvjDS1iKaIFuE
PtgAn0MD54DVQUguggi+oifaTxLL5xYx
=QYF/
-----END PGP SIGNATURE-----

--xqvuqOQtrhkAKdn4NtqigxkfFc2kKccsf--
