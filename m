Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaEZHCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:02:51 -0400
Received: from mout.gmx.net ([212.227.15.19]:52454 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaEZHCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:02:50 -0400
Message-ID: <5382E711.8050506@gmx.de>
Date: Mon, 26 May 2014 09:02:41 +0200
From: =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <maltesch@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Woody Suwalski <terraluna977@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Radeon wakeup regression in 3.15-rc6
References: <53805C4E.7050205@gmx.de> 
In-Reply-To: <53805C4E.7050205@gmx.de> 
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aotU5AumpaQ45uFVuKnl7puIi7g3W90U1"
X-Provags-ID: V03:K0:T7rAP1gfzK+KB0IFmpHbuAkpwHFGRBeKc2J6bjIxifIS6AX0HPo
 jAaHNVcLz+od+uvF69GOdiSzYaSQCBiIags+JO1TwaMm007LGySAOKWy3zN0bTneQb6kohF
 Jm5lIuEuZ3w1YGWD+g1mybhOCPZox58sWYzIM1rfJDfDh90Rb2MH0nd1H2fw1wnvo+5b888
 F1e0Tjr1ns4JFFMUCUfFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aotU5AumpaQ45uFVuKnl7puIi7g3W90U1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25.05.2014 14:56, Woody Suwalski wrote:
> Malte Schr=C3=B6der wrote:
>> Hi,
>> I just tried 3.15-rc6. I encountered a pretty nasty problem, which is
>> after suspending to RAM the system doesn't wake up properly. v3.14 is
>> fine.
>> On wakeup all seems fine, i.e. hd starts to spin an USB-stuff wakes up=
=2E
>> But all I get from the graphics card is a white screen slowly filling
>> with random colored pixels. I had to hard reset the system.
>>
>> I attached the kernel log, the X-servers log, lspci-output and my kern=
el
>> config.
>>
>> Regards
>> Malte
> I have seen a bit of a screen distortion at the bottom of LCD on Radeon=

> after a wakeup.
> I tried to re-run with drm.debug=3D0x0e, however once I did it - the
> problem has disappeared, and I have not been able to duplicate it again=
=2E
> So just watching for now.
> OTOH I have seen (only one time) a black screen after wakeup on Nvidia.=

> So maybe some timing is now exposed in PM / DRM...
>=20
> Woody
>=20
>=20

I pulled git://people.freedesktop.org/~deathsimple/linux drm-fixes-3.15
 from http://article.gmane.org/gmane.comp.video.dri.devel/106114 and my
problem is gone ...

--=20
Gru=C3=9F
Malte Schr=C3=B6der
---------------------------------------------------------------------
MalteSch@gmx.de


--aotU5AumpaQ45uFVuKnl7puIi7g3W90U1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTgucUAAoJEJhhoDgpnptogcEQAJAeJsCSjM1srBrFsr570KKu
KqpAQ7yE0TMlm71JUEOpLr59C/dQO5+FcMz203SuRB/WdFXrraQmu3oBb+7UCE++
PDPNa+rPv1Xul4L+cecI5sFxAGFsCMM8MvROJ0XWaUuwnAPo1MWwvHjBg/xXsALV
fi6Ufdijg2S8qUsqkFB8/4B+pEshWs0XwsOoijTZTpleFLyPPxmClw5Asy+VR7rf
as4s8Vd2fH6Bt13/Qf6tdJ/ccJ2CKDB6sMMTar/viRIxzlm/ovWX4O4rgfGV9vWy
cGkSpt5zQPkhbEt/Guj8WeJO8x5tbaNOPdgwk+V96u0ykxlAQuSObcqvv94zQ3Ed
CW1ezxLUCxZtUcAenBuWQ28+GkMvsTusH1d6c9gAVcEo8R8hjXtDoP9U1JA6BGr4
qcPhNvj9kZfUeSy4MjjERmyQ9C8rov43jaAeZTXLz9mod9nm19lN0d43/0kRzJK9
m9JcEqV2Mp3wGtbVE3ekOj3MxbU4u7QQLdOHQXKEMc930pqf87u3RTJMO8oL073L
d/LTQKdn/YK2U670d57kmUUvdVPadDcRple54L4Xd0o5VP2CylyNDriOKfAh+Lsj
pRgdgSxymN8qKRaZMgzG0J/m1weDJJkId1NoE8Q7Qp3QUvvxp9H14HXU2MMTBcN2
ROtdjTTDGvPZq7jGIKAz
=D5tS
-----END PGP SIGNATURE-----

--aotU5AumpaQ45uFVuKnl7puIi7g3W90U1--
