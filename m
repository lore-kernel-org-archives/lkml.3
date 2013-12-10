Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3LJCeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:34:23 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56368 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3LJCeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:34:20 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v7 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
In-Reply-To: <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1386633338-10919-1-git-send-email-david.a.cohen@linux.intel.com> <1386633338-10919-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131210:stern@rowland.harvard.edu::fQ/gGgwzPC5v9sK+:0000000000000000000000000000000000000CuN
X-Hashcash: 1:20:131210:linux-usb@vger.kernel.org::MiwPjyWyrBMOzDLp:0000000000000000000000000000000000000k6+
X-Hashcash: 1:20:131210:david.a.cohen@linux.intel.com::noL7KC/Qop8A/t/8:000000000000000000000000000000001O9S
X-Hashcash: 1:20:131210:linux-kernel@vger.kernel.org::SBl5G+NzpUbiLGkQ:0000000000000000000000000000000001a/k
X-Hashcash: 1:20:131210:balbi@ti.com::+Mi4oIViJMfQz3Iv:000003F/y
X-Hashcash: 1:20:131210:gregkh@linuxfoundation.org::kpWxlrAk6mekebl5:000000000000000000000000000000000008yOS
X-Hashcash: 1:20:131210:david.a.cohen@linux.intel.com::yyF8wxnTLNtTS8vM:00000000000000000000000000000000KUsR
Date: Tue, 10 Dec 2013 03:34:11 +0100
Message-ID: <xa1t7gbdfn8c.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

dOn Tue, Dec 10 2013, David Cohen wrote:
> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
>
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize. A helper is also provided to align buffer size when
> necessary.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/usb/gadget.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 23b3bfd0a842..cae8a6216551 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -502,6 +502,8 @@ struct usb_gadget_ops {
>   *	only supports HNP on a different root port.
>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
>   *	enabled HNP support.
> + * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned =
to
> + *	MaxPacketSize.
>   *
>   * Gadgets have a mostly-portable "gadget driver" implementing device
>   * functions, handling all usb configurations and interfaces.  Gadget
> @@ -541,6 +543,7 @@ struct usb_gadget {
>  	unsigned			b_hnp_enable:1;
>  	unsigned			a_hnp_support:1;
>  	unsigned			a_alt_hnp_support:1;
> +	unsigned			quirk_ep_out_aligned_size:1;
>  };
>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
>=20=20
> @@ -559,6 +562,23 @@ static inline struct usb_gadget *dev_to_usb_gadget(s=
truct device *dev)
>=20=20
>=20=20
>  /**
> + * usb_ep_align_maybe - returns @len aligned to ep's maxpacketsize if ga=
dget
> + *	requires quirk_ep_out_aligned_size, otherwise reguens len.

=E2=80=9Creturns=E2=80=9D

> + * @g: controller to check for quirk
> + * @ep: the endpoint whose maxpacketsize is used to align @len
> + * @len: buffer size's length to align to @ep's maxpacketsize
> + *
> + * This helper is used in case it's required for any reason to check and=
 maybe
> + * align buffer's size to an ep's maxpacketsize.
> + */
> +static inline size_t
> +usb_ep_align_maybe(struct usb_gadget *g, struct usb_ep *ep, size_t len)
> +{
> +	return !g->quirk_ep_out_aligned_size ? len :
> +			round_up(len, (size_t)ep->desc->wMaxPacketSize);
> +}
> +
> +/**
>   * gadget_is_dualspeed - return true iff the hardware handles high speed
>   * @g: controller that might support both high and full speeds
>   */

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

iQIcBAEBAgAGBQJSpn2jAAoJECBgQBJQdR/0MzQP/iOOGskvaoIEA7H7F2ZM5ZIN
KS9mvOeTdnlZgEgTZhGRCJe+bT/7Qc53smHHlBofb2et7oeqMtoFUO1aK+DwAI2M
bz6Z7W4+gHCd/ePYpzCp2EW2BRqueufOKBHdGjRnpkmm/zX6wZYsfQRGfjiJHUMv
GG3o6Lw28mnGb+b892ueV/+QVVE1gOuHPUEuQUMX0tKvbtpiIScVm8sl0Sh/NBRC
yiKulJ35hTAdt02Ptp4NIoLsX42Jx/YrwGvKHSxgu9OiDHZA64NyAT8T7y7/qJlt
0Lk+j7RCJ/GEW6IJfpTtSqBSwZ0ce9Rua+vLHxE6I3nEo25bl1/W5huX9dFXuC8e
ms4X2oE8P50NHelHqUWnuJIwYmnbmhM6W+pleimXcDwN1SlnOk9UlAPyjDlobpcw
slJ5sJ8akcudf8rc7tfi5GkTH292Zp4SeGFTPJgUO6jpVzywUV1Gw1kbNdK7T3sb
HMkiQPPxq+pvJNQWUL3qEUjTwVlqzLYkj51NPghIGfyMI/9PYO4R/kTf6E/xkbuj
wpvC+NwpM1QICNAwOqtgLdiL+R0lIPeladlO+XTfBUeAL+0QLK5DM+XMImSO3IFh
cFRYDz9aVbRwEZFcMzu/QVvktprmfAAAEHgPc4skLECvHVaMkTVz8g16hZUCjYlM
1QYnKWcuhJpdygQrccJS
=hkp+
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
