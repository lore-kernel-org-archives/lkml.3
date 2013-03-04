Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3CDO3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:29:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37440 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab3CDO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:29:34 -0500
Message-ID: <1362407359.3768.337.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] USB: storage: fix Huawei mode switching regression
From: Ben Hutchings <ben@decadent.org.uk>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        fangxiaozhi@huawei.com, zihan@huawei.com, Lin.Lei@huawei.com,
        Greg KH <gregkh@linuxfoundation.org>, neil.yi@huawei.com,
        wangyuhua@huawei.com, huqiao36@huawei.com, balbi@ti.com,
        mdharm-usb@one-eyed-alien.net, sebastian@breakpoint.cc,
        stable <stable@vger.kernel.org>
Date: Mon, 04 Mar 2013 14:29:19 +0000
In-Reply-To: <1362403161-23501-1-git-send-email-bjorn@mork.no>
References: <87obezs888.fsf@nemi.mork.no>
	 <1362403161-23501-1-git-send-email-bjorn@mork.no>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2f1p6SXJc79WBba+KTqy"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2f1p6SXJc79WBba+KTqy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 14:19 +0100, Bj=C3=B8rn Mork wrote:
[...]
> In-kernel mode switching was deprecated years ago with the
> development of the more user friendly userspace alternatives. The
> existing list of devices in usb-storage was only kept to prevent
> breaking already working systems.  The long term plan is to remove
> the list, not to add to it. Ref:
> http://permalink.gmane.org/gmane.linux.usb.general/28543
[...]

Can you add a comment to this effect?

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-2f1p6SXJc79WBba+KTqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTSvv+e/yOyVhhEJAQrAUA/+LmsYlMDXDzQty+QQ8gjoKOfc3n0w9sRz
gnMT/telsoHHmABZG9Slt56kGNaQvCeXkTmFJ9hGcgms1L9UjTXYlUpPeINo4CnO
kklqrWYUewNGziGDQ9+5+B4HdmkqiDc27rYxoefZC4rkAmLCow9GRJ9Go2R3R4qI
Rno0Mn3pxR1Dsjc5Phjc+g+TEIahMWHntYzEkfOE0Z+0yi/d8yk0HLA1VZ4YAHls
2erHuTQU2/+s4lj9yB2GHmGLcr82YYoy1TM032oTemO1YdOWqCodFCuaCWDi1PDS
jZxwHm5VdHi/sv2fOr+zqwqqvKqMUsNz8eCG5IMls2kg22AX5SvgbRXm+bgltWLr
Tl0IRp4XAPMEyhiT8Bi1sEpFPkH/but7tmbCUmBQFE0V3wmaRtLQICktVMjxjR5j
C8odST/FMEb1dRl5EhRg28K9iKz5YftpiRVrfKSVOmTWi9eH04b8154ObD7yGfGi
CItfSk9vUPQesTxlKRYAOHbTocI29j37A4UPGidwouLwBzQA96zjIC4uRF4XkdYW
LR3qVN5UmcmeUAP8O+iup5UJ4eamLJv5SHnVnF4FrwYWFoqzJNRh3ny6e2pIoEmD
o9xW6V1m29pkNzeLH9m0Mopg7n7YbZDzUUTBufFpZS9DxMsyOVvMb4jn4USXMbuO
pFw9v/gidAQ=
=eexo
-----END PGP SIGNATURE-----

--=-2f1p6SXJc79WBba+KTqy--
