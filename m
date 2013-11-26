Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3KZQjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:39:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab3KZQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:39:26 -0500
Date: Tue, 26 Nov 2013 10:38:46 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/15]  usb: phy: msm: Fixes, cleanups and DT support
Message-ID: <20131126163846.GF24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 12, 2013 at 04:51:35PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> Hi,=20
>=20
> Patches have been tested on top of Stephen's clock controller
> patches[1] and recent fixes for chipidea msm glue layer driver
> posted here[2]. Hardware platform AP8074 DragonBoard. Only gadget
> mode utilized for now.=20
>=20
> CV Test Suite engine "Chapter 9 tests" are passing except
> "Halt Endpoint Test".
>=20
> usbtest driver report following failure:
> test 13 --> 32 (Broken pipe) 		ep 81 couldn't set halt, -32
>=20
> This will be investigated further.=20
> Patches could be applied cleanly on top of the usb-3.13-rc1.
>=20
> Regards,
> Ivan
>=20
> [1] http://comments.gmane.org/gmane.linux.ports.arm.msm/5375
> [2] https://lkml.org/lkml/2013/11/11/310

I wonder how will this be taken upstream provided there are
interdependencies between arch/ and drivers/ patches.

I can Ack patches but I'd really like to avoid merging of topic branches
all over the place :-s

cheers

--=20
balbi

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlM6WAAoJEIaOsuA1yqREsHsQAIyZ8cKv7TfH1994BAuD4x+p
W+9L5NlxiTvovfopuUgsEjld6EeFK6iX2nMUDL9SklfruKDviEm1+8ifZoIyw1z1
hxavSOAuwbX7G62Y8UXt4EP/dHKtJzfxEt3rN/D09/oRBqiSFIyHKHg+IY9YEYv4
UxVkoym6HgQdVidQMeA61tQaL1CcUr2+U78HN6pijNM1yCief3iM9YZiJn+ALHkx
rAr9bMhuXdgT4l+r3/Mf7cB6JHOOOsf8agBXZ/luDcwFh7YvM0PD5yGIjgKEEpq3
57HCyZkm5EEmFrjUlY85XV8EzIbiQlClQZzP3SJBP7uH5nZyPrObLBIJS3Pccs36
lzE2UX167/q8dnHW6SANQv7IaTv5CMJDj9QOpcLCyrmHMMfEf1B3zXxFX1v+ilAt
tlicDD6HoPP9PSX0+Uk+sU/DMcF778RunjoibyciOO1KrsPz7QWczAPEMyu8Q+pC
RmvEpOxeuVMZ1PHXUwUZzVLULwD1LXKnbCFZxdMbajBr+koMTNsuiGNuslxa2HWB
uRCyHXesOYsd6IY+Z6GwbpiCw1Ov53iXbUMUS/TWGwEb4LLyYdne+7K/sxckWaFi
q3mr40Mc951a6ataqTTgxIb7yeQ5mruqPuX5hyeNWGU9XxXVK+cgzID3vaqNezfS
GYaIWf8TawPWGBVXNgRh
=PNC7
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
