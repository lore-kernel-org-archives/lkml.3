Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3JIJCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:02:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37131 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab3JIJCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:02:41 -0400
Message-ID: <52551BAB.40805@ti.com>
Date: Wed, 9 Oct 2013 12:02:35 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <monstr@monstr.eu>
CC: Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com> <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com> <5236D4BD.9050707@ti.com> <5236DE60.3020901@monstr.eu> <5236DEBF.7070003@ti.com> <52496921.9080603@monstr.eu>
In-Reply-To: <52496921.9080603@monstr.eu>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8LQfKtohaGKeDF1R6SOJvp9emBl0oe3Dh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8LQfKtohaGKeDF1R6SOJvp9emBl0oe3Dh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 30/09/13 15:05, Michal Simek wrote:
> Hi Tomi,
>=20
> On 09/16/2013 12:34 PM, Tomi Valkeinen wrote:
>> On 16/09/13 13:33, Michal Simek wrote:
>>> On 09/16/2013 11:51 AM, Tomi Valkeinen wrote:
>>>> On 12/09/13 08:54, Michal Simek wrote:
>>>>
>>>>> @@ -394,16 +382,12 @@ static int xilinxfb_release(struct device *de=
v)
>>>>>  	/* Turn off the display */
>>>>>  	xilinx_fb_out32(drvdata, REG_CTRL, 0);
>>>>>
>>>>> -	/* Release the resources, as allocated based on interface */
>>>>> -	if (drvdata->flags & BUS_ACCESS_FLAG)
>>>>> -		devm_iounmap(dev, drvdata->regs);
>>>>>  #ifdef CONFIG_PPC_DCR
>>>>> -	else
>>>>> +	/* Release the resources, as allocated based on interface */
>>>>> +	if (!(drvdata->flags & BUS_ACCESS_FLAG))
>>>>>  		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
>>>>>  #endif
>>>>
>>>> I might be mistaken, and it's not strictly part of this series, but
>>>> shouldn't dcr_unmap be called somewhere else also, if the probe fail=
s?
>>>
>>> yes. It should.
>>
>> Do you want me to apply these patches as they are, or do you want to
>> improve the series to include the dcr_unmap fix?
>=20
> Sorry I have missed this email.
>=20
> Yes please apply it as is. I don't have ppc hw here to be able to test =
this
> change.

This series does not apply. Can you rebase on top of linux-next, and rese=
nd?

 Tomi



--8LQfKtohaGKeDF1R6SOJvp9emBl0oe3Dh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSVRurAAoJEPo9qoy8lh71WbUP/ic/dwgEUxAjkM0MniFDjArx
jVe/gNuPoXMMuwTnFQVtOa6i/Zwrv4Siuf+Y4iPiQ0Dy+BEvwXdEZK+pD/cUMU/a
fsuH0SBBPH9C67FcxJyvDvEiUUmUUIhsU9YoR4n+r8p8qg4bgo2I4zEjDL9u3ZJ8
geVwEHSKGVdzBqggflRmMZ4TkMXp/ztrGBD0+/Irj3je3ROwCM7yJxyUdu0vASPp
AJxVRoPg730wxVvQCzLE42oR0qqJ938MS7R/9VjRBkXR/04IDHDYeNfLe1oA5g51
kv0r21e/3mZrttLg1cC1P6tw6UBmuxpLnpqbGNvHdURKoWXJwY8Wouo/FU0z5BjO
IuBktUnjKlakWbVCf49KtAQa/KubpYSpigDHT3Z7tjW1ZUIHuugkDn7WSBUHWIhM
1CopH42uEGaHvgL5tnB2CAda8gPnvIM4ULKAFzeuERCnOFXz/Q7F1FlkbizEnXvT
gk6Fk05ZyyDyIc1HVB/GJ4NgFjI+xtJNXXPI0H+1mWPBKifLtEgMB5mRmbLdeJ9c
lEeomDPCE/F1w1GN517l+nbO6+5P47DkpTlQodgpY31qW1M+GXtNimbVnVZMSQR+
SCibd9ROfr+HFfim7SsUCnCZwFILb8znz9JkXh1OsXjK4nf3iM7hWTtj4qJGI9Th
9RPwcZ3uNf6psIYaYLtN
=LJ8h
-----END PGP SIGNATURE-----

--8LQfKtohaGKeDF1R6SOJvp9emBl0oe3Dh--
