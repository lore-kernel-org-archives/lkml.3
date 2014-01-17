Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaAQBuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:50:21 -0500
Received: from mail.kernelconcepts.de ([212.60.202.196]:36669 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAQBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:50:18 -0500
Message-ID: <52D889E8.6070603@kernelconcepts.de>
Date: Fri, 17 Jan 2014 02:39:52 +0100
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Input: edt-ft5x06: Add DT support
References: <1389608224-9975-1-git-send-email-LW@KARO-electronics.de> <1389608224-9975-2-git-send-email-LW@KARO-electronics.de> <20140113134441.GD1273@e106331-lin.cambridge.arm.com> <20140116084943.17da0226@ipc1.ka-ro>
In-Reply-To: <20140116084943.17da0226@ipc1.ka-ro>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bcW2Isj5vRf1KifWxSwhmSWCGJVPdxpEs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bcW2Isj5vRf1KifWxSwhmSWCGJVPdxpEs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 16/01/14 08:49, Lothar Wa=C3=9Fmann wrote:
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/input/touchscreen/edt-ft5x06.=
txt
>>> @@ -0,0 +1,31 @@
>>> +* EDT FT5x06 Multiple Touch Controller
>>> +
> [...]
>>> +- threshold: allows setting the "click"-threshold in the range from =
20 to 80.
>>> +- gain: sensitivity (0..31) (lower value -> higher sensitivity)
>>> +- offset: edge compensation (0..31)
>>> +- report_rate: report rate (3..14)
>>
>> s/_/-/ on property names please. Also, it may make sense to prefix the=
se
>> as they're rather generic sounding names.
>>
>> Could you elaborate on these a litle please? What units are each of
>> these in? Why does it make sense to have them in the dt?
>>
> I just converted them from being passed via platform_data. I have no
> idea what they actually control and what units they use. I could not
> even find a manual where they are documented.
> Maybe Simon Budig can help out here as the original driver author.

The units are not specified in the datasheets available to me. I suspect
that these are some sort of counter values related to the cap sensing.

The defaults differ for the different size glasses, so I really suspect
these are basically just numbers.

The only somewhat reasonable unit is available for the report-rate: it
is specified as about <value> * 10 touch reports per second.

Bye,
        Simon

--=20
       Simon Budig                        kernel concepts GmbH
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen



--bcW2Isj5vRf1KifWxSwhmSWCGJVPdxpEs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlLYiegACgkQO2O/RXesiHAaAACcDPpmHZMki2/Pl6ZTFezHku1I
X28An1QWb+yfOogf0Dz9Bs6vzuiCH+/O
=/cPA
-----END PGP SIGNATURE-----

--bcW2Isj5vRf1KifWxSwhmSWCGJVPdxpEs--
