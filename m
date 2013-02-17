Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3BQStP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 13:49:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43976 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab3BQStO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 13:49:14 -0500
Message-ID: <1361126922.5374.475.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [stable request] fix stack overflow in
 __reserve_region_with_split
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>, tmac@hp.com, linuxram@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Sun, 17 Feb 2013 18:48:42 +0000
In-Reply-To: <51191BBE.9080904@suse.cz>
References: <51191BBE.9080904@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3dGUaRgkHN7nkL9xJt2u"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3dGUaRgkHN7nkL9xJt2u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-11 at 17:26 +0100, Jiri Slaby wrote:
> Hi,
>=20
> I think this one should go to stable:
> commit 4965f5667f36a95b41cda6638875bc992bd7d18b
> Author: T Makphaibulchoke <tmac@hp.com>
> Date:   Thu Oct 4 17:16:55 2012 -0700
>=20
>     kernel/resource.c: fix stack overflow in __reserve_region_with_split(=
)
>=20
> To all up to 3.7 (exclusive).

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-3dGUaRgkHN7nkL9xJt2u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSEmCue/yOyVhhEJAQrkMhAAgmrpydYtUJjabLjzF6g1+tUH0DxgZl77
AjtO6y1DWKZHxiJNR3xYMbsTHF9/7SQiMXLx6vgdXQY/vbSTB25Ota/DO8TH7Ptg
cGSPv9frG+1BnjkoQRiz57ocgSiOjywsN9jjLnADbc34yW4KgSah7rV+v4Hi8b/0
K7cmAOeLROhC5gkLuDRdLdi10hAasHRpjbsbZ6eQnpqr28RY9wmCgVuVelBvvrmf
GdXySKOSDTq6BlHbo1g3Qcg/kq51YkXH5b0Yhuy7suJXNAXdmqVkQ7Sb/sDG+m3d
Egj8tBJz/josM1zKHzMVQslnmBrzqOAx+Wm6IRoKpnf0v69/Opy2O5kCtapg/Ria
BIE0zn5NJ5NfBHd8cTSe4sc2YYwEr7ssd9QBnC7Q053vMlL8idPbcsooGD59vvln
v1IUtK9hLRRyTwH0Z6e32Vpt47ZutqwPU5sd8cA1gQ5g0xzHSShVz4TZeSuk0n61
D2CfSYHWmsX1CRtmTRG1pXzb0eCH7AmcPAxKWwLS90K6L09k/dz6zqMizCRXLIz0
G35VaQb/aVVzAEK7BEhK6LXooYDmpKZ4VSR+BTJVG1YfBS1+hV8aSRHQfcZXy143
yeQM5kZNSs2jjZdjFc/z5nHU7LAWtT06EHHu1L+rBG6wPQBBVWk1xEayWouHwnjb
sTBOVyCeZhA=
=ve2g
-----END PGP SIGNATURE-----

--=-3dGUaRgkHN7nkL9xJt2u--
