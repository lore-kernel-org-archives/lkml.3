Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3BQGDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:03:39 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:54965 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3BQGDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:03:38 -0500
Date: Sun, 17 Feb 2013 01:03:27 -0500
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        zhenzhong.duan@oracle.com
Subject: Re: [PATCH 2/2] dmi_scan: Refactor dmi_scan_machine(),
 {smbios,dmi}_present()
Message-ID: <20130217060327.GB16842@roll>
References: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
 <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 06:02:22PM +0000, Ben Hutchings wrote:

> Tim, you might like to test that this doesn't cause a regression
> of the previous fix.
>=20
> Ben.

Ugh, I see what happened now. I only got one copy of this email which was
'helpfully' sorted into the linux kernel mailbox. gmail really doesn't help
with things like this, sorry Ben, I'll test this as soon as I can.

Tim Mcgrath

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUSByr5EncCrqzVruAQId+wgAk0oj0/JumeIvguz0/EfEFWI52pd93B2u
TmUTiFBaZmkZena5stBmJ/C0vBYjmu2TLgbouDK3f5pIAGzrEhm+zZWl7Pq9ktM8
qMthD8BxLRT2x7/MlsMpjwvBNnfD6ds8Xnnz9Zuz5JyEenJexYcA7v7uDZANTR9j
ul3k63HNUkzw1J9JzR2fRuKMetxBI6f3ST93Cr25ieKxtM2Ti+FrOpXdj1yDWGXi
LyS4m3+vgcyMfr+e8oyTemLGK8PanEZJREb31s8JdDfhho2rbhL94ovdvtIQkHT3
QNdt79ZFllmIzuahsojeJk511RqmjQLOEWVU4xCQWyX175s7DEuC1w==
=J9WI
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
