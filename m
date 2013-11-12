Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3KLMyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:54:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61087 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3KLMyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:54:37 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
In-Reply-To: <5281706F.5050507@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com> <xa1tzjpawl1x.fsf@mina86.com> <5281706F.5050507@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131112:balbi@ti.com::H+AfgsvTEyQVtBo2:000000rdu
X-Hashcash: 1:20:131112:linux-usb@vger.kernel.org::AyacFxlfBMCK6qw0:0000000000000000000000000000000000001i0d
X-Hashcash: 1:20:131112:david.a.cohen@linux.intel.com::PSwaT3gs8mQQbAd/:000000000000000000000000000000001/s6
X-Hashcash: 1:20:131112:stern@rowland.harvard.edu::wx7VB+EqxM86cLah:0000000000000000000000000000000000003crO
X-Hashcash: 1:20:131112:gregkh@linuxfoundation.org::ZUuWeY777nW90dJV:0000000000000000000000000000000000047v+
X-Hashcash: 1:20:131112:linux-kernel@vger.kernel.org::aSh3Tvf0Xl15gKl/:0000000000000000000000000000000006q4p
Date: Tue, 12 Nov 2013 13:54:28 +0100
Message-ID: <xa1t1u2ln5kr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12 2013, David Cohen wrote:
> On 11/11/2013 03:55 PM, Michal Nazarewicz wrote:
>> Come to think of it, perhaps even better helper would be:
>>
>> static inline size_t usb_ep_align_maybe(
>> 	struct usb_gadget *gadget, struct usb_ep *ep, size_t len) {
>> 	return gadget->quir_ep_out_aligned_size ?
>> 		round_up(len, (size_t)ep->desc->wMaxPacketSize) : len;
>> }
>
> The CPU time to check unsigned:1 and possibly jump is about the same as
> round_up() itself. For readability matters, we can round_up() directly.

I was proposing to have this function and than not have functions check
for the flag.  I.e. instead of

	if (gadget->quirk_ep_out_aligned_size)
		len =3D usb_ep_align_maxpacketsize(ep, len);

the code would just be:

	len =3D usb_ep_align_maybe(gadget, ep, len);

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSgiUEAAoJECBgQBJQdR/0h4UP/3wCriUkTpR/RcRnU4SSp5z7
YBaDVWPpffpScwWNTd6kGHyh5MCTfyb0FNpRrq181ZNQIRjeLMGABiiFXuVQihrK
1z+9RKMpi3E/2i95s0Qu630rlhfatGKspKx2j1AA4Byu+hv2V83SzWfRmEAqR8hd
1QuNoTK0BxmBsH+LSOPedcDtfpy2yucFgTg6CU8kreP/CVMnwBvAeXjbUd29MD3i
jv4evcFxkcj2ICYF5Dg0gSdDaqiwfMHfnT1gu3vFjP1+chyfzmwfW7Sc8B6sj2CQ
R3Wnc0pq4SlpVqw0POioDwk4PTbV39rUZSIBV6LDQI9n1GdClqG3sWJ/oKntL/fw
qf92KrYOspcqRCc+ozHjLFAaPKgRXJ8AkSsYiNGzZaZkGOSIucek/f4Q7sDiH6t2
Wt3m/UHKEB0ooT4PumUQm+xPybqtCGgPWYUSQ7HHLR4pC74OfvrVcLyfI92pA8Ze
IRvw31MFUmjFJFhpEYUAAH8jm29AF5tajNrCmQActkAv3gV0+h2kxxPbayiZ1rsv
3G5FOJKtswvVV18mZihFpp1P+Dhusz4LuEJ3W8dxIeH0pavTyhyxTB7L9ah8RHsT
hYmGr2r2xv55UDOlmoY3vGAht8xdf0XA1AvkRFl+7nercAmd6A2D6Rw+JleS2SH0
H9ZjGp+uKfS2DbXR0nNR
=s3FC
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
