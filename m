Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab3JJQEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:04:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47260 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab3JJQEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:04:43 -0400
Date: Thu, 10 Oct 2013 11:04:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] USB: gadget: s3c-hsotg: add isochronous transfers
 support
Message-ID: <20131010160428.GV28375@radagast>
Reply-To: <balbi@ti.com>
References: <1381300917-7468-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qesg98+uAFykT7J8"
Content-Disposition: inline
In-Reply-To: <1381300917-7468-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Qesg98+uAFykT7J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 09, 2013 at 08:41:57AM +0200, Robert Baldyga wrote:
> @@ -2616,14 +2630,19 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>  	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
> =20
>  	/* default, set to non-periodic */
> +	hs_ep->isochronous =3D 0;
>  	hs_ep->periodic =3D 0;
>  	hs_ep->halted =3D 0;

this hunk doesn't apply because of this hs_ep->halted line, which patch
does this depend on ?

--=20
balbi

--Qesg98+uAFykT7J8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVtAMAAoJEIaOsuA1yqREuyMP/jHjgxfn/Xu+QfCpEvt65+Ee
HWDRObuVWAuLyN21LFsnMT13f8H7yxW3D7rLR7ATQ+lvW/svP1mH5Py0yCX6nkC7
cDZkgKD5/QZyPebUabPQMZMoUKFjGytc4YilAPNd9YiT/xyRUJhwzwZXhuTebohv
cbzeO2o7SjxA+VVXhcDXQHS9R1gW03mKhlrpwRMGZOoKq/LjQ5/uUzfy3qmp7Z00
BX9LXyV4+0G1Q50M94qF6Tbci2z85sb9gxI5REiRdnNEAw8d2jfnczTYrrH8rLtu
6teHpFOUVnu3A02bb0flcNV+DcjEPI0ZdDWiDtnJfzyFZT7mRzzshI/v4fXx4XvS
2hv7PM100S78Gn7wCT78p/jn9UpmgSa6jh/FFxcT0622sk3aak8E4XcJMkKPstbh
S79PQ29tCrESlGNMeDMYSq4DpU5FQ3B0tAIno//0E44mSs+QXlgRt5n5p6EFV4Rg
k8TFvzs0JeFi1JXhdzyiJ+/5rZiwzBJepXUXzqkKZBv3yTMMjM4sv9uaCeQ4ogvH
7/+BI0b4MrMTfvcT2ZtNgcvmLTtcHNPZikiIfDuKPA3j8rbG7IWrIpxgIQJiUALH
L8b/FfbETfIfJY3Gz26zpjyGxkJO8sWJ60P0deCF7XXgthhgC9m5HpdJiLNBE0Xa
Qu8XSxZBquGrkk+ZfoQp
=9Z//
-----END PGP SIGNATURE-----

--Qesg98+uAFykT7J8--
