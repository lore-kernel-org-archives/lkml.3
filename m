Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCHK5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 05:57:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48871 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaCHK5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 05:57:49 -0500
Message-ID: <531AF782.5080801@ti.com>
Date: Sat, 8 Mar 2014 12:57:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>, Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core
 to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>	 < CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>	 < 20140217181451.7EB7FC4044D@trevor.secretlab.ca>	 <20140218070624.GP17250@ pengutronix.de>	 <20140218162627.32BA4C40517@trevor.secretlab.ca>	 < 1393263389.3091.82.camel@pizza.hi.pengutronix.de>	 <20140226110114. CF2C7C40A89@trevor.secretlab.ca> <1393426129.3248.64.camel@paszta.hi. pengutronix.de> <530EF914.3000407@ti.com> <20140307170645.CE50DC40A1B@trevor.secretlab.ca>
In-Reply-To: <20140307170645.CE50DC40A1B@trevor.secretlab.ca>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lfSvpLQODLCNjnDX4EBJCJBLVdb4h0r6v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lfSvpLQODLCNjnDX4EBJCJBLVdb4h0r6v
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/03/14 19:06, Grant Likely wrote:
> On Thu, 27 Feb 2014 10:36:36 +0200, Tomi Valkeinen <tomi.valkeinen@ti.c=
om> wrote:
>> On 26/02/14 16:48, Philipp Zabel wrote:
>>
>>>> I would like the document to acknowledge the difference from the
>>>> phandle+args pattern used elsewhere and a description of when it wou=
ld
>>>> be appropriate to use this instead of a simpler binding.
>>>
>>> Alright. The main point of this binding is that the devices may have
>>> multiple distinct ports that each can be connected to other devices.
>>
>> The other main point with this binding are multiple endpoints per port=
=2E
>> So you can have, say, a display controller, with single port, which ha=
s
>> two endpoints going to two separate LCD panels.
>>
>> In physical level that would usually mean that the same pins from the
>> display controller are connected to two panels. Most likely this would=

>> mean that only one panel can be used at a time, possibly with differen=
t
>> settings (say, 16 RGB pins for one panel, 24 RGB pins for the other).
>=20
> What device is in control in that scenario?

The endpoints in a single port are exclusive, only one can be active at
a time. So the control for the active path would be no different than in
single panel case (for which people have different opinions).

 Tomi



--lfSvpLQODLCNjnDX4EBJCJBLVdb4h0r6v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGveCAAoJEPo9qoy8lh71R74P+gIz+WGE6WfW2fMVMXiVQf84
+VoyCY9AKmAJiugsQJAEZnm9Wsm7KQhs/6NH6orR77AOOgzl7nXxFgpWT/UiCeIE
uHisz0+OZDGPyswsrRhin2iQRJlPoAexsiHHMuvpBjIBO5UbGjNkxPuCBcZeg7Q8
sUYQFnr1mn3b8uh4o6lmAX2o/FJNqxIQvJ4OqCzLeckYStHDQ+zQARi5oVC90AjZ
XXZGVroUJ9ygIKpkF3xjZ55xVUNGzC80UnD6J/4WWr4orLrRay4vCMOJLVC2ygwH
X+t92C1HxYWnF7j3cjl7vCrTIXOJkJKTz/WedhZtiSc8pA6sjh2W10+/tR4k3acT
12wedIemZrVu4vR21twy4isdYK2z2U401ZLr+QUh4kazJauheohBaMRqKG/7A+k+
0MosFuBAGhH9YdNzmtqkGbrlWDCX3ak7nHSPmhT9y75m57H+PpdQj5LtGoVZ6h6/
6fJv7CGT6mAsCGiY7WuiawpDSgbyRsRF9dipJA1VMxIosOLEp1UCG0KKpUox9eX5
UP6xV7QPp+xwePs/LdSCKRfTJz2QVSCNvtrSi/9SnCxqh8jve+9KMxK2rYBtWZe0
OKmQB6Ie+y7ZD7vUJjTQTNZTultu5fnauHP4phIjB5Xzl1Y8Atlp+5l/atCD9TMw
nSkVMHQqpvBJhHIt3ltw
=831F
-----END PGP SIGNATURE-----

--lfSvpLQODLCNjnDX4EBJCJBLVdb4h0r6v--
