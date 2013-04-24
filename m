Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3DXRF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:05:57 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36209 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3DXRFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:05:54 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] usb: gadget: multi: Mark {cdc,rndis}_config_register() __init
In-Reply-To: <1366802195-15479-1-git-send-email-geert@linux-m68k.org>
Organization: http://mina86.com/
References: <1366802195-15479-1-git-send-email-geert@linux-m68k.org>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.2 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130424:balbi@ti.com::qIPdEU2xaAl3fcUW:0000044bj
X-Hashcash: 1:20:130424:gregkh@linuxfoundation.org::j+boelBxsHYANRX6:000000000000000000000000000000000002ZL7
X-Hashcash: 1:20:130424:geert@linux-m68k.org::VkvrQRmDnG6Ek3f0:000000000000000000000000000000000000000005+tl
X-Hashcash: 1:20:130424:geert@linux-m68k.org::aq1/8zr0dAABP2Xb:000000000000000000000000000000000000000005SVF
X-Hashcash: 1:20:130424:linux-kernel@vger.kernel.org::SsotoxqHLeihs8kq:0000000000000000000000000000000005rSM
X-Hashcash: 1:20:130424:linux-usb@vger.kernel.org::KR+/MNueGTZcpnRb:00000000000000000000000000000000000083rg
Date: Wed, 24 Apr 2013 10:05:46 -0700
Message-ID: <xa1t4nevc105.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24 2013, Geert Uytterhoeven wrote:
> If gcc (e.g. 4.1.2) decides not to inline cdc_config_register() and
> rndis_config_register(), this will cause section mismatch warnings:
>
> WARNING: drivers/usb/gadget/g_multi.o(.text+0x32f6): Section mismatch in =
reference from the function cdc_config_register() to the function .init.tex=
t:cdc_do_config()
> The function cdc_config_register() references
> the function __init cdc_do_config().
> This is often because cdc_config_register lacks a __init
> annotation or the annotation of cdc_do_config is wrong.
>
> WARNING: drivers/usb/gadget/g_multi.o(.text+0x3326): Section mismatch in =
reference from the function rndis_config_register() to the function .init.t=
ext:rndis_do_config()
> The function rndis_config_register() references
> the function __init rndis_do_config().
> This is often because rndis_config_register lacks a __init
> annotation or the annotation of rndis_do_config is wrong.
>
> Fortunately they're harmless, as {cdc,rndis}_config_register() are only
> called from multi_bind(), which is annotated with __ref.
>
> Mark {cdc,rndis}_config_register() with the __init annotation to kill the
> warning.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

With transition to configfs all those __inits and __refs will probably
go away in the long term though.

> ---
> Note: I did not verify that multi_bind() is rightfully marked __ref.

It should be.  It's only referenced in multi_driver object as a bind
callback which is called by composite_bind() which is referenced in
composite_driver_template as bind callback which is called by
usb_gadget_probe_driver() which is called by usb_composite_probe() which
is called by multi_init() which is __init and called as module_init.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJReBDqAAoJECBgQBJQdR/0JOcQAI8BTJKSSDbevg8lo6Y1IAT0
URlhXGozH8MVshZWWRITrCGoRln62b7kRMjEaM/BZoQDmIJcNEer8O771o0Y5VvM
nrxmVDtfPIqiB6DMZpLchP5YfgzYhPhvGnrUfZRp9jm+JIp5mdXzfs5Zb2XHVnUf
ZmJXE+zFwKfSX3cr6QNKkgjIIsNf8JR/gJ5Ni9ceOZopGfLPCAAioL6O/1prpHgW
zuAAxH2cRkc2my6DbXTbd4A73xaUvj1OH6imfn/pzPjbR6O0g9ThaULaNBN1XwbC
qUCsO5Ntnk2087pa37lcI1AI6uMnOgHfOV1fHG3dGNnPu8uzWUYsj6QEeGexZKB1
/1U4ICEdRHwCcTrhnH2G6UlSFTDw/wm8qG29P/1atJyIh5a/ijGlVURLUnGNKamS
INQtfNpKxcxA9I20QS99GqMmjxzVQpcQRE1QEeTTIwbPUsaa739pWaGpRL69ZdmL
pQXHKX9lGRhjdScfC1edbX7p568MYgrqI0k65eb3Kd4u9pIigNaVSPjfRpgF4ChV
l+JiIpXI7erIDXHyd1SAXZDjw+P1uVZBn+H4XR5+yd31rwKQuzlWbNYvrFicTG7K
rxK1bGrcKxfqA0zjEsBkeKaOLHrML2SLRsr4/XNbP+GLpfK234C95BCtOjpcvNt1
MEQFn9qlTUEtzuJL3+o9
=5WbW
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
