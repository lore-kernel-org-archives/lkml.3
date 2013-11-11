Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3KKXxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:53:13 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50785 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3KKXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:53:07 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v5 1/5] usb: gadget: move bitflags to the end of usb_gadget struct
In-Reply-To: <1384201011-11114-2-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-2-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::XybWZ+CPsFn+cgWS:0000000000000000000000000000000000001k/I
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::pOWbGrZ9rvUAhni+:000000000000000000000000000000002nFW
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::j9BAPkPNb5SiJG/n:000000000000000000000000000000000004a1t
X-Hashcash: 1:20:131111:balbi@ti.com::UILRnx75D/et8r/C:000004L8z
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::KpQmebWhIMdN6JCA:0000000000000000000000000000000006GgR
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::j1KRstD/1X7EhPa1:00000000000000000000000000000000AH9c
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::05x3Sgv3tCLraLwU:000000000000000000000000000000000000JNAI
Date: Tue, 12 Nov 2013 00:52:57 +0100
Message-ID: <xa1t4n7ixzqe.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, David Cohen wrote:
> This patch moves all bitflags to the end of usb_gadget struct in order
> to improve readability.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/usb/gadget.h | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 942ef5e053bf..23b3bfd0a842 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -485,6 +485,11 @@ struct usb_gadget_ops {
>   * @max_speed: Maximal speed the UDC can handle.  UDC must support this
>   *      and all slower speeds.
>   * @state: the state we are now (attached, suspended, configured, etc)
> + * @name: Identifies the controller hardware type.  Used in diagnostics
> + *	and sometimes configuration.
> + * @dev: Driver model state for this abstract device.
> + * @out_epnum: last used out ep number
> + * @in_epnum: last used in ep number
>   * @sg_supported: true if we can handle scatter-gather
>   * @is_otg: True if the USB device port uses a Mini-AB jack, so that the
>   *	gadget driver must provide a USB OTG descriptor.
> @@ -497,11 +502,6 @@ struct usb_gadget_ops {
>   *	only supports HNP on a different root port.
>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
>   *	enabled HNP support.
> - * @name: Identifies the controller hardware type.  Used in diagnostics
> - *	and sometimes configuration.
> - * @dev: Driver model state for this abstract device.
> - * @out_epnum: last used out ep number
> - * @in_epnum: last used in ep number
>   *
>   * Gadgets have a mostly-portable "gadget driver" implementing device
>   * functions, handling all usb configurations and interfaces.  Gadget
> @@ -530,16 +530,17 @@ struct usb_gadget {
>  	enum usb_device_speed		speed;
>  	enum usb_device_speed		max_speed;
>  	enum usb_device_state		state;
> +	const char			*name;
> +	struct device			dev;
> +	unsigned			out_epnum;
> +	unsigned			in_epnum;
> +
>  	unsigned			sg_supported:1;
>  	unsigned			is_otg:1;
>  	unsigned			is_a_peripheral:1;
>  	unsigned			b_hnp_enable:1;
>  	unsigned			a_hnp_support:1;
>  	unsigned			a_alt_hnp_support:1;
> -	const char			*name;
> -	struct device			dev;
> -	unsigned			out_epnum;
> -	unsigned			in_epnum;
>  };
>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
>=20=20
> --=20
> 1.8.4.rc3
>

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

iQIcBAEBAgAGBQJSgW3ZAAoJECBgQBJQdR/0SXkP/jvlERYlcNljwn4pOxlXihh7
dvDad7Uf/FlfWM1HrfruLgWJ31wDa0EYM2p/Djvp5nSYUGQlcA0d3uEIP1qo+7jX
Dj8gRkzxFXPgRVB/iFXGdEh5XbNxV8nknabdoiMS9Y3QS3+fM/jG75QXTO7niL4Q
ZN1U/Id5EVvqlJl1maYaASQGxj8NrqG2BYrWPvdXEKMUb/VsvtKRBOKMfoT+ffLS
FToFP1rsuIxnMIqjHRU41vYyDz4RkBgHDTFf5wTkc/bhIV+5lOzAm8DLudGRUzER
T69HXnzPygCUWUT8HTXm8syHpqU+1ESLHEbdMHbfWh5YDVR5tQzv9uJF98ESbTfI
zGJmk4nwZVB5sTzLUslSJAOL6cNiLQSe0tdvt23gUSK+/C1sEC3PTnOFFfsgDa/I
/TVsNnhY8LZQWBCo9tsx2+BnAWzHzaNTEx4EmdNkQWagx3YmAqeDMbH1TH9okfUp
0Hy1vcV+5flcc/4WaeVnzH+DRVyOwZSRFkD4DQ7cMT9Sxz+zjvDALljcyeLjiaE8
0w3xJan9QC03b7CENvU0bihRaor9Vp6+1MV9F0LXwcV/ognG1nLtnUN/eG5nFkHm
TXUVvHeroqYAc9UqKH+1tBHlNBadTbBllw4Ss2En+JFw7lPvzVsPrTkBvPAgnzyt
fVfhU+Sc40VClOSV74fK
=vWqB
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
