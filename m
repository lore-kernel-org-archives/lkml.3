Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3IVAZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 20:25:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36889 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab3IVAZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 20:25:06 -0400
Message-ID: <523E388F.80707@ti.com>
Date: Sat, 21 Sep 2013 20:23:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <rui.zhang@intel.com>, <wni@nvidia.com>, <grant.likely@linaro.org>,
        <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCHv3 05/16] hwmon: lm75: expose to thermal fw via DT nodes
References: <1379457325-18192-1-git-send-email-eduardo.valentin@ti.com> <1379521314-16959-1-git-send-email-eduardo.valentin@ti.com> <523DE01F.4020607@roeck-us.net> <523E2C1B.9010307@ti.com> <523E321F.8050502@roeck-us.net>
In-Reply-To: <523E321F.8050502@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="RkarQOG3vJEbKAaitGRxPoHpbGxAkROdT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RkarQOG3vJEbKAaitGRxPoHpbGxAkROdT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21-09-2013 19:56, Guenter Roeck wrote:
> On 09/21/2013 04:30 PM, Eduardo Valentin wrote:
>> On 21-09-2013 14:06, Guenter Roeck wrote:
>>> On 09/18/2013 09:21 AM, Eduardo Valentin wrote:
>>>> This patch adds to lm75 temperature sensor the possibility
>>>> to expose itself as thermal zone device, registered on the
>>>> thermal framework.
>>>>
>>>> The thermal zone is built only if a device tree node
>>>> describing a thermal zone for this sensor is present
>>>> inside the lm75 DT node. Otherwise, the driver behavior
>>>> will be the same.
>>>>
>>>> Cc: Jean Delvare <khali@linux-fr.org>
>>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>>> Cc: lm-sensors@lm-sensors.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>
>>> Acked-by: Guenter Roeck <linux@roeck-us.net>
>>>
>>
>> Cool! thanks again for taking the time to review this.
>>
>>> I assume this will be sent upstream through the thermal tree ?
>>
>> Yeah, that is the idea, at least for the core part. The hwmon changes =
I
>> believe goes via hwmon tree, right?
>>
>=20
> Not necessarily, as the hwmon code depends on the core code.
> In such cases it is quite common that both are sent through the same tr=
ee.

If this works for you I can queue these changes via the thermal tree.

>=20
> Guenter
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--RkarQOG3vJEbKAaitGRxPoHpbGxAkROdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlI+OJAACgkQCXcVR3XQvP1YiQD+JZooF8YOKlvGkdDpSBoiwRCi
a8TnkjJ9P2v9DfASHC4A+QHRzlhGlzEleFn8xxJ4hmC3gUPqAULKhcITQCGj3PHj
=5NFu
-----END PGP SIGNATURE-----

--RkarQOG3vJEbKAaitGRxPoHpbGxAkROdT--
