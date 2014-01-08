Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaAHODY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:03:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38973 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311AbaAHODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:03:21 -0500
Message-ID: <52CD5AA2.4@ti.com>
Date: Wed, 8 Jan 2014 16:03:14 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
References: <52CA7ABB.4010401@gmail.com> <52CBF476.3070306@ti.com> <52CC62B7.3030004@gmail.com>
In-Reply-To: <52CC62B7.3030004@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kpF2SsOSUA7Qfsh33O6bQMaPbLw07mbO1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kpF2SsOSUA7Qfsh33O6bQMaPbLw07mbO1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-07 22:25, Ivaylo Dimitrov wrote:

>>> Besides compiling DSS driver with DEBUG enabled and providing the log=

>>> (yeah, I know I should've done it already and have the logs included =
in
>>> this mail, but... :) ), is there anything else I can do to find the
>>> culprit for those errors.
>>
>> You could look at the original patch in the Nokia kernel to see if the=

>> mainline version is ok. Or maybe even better, try the same use case on=

>> Nokia's kernel to see if it works.
>>
>>   Tomi
>>
>>
>=20
> Ok, after looking at what both N900 and N9 Nokia kernels do, I came up
> with the patch bellow. If you are ok with the changes, I'll submit the
> patch as it should. With that patch I tried more than 20 videos of
> different resolutions(including 720p), not a single failure :) .
> Basically it changes the core clock calculation to be done in the same
> way as in the Nokia kernels.

Hmm ok. So the code was only partially ported to mainline?

You only seem to touch omap3 specific funcs, so I guess it's safe to
presume omap2/omap4+ work as well (or bad) as without this patch (i.e.
no need to test on various omaps =3D).

Thanks for figuring this out. Please send a proper patch, and if
possible, with an url to the Nokia kernel's code (presuming it's
available in a sane way).

 Tomi



--kpF2SsOSUA7Qfsh33O6bQMaPbLw07mbO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSzVqiAAoJEPo9qoy8lh71YcAP/0L8lCKv4VnatAqzlyTTghgs
B6yTp9RG5P60i8LH1lVOPBhwmozQN98tQXwy3b97tP0N4+LOV+QBN4tQZWRDYcMv
nKh6yRCba9t//NMUNt+mrXVSXFy8iRPLk8DqFs93VyMWeO04njFDrkCwTU/1eBPh
BRHTzdT8JtpexOOCn4HpZu4/thUGn1MindEh3Yvq7z81GUfp1y722SxlK6FDEfgo
evMyOiZ7vb+v1uaObB3gCkLT7piMqBl6AhHvr446QfpxOFF3J7AznI2stQyTWI7Z
IjOjXMSX9//5TDZeXgZN7UE/J8goVHiX+NlZ1AL9qyzO8lAZnDxh6j0/6T5aKdW/
i+lY+p9iW2ZhGsJRhiR/r7jLZPJnb3hm/5rN4zykC/EutuomObxQt7JLl5nEdUYn
Pvs5qdvzjXIE2nK5zgCYOuXqHU7mPjl83SOcpPhvGXn4GLXexoBOiTBUiBFKDpz7
e1VaErp6KsGc+A6ZM9Sc+G++WFL02y7IfOgk0PiMCeZLEWv1WrpedholtriLe8sK
xQnWRGT4+5GqaCdRu9FAKoJ9t19s3htz2223DQFZW5a5fWHePApM72E3LHlYGk2h
8OWgYkBW+sPddEri2lZIKJF7vNVyQKPkPszy9wNxZIUWFZfeHfPN1BhViaScYfv2
COuncwNpVZykf+ubmoPp
=Ha3b
-----END PGP SIGNATURE-----

--kpF2SsOSUA7Qfsh33O6bQMaPbLw07mbO1--
