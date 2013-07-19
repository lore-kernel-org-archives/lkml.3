Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480Ab3GSNFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:05:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760287Ab3GSNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:05:17 -0400
Message-ID: <51E9392F.8060604@ti.com>
Date: Fri, 19 Jul 2013 09:03:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <wni@nvidia.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <l.stach@pengutronix.de>
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <20130717220942.GB990@roeck-us.net> <51E7F341.8020508@ti.com> <51E8234D.1020607@wwwdotorg.org> <20130718212108.GC4110@roeck-us.net>
In-Reply-To: <20130718212108.GC4110@roeck-us.net>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2BIREBRJXPSEJHVPFLJRW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2BIREBRJXPSEJHVPFLJRW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18-07-2013 17:21, Guenter Roeck wrote:
> On Thu, Jul 18, 2013 at 11:18:05AM -0600, Stephen Warren wrote:
>> On 07/18/2013 07:53 AM, Eduardo Valentin wrote:
>>> Hello Guenter,
>>>
>>> On 17-07-2013 18:09, Guenter Roeck wrote:
>>>> On Wed, Jul 17, 2013 at 11:17:19AM -0400, Eduardo Valentin
>>>> wrote:
>>>>> Hello all,
>>>>>
>>>>> As you noticed, I am working in a way to represent thermal
>>>>> data using device tree [1]. Essentially, this should be a way
>>>>> to say what to do with a sensor and how to associate (cooling)
>>>>> actions with it.
>>>>>
>>>> Seems to me that goes way beyond the supposed scope of devicetree
>>>> data. Devicetree data is supposed to describe hardware, not its
>>>> configuration or use. This is clearly a use case.
>>>
>>> Thanks for rising your voice here. It is important to know what
>>> hwmon ppl think about this.
>>
>> I meant to find time to read Guenter's original email where he
>> initially objected to putting data into DT, and determine exactly what=

>> was being objected to. I still haven't:-( However, the arguments that
>> Eduardo stated in his email do make sense to me; I agree that
>> temperature limits really are a description of HW. Details of which
>> cooling methods to invoke when certain temperature limits are reached
>> is also part of the HW/system design, and hence I would tend to agree
>> that they're appropriate to include in DT. Anyway, that's just my 2
>> cents on the matter:-)
>=20
> Many systems have multiple profiles for various use cases (high perform=
ance,
> low power etc), and limits are different based on the use case. If that=
 means
> you are going to have multiple devicetree variants based on the profile=
,

No, definitely this patch series is *not* about mapping multiples
profiles for various use cases on device tree! This series is about
mapping *hw thermal limits* on device tree.

> I would argue that you crossed the line. With thermal profiles it gets =
even more
> complicated, as those parameters may be played around with and changed
> multiple times to find the best settings to achieve optimal cooling.
> Does this describe hardware ? I don't think so, but, as I mentioned bef=
ore,
> maybe I am wrong.


Again, this is about describing points and actions to avoid your hw
degradation. May be also useful to avoid end user harm.

This series is not about describing performance profiles.

>=20
> Guenter
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2BIREBRJXPSEJHVPFLJRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHpOTYACgkQCXcVR3XQvP1NHgEA7ywKtUv4uynaz3d9jz+0loXf
OwksdKtQvXKOf0aiKVwA/j63Xo1FE8uul74h3pYRfysJDOdE0AtatjHl4P3MI+zP
=bzLm
-----END PGP SIGNATURE-----

------enig2BIREBRJXPSEJHVPFLJRW--
