Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbaGPRqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:46:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41401 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760510AbaGPRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:46:36 -0400
Date: Wed, 16 Jul 2014 12:45:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <Peter.Chen@freescale.com>,
        <kishon@ti.com>, <stern@rowland.harvard.edu>,
        <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] usb: add support for the generic PHY framework
Message-ID: <20140716174513.GF3016@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HKEL+t8MFpg/ASTE"
Content-Disposition: inline
In-Reply-To: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HKEL+t8MFpg/ASTE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 15, 2014 at 04:39:08PM +0200, Antoine T=E9nart wrote:
> Hi all,
>=20
> This is an attempt to add more common USB code aware of the generic PHY
> framework, while keeping the compatibility for the USB PHY one. It does
> not add the full support, some USB PHY specific functions not being
> available currently in the generic PHY subsystem (e.g. usb_phy_set_power(=
)).
> But it allows to use the generic PHY framework in other cases, and might
> help others to convert their USB PHY drivers.
>=20
> A little background: I submitted a series to support USB on Berlin SoCs[1=
].
> One patch added a new PHY driver in drivers/usb/phy and Felipe asked it to
> be in the generic PHY framework instead[2]. This PHY being used by a Chip=
Idea
> driver, changes were needed in ChipIdea, OTG and HCD.
>=20
> This is done in 3 steps:
>         1. moving the OTG state from the USB PHY structure to the OTG one
>         2. renaming the field 'phy' to 'usb_phy'
>         3. adding a field for the generic framework PHY and dissociating =
its
>            use from the USB PHY one
>=20
> Step 1 is in the first patch. Steps 2 and 3 are done for OTG, and ChipIdea
> subsystems in patches 2-3 and 7-8.
>=20
> HCD generic PHY support was made by Sergei and Yoshihiro[1]. I added some
> modifications to make this support consistent with this series in patches
> 4-6.
>=20
> I tested it by using the ChipIdea driver I introduced, both with an USB P=
HY
> and a PHY driver successfully. I also compiled a multi_v7 kernel (ARM), w=
ith
> every driver I could enable in the USB section.
>=20
> I'd like more people to test and your inputs and suggestions on these cha=
nges.
>=20
> Feel free to add Ccs if others might be interested in this. If needed pat=
ches
> can be squashed or divided, I tried there to group modifications by USB
> framework parts (OTG, HCD, ChipIdea).
>=20
> Patches can also be found at:
> git://git.free-electrons.com:users/antoine-tenart/linux.git usb-phy
>=20
> The series applies on top of Sergei and Yoshihiro generic PHY support in
> HCD[1].
>=20
> Thanks a lot!
>=20
> Antoine
>=20
> Changes since v1:
>         - rebased the series on top of [1] (generic PHY support for HCD)
>         - split s/phy/usb_phy/ renaming and generic PHY support in separa=
te
>           patches
>=20
> [1] https://www.mail-archive.com/linux-usb@vger.kernel.org/msg43471.html

Since this has a dependency on the other series which hasn't showed up
with enough Acks, I can't take this one either. Let's get this ready
early into v3.18-rc cycle so we don't miss this and the other series
again.

cheers

--=20
balbi

--HKEL+t8MFpg/ASTE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxropAAoJEIaOsuA1yqRE2JYQAJ3hJ76UScjsAtpmgvXTfgvH
Ltm/5OZd/06JmVs/cGDLUa7Jc4GMJa39PeWRL7L3Ev6xqp0IxK31snV3vLWlsdGo
vAGIggbfoMJgnwlbvHM3t3B3WGuElUpHpp0bJJ4KZ+4SSaz7+Xk8f50wJ4/eSDVL
sMT7KIW7uvb6kWWUJ2aQPDJ3igrJtzdrDFGTEo1uXd88jTOdGRkMZVL4M0VzOKO2
ui8PziTJXNeuTkSIgdpFfgXK6fm3KvQyzRhcoHMEBlyyRWY6kcYI4uH6ddswrC8x
6RMeCdnxxMvw6oKhrpq+wW56X4n2lBD5p9ridokZwjDNYllIDwymOS0Zs0SFSE+k
b35GTd1aM5eG1tU5QcYKvvPT/DHyk3VLvWVXiAFs7r0vSKEGR9/7pV+JtgYPCqOO
gelGoCHYhzvKwwKab0VXD20o3TbI67Pf5wp8jd4cfF3a6+JyR9ighPgerHtxFwuW
ynHAub77gIjjr22AJgixddgYifdd2vACPa29drjQmxSkSKP3EKLXLvM9PwK7/yz7
n2H3iLaJBNBJ/wa3iz96ytaokkP5bKFHmoZoUXmVlMgXdDoB4+86Pq6hsRDDNCNf
vrSyL7BNTseYzhntemKfo/pLLM5J3H8XHsNlqg7ST46I1HYBwfxzA9x6oJMSznfZ
pILgtiaijN+/Bd0GBHTx
=F01I
-----END PGP SIGNATURE-----

--HKEL+t8MFpg/ASTE--
