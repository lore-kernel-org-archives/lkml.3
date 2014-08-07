Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaHGNOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:14:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57748 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGNOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:14:53 -0400
Date: Thu, 7 Aug 2014 15:14:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: caesar <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, b.galvani@gmail.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, rdunlap@infradead.org,
        galak@codeaurora.org, cf@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, cjf@rock-chips.com,
        hj@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/2] pwm: rockchip: Added to support for RK3288 SoC
Message-ID: <20140807131443.GA1540@ulmo.nvidia.com>
References: <1406197295-10604-1-git-send-email-caesar.wang@rock-chips.com>
 <1406197295-10604-3-git-send-email-caesar.wang@rock-chips.com>
 <20140807061842.GB17340@ulmo>
 <53E3795E.4080607@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <53E3795E.4080607@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 09:04:30PM +0800, caesar wrote:
[...]
> As you say, I will rewrite the about if it's really need  do so it.
> For example:
>=20
> static const struct rockchip_pwm_data pwm_data_v1 =3D {
>     .regs =3D {
>                 .duty =3D 0x04,
>                 .period =3D 0x08,
>                 .cntr =3D 0x00,
>                 .ctrl =3D 0x0c,
>     },
>     .prescaler =3D 2,
>     .set_enable =3D rockchip_pwm_set_enable_v1,
> };
>=20
> static const struct rockchip_pwm_data pwm_data_v2 =3D {
>     .regs =3D {
>                 .duty =3D 0x08,
>                 .period =3D 0x04,
>                 .cntr =3D 0x00,
>                 .ctrl =3D 0x0c,
>     },
>     .prescaler =3D 1,
>     .set_enable =3D rockchip_pwm_set_enable_v2,
> };
>=20
> static const struct rockchip_pwm_data pwm_data_vop =3D {
>     .regs =3D {
>                 .duty =3D 0x08,
>                 .period =3D 0x04,
>                 .cntr =3D 0x0c,
>                 .ctrl =3D 0x00,
>     },
>     .prescaler =3D 1,
>     .set_enable =3D rockchip_pwm_set_enable_v2,
> };
>=20
> Is that right?

Yes.

> >>+	.set_enable =3D rockchip_pwm_set_enable_v2,
> >>+};
> >No need for the double indirection.
>=20
> Sorry, I think is need if you mean a double indirection for ".set_enable".

The "double indirection" was regarding the symbolic names for registers,
not the .set_enable(). Sorry.

Thierry

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT43vDAAoJEN0jrNd/PrOhD90P/38+cAEBv27cc1vxPhOCtHs9
L3ygr0FMsJbcYAbX0KEtkNcudus5e12dpIeXvUHqhWzBGmBD6ABnlqczc9mFBgS0
3eHvaNtYLh1ngSCXf7wmB5fGhzVaUqzuh2wpzzYQiNr3F9GRBvMX4REDrkvvRX/N
leT5n9twCEgU3DQmFzqTTwDpx3s5MkNPpo2viaAxrGRapIbT/iFCOEgFr/VqFhPd
MrbqxRfSgW3ywdVRJRnQcoIyma2rWhoyp87d9HAtMLH+G9B8KHV7if5aUWYyg0n1
H6FMW4T9a+6yJCJnPoYE2+dsOW3aldAdQVmv0kU0PddcjqC6JngsJTzavRhQESW6
ldNgtde6my/aX4lnkSXSkeAuGZOg/rhqvl9lXPRBfAwAWpG6KgEpDh8yD0tMEIzs
iGpI48oNu/MrKQ69Y2oFktPFFYlSZBRx0P8sXxmoupM526C0Eg+/QIRHI6Djd07V
WPnR+xmLI5UJyGhFN/rPzhS1013yxlZwwWLiRD9TMnX8+Zgbk7v1BV23HXlrB5+Z
yMvkGEG+D887Kfg2WVC/QQYS7fUUJHmHbvHL+OrHvN9JRXa6oy/CvKVzhQPf7Wgq
qbzgDXb0EhAFt3rfqNoeOpNOag8bPV1E48Pmbm9D52fURwV81IFsv/yhffmqG+NU
Bl+imYGPYpio/i/kve1t
=+pXz
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
