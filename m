Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaCTLu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:50:58 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:45927 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaCTLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:50:55 -0400
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 07:50:52 EDT
Message-ID: <532AD571.9000907@kernelconcepts.de>
Date: Thu, 20 Mar 2014 12:48:01 +0100
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Mark Rutland <mark.rutland@arm.com>
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
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>	<1395234563-11034-3-git-send-email-LW@KARO-electronics.de>	<20140320093719.GB14420@e106331-lin.cambridge.arm.com> <20140320124055.53d469e7@ipc1.ka-ro>
In-Reply-To: <20140320124055.53d469e7@ipc1.ka-ro>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HhJx1dDCBmjH17WR1LSIjRhei6Xq3WoSw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HhJx1dDCBmjH17WR1LSIjRhei6Xq3WoSw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 20/03/14 12:40, Lothar Wa=C3=9Fmann wrote:
> The FT5x06 datasheet lists 3 variants for different panel sizes.
> I'll add distinct compatible strings for those chips, though their SW
> interface is (currently) identical:
> |Required properties:
> | - compatible:  "edt,edt-ft5206", "edt,edt-ft5x06"
> |           or:  "edt,edt-ft5306", "edt,edt-ft5x06"
> |           or:  "edt,edt-ft5406", "edt,edt-ft5x06"

Please note that the M09 variants of the polytouch family will use the
same chips, but a different sw protocol (see Patch 5/5).

I don't know anything about the naming scheme used in the device tree,
but I am not sure if the chip-ID is actually useful here.

Bye,
        Simon

--=20
       Simon Budig                        kernel concepts GmbH
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen



--HhJx1dDCBmjH17WR1LSIjRhei6Xq3WoSw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMq1XEACgkQO2O/RXesiHBYegCdEhyb5e7+T45ijRYorB0CJ2U/
yCYAn3VVGHGLx/YQFQ/7csC/vGZzDxqa
=pegi
-----END PGP SIGNATURE-----

--HhJx1dDCBmjH17WR1LSIjRhei6Xq3WoSw--
