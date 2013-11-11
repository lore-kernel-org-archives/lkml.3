Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3KKVM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:12:28 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51415 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3KKVMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:12:20 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <52812C2F.30202@linux.intel.com>
Organization: http://mina86.com/
References: <1384102237-19784-1-git-send-email-mpn@google.com> <1384102237-19784-2-git-send-email-mpn@google.com> <5280567C.2060004@linux.intel.com> <xa1t8uwvyyia.fsf@mina86.com> <52812C2F.30202@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::pp3UrORL5gxHpua2:0000000000000000000000000000000000h0a
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::qJmedj4JLDYJrlNM:0000000000000000000000000000000000000JVG
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::/agjihryQz3WOaHL:000000000000000000000000000000000yo1
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::kGvvQyyqbxwck8C/:0000000000000000000000000000000000008hde
Date: Mon, 11 Nov 2013 22:12:10 +0100
Message-ID: <xa1teh6my76d.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, David Cohen wrote:
> But the whole series became messy with too many amends. If you don't=20
> mind, I'll send a v5 of my patch set including my v4.1 patches + your 2
> ones following the correct sequence.

Please do, but as Alan pointed out my second patch needs some fixes,
namely the last two hunks are not needed.  If you want I can resend the
patch, or you could just drop them by yourself.

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

iQIcBAEBAgAGBQJSgUgqAAoJECBgQBJQdR/0RH8P/1QwB81Nd++yQvjZ241BpGfr
pwzSU8F9CP7mts4ehq4GL3EhkzC4nb8g0OeYtuGuDBfqcZ7mhuf6o5mJj3v4IerB
hqLcO8GwHQFa0/d0MmR0gIVCj5lyFXd29yFZyMM91fAO2BK8Tk/FG6Yb9kS1JUIr
t3WX1Uvi/VurX3yFXJj22MgkLmtYzCmI4Vd1c8fIoPHwjghwZ/rtZo47q62qQtO1
koAQVVPSX82TlEG28luzjnr7rkqSJgLCh0aQxHEs3zNtAbilRr6pZrtrmSNZhvJr
s/+bJvJJekskUyndSYfJD8oxSid7jn2q9wkvKht9ppHeh6i6kgp2gvm8iZpWBYsi
c971K8NZI77GJagEl7/25v3qJI7gMt/P5Z2IrtZ/So0gLXRINS4/G7rXsWMK8SVJ
N70vZ9MBar15e5G/w8WDM7BQlefIbd9I0nA6x9/u3Csk88x5LAOS3obRuVcpi1xh
Iz8X5fpGO8SX/qkNE9C+uVP8fCB9nKQbZp/yAMUNzG7QnhY60jkeosdWS60GuZRL
V2rJSBoY1SCLRmt//vbgyBmw2JBVMDzv3p4KZiMTxam5BgswUHsiNwt3+2/U1rVp
lm/bWil/9sxPTpDtMLHqnOV3Gow7UM6LWadcTzG0D4ir9HuSTBbXT5NrWaBOBXmc
wdetNQDWrDsBUinG9awT
=S2XL
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
