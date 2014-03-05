Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaCESsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:48:46 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:33847 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaCESso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:48:44 -0500
Message-ID: <53177187.3040009@archlinux.org>
Date: Wed, 05 Mar 2014 19:48:39 +0100
From: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
CC: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "Bluetooth: Use devname:vhci module alias for
 virtual HCI driver"
References: <1394020752-6186-1-git-send-email-thomas@archlinux.org> <7E804DF3-E191-427E-8E20-FE6ECDC490EA@holtmann.org> <CA+5PVA56oO6FS2pG+D7yJtNrTqBGZ1CtPygjid4E0f3cPPi83g@mail.gmail.com> <424A74F3-7646-449C-9F72-A0F4E9A28551@holtmann.org>
In-Reply-To: <424A74F3-7646-449C-9F72-A0F4E9A28551@holtmann.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IjoenR8Lu8TWoIwELQST6xshkwADuDurH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IjoenR8Lu8TWoIwELQST6xshkwADuDurH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 05.03.2014 19:36, schrieb Marcel Holtmann:
>>>> This reverts commit bfacbb9aec029b3200053d84c8cd5d7575f2d4a5.
>>>
>>> NAK. We allocated a static minor for this.
>>
>> Johan mentioned that.  Commit b075dd40c95d11c2c8690f6c4d6232fc,
>> correct?

I am sorry Marcel, I only looked at the Linus tree, not at bluetooth or
bluetooth-next. This commit should indeed fix the problem. Disregard my
patch.

>  Why isn't that headed into 3.14 right now, and CC'd to
>> stable?  Currently you have a somewhat broken driver in 3.13 and
>> 3.14-rcX that seems to have a pretty clear fix.
>=20
> somewhat broken? kmod prints this as an error, but it is not a regressi=
on in user functionality. The driver works just as before. The error mess=
age can be ignored.

It's a regression in my sanity, since numerous users blame all kernel
bugs on this error message and I am tired of explaining the situation
(problem + error message =3D=3D problem found *sigh*). I only sent this
patch since I hadn't found the correct fix.

> So if anybody feels strongly that the static device node assignment sho=
uld be put into -stable, then I am fine with it. However I do not see thi=
s as passing requirement for a -stable fix since it is really not affecti=
ng anyone (minus the misleading message from kmod).

Since b075dd4 will end up in the Linus tree eventually, I have no
trouble backporting it myself.

Sorry for the disturbance.


--IjoenR8Lu8TWoIwELQST6xshkwADuDurH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTF3GJAAoJEChPw0yOSxolFTAP/iGb4emcN5k52NtG+qC8QhF+
XqgGY/vFAw4zxqq3FIyKQZ5JfdCalLlqkYFWJp5IicPK4pHRU0Gi2rt3mGJuHtf7
fbNiKIE1ot9ZTcVdbFgaEBtsJnSHqSavF5R1AdUpvD2yCAG8AcXhTSUr7JVuX3Xv
iRlMKC6ZXhCrQ3+GefyA9JFcKs+rVggt6B1X1HqJPt4xFIn6SMYhw7g3GYnoTgvP
CBIh2W5C6/GX9xAEgouJQrdBNou5jouBVX53zOggLRLxg6PhlvvqHVUHs7Y5b++N
394fojjjU3muR0OVYglhgtIiurTdrwzVU7HP7nyu+omnE4aXHrIf4nONEV5bxY+R
GWb7Ki0PSmd6ObtMr3zeDt2I3Z98W4xW5W9foW3znETZSGD82Vffwl1Ub/8GuNw0
P7EfdI4OHJmXaO124Nsl5+EwyOhe1to0jA6FEjrfbR21hO9rQm6X6EzZGARwUTwY
W4Cn7QfZ7MT8Qdf7PmLoAQqeKAC9ZL2EG9nNBeN07pgTnlfRX0cIMTAPq8m8GUMR
kr6pwQnjRgUDJJUy7PhNGsFxIKgu4z3eefArFGZTjulBVPSFbE/ciYOcn8Pwb2g4
coFZSSpe6m4rmJ5Gik9NMEDamF6KL1z8Lv94k1pnoPsV4x4CH6eUwE3d1ai3/UhM
FHO8waGDN+BlLpu6jvnd
=1DPJ
-----END PGP SIGNATURE-----

--IjoenR8Lu8TWoIwELQST6xshkwADuDurH--
