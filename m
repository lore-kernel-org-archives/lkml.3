Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3KLUQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:16:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49033 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3KLUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:16:10 -0500
Message-ID: <52828C31.2050604@ti.com>
Date: Tue, 12 Nov 2013 16:14:41 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>, Grant Likely <grant.likely@linaro.org>,
        <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv5 20/20] MAINTAINERS: add maintainer entry for thermal
 bindings
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-21-git-send-email-eduardo.valentin@ti.com> <CAOesGMiCh-nGPqJQd4NPz9st7mBT0JkZ9nEK1gfyF2RmnrXZog@mail.gmail.com>
In-Reply-To: <CAOesGMiCh-nGPqJQd4NPz9st7mBT0JkZ9nEK1gfyF2RmnrXZog@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="f56BqfqqbEW80qud7ROafavhrG6UELiBc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f56BqfqqbEW80qud7ROafavhrG6UELiBc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-2013 15:59, Olof Johansson wrote:
> On Tue, Nov 12, 2013 at 11:46 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> After discussion and agreement of thermal device tree bindings,
>> it is desirable to properly maintain thermal bindings for
>> existing and upcoming devices.
>>
>> As original author of thermal device tree bindings, I am
>> volunteering to maintain them.
>>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  MAINTAINERS | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3438384..94bfc46 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6178,6 +6178,7 @@ M:        Pawel Moll <pawel.moll@arm.com>
>>  M:     Mark Rutland <mark.rutland@arm.com>
>>  M:     Stephen Warren <swarren@wwwdotorg.org>
>>  M:     Ian Campbell <ijc+devicetree@hellion.org.uk>
>> +M:     Eduardo Valentin <eduardo.valentin@ti.com>
>>  L:     devicetree@vger.kernel.org
>>  S:     Maintained
>>  F:     Documentation/devicetree/
>=20
> The number of device-tree maintainers is getting to be somewhat silly.
> You don't have to be a maintainer to be a reviewer, and the number is
> getting large enough that it might get hard for one maintainer to know
> what another is doing.
>=20
> So, soft nack, but it's really up to the DT guys.

Hello Olof,

No issues on my side. As I stated in the patch description, I am
volunteering. The motivation comes from the fact that it's been hard to
get DT maintainers attention, so I am assuming they are not having
enough bandwidth to pay attention to an extra class of bindings.

I agree with you, this is up to the DT folks.


>=20
>=20
> -Olof
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--f56BqfqqbEW80qud7ROafavhrG6UELiBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKCjD4ACgkQCXcVR3XQvP2MdwD/SEGaGTglYxEMz7+GH81ShNQ9
/80YSr5UHanZY02HA7oA/R+SZ8lrWwyGFUYWzziqk4zsFmJseZciL7A7mmMgZtDf
=TWz8
-----END PGP SIGNATURE-----

--f56BqfqqbEW80qud7ROafavhrG6UELiBc--
