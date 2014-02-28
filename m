Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaB1KWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:22:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59946 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaB1KWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:22:44 -0500
Message-ID: <53106370.2010808@ti.com>
Date: Fri, 28 Feb 2014 12:22:40 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] video: da8xx-fb: fix typos
References: <1392964864-25371-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1392964864-25371-1-git-send-email-prabhakar.csengg@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8jrliLN6r5m2F7oEXcXBvb2jQInpgjSPr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8jrliLN6r5m2F7oEXcXBvb2jQInpgjSPr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/02/14 08:41, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>=20
> This patch fixes couple of typos in the comments
> for da8xx-fb.c file.
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

I think this kind of patch is a bit useless. The typos are only in
comments and the current sentences are easily understandable.

So this patch doesn't really help anything, only introduces
possibilities for conflicts.

So not applying.

 Tomi



--8jrliLN6r5m2F7oEXcXBvb2jQInpgjSPr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEGNwAAoJEPo9qoy8lh71bbMP/ik5SXRMf0Ni3n/vk38FnjgG
b2fsgSLwuH3DEFA/Sx2uk7fp2uqLmWT9JwTQjghFhRz0s+O93XDMpZGpQHdivRY4
89/s+5Wu7WGPIHyC4fk50qnEdhfFaRXcey78TZCa6FKGElQKCOn8tjUSqFthz4SW
/rnupFGjQZHHX2M4HAeCC+IMhrQpIzLQH7K4I37LqRoCfDxDTOTB112fDpCjHHl9
kwNF6BaHnjFkXKRZoN14fCBrXEV6KBW7ltosb/2fxwZMKfEOGWadTSh+rVTrfl+6
1JAthk2sLJNN+4QUIIE4OjEsBhhisolJCM6L9+og+6g7FvQoaPT36ZJLq7uFaiAR
jbwCNzJ4l7IEvBFmber7QJaszDkEBg+AFTOQcG2X0Ra+GewBOGKCuaAOIcmogWYN
ztuKzlI0Ojq3RFqJ1DGHSSk9TxKcRH8cQhm5mrfra8AuU8Fcd4LeNhsKkm+5nAQD
sgORsprX54KCd6zQ4lHjfkawvqMqrmxag3Tde9V1E21F/YHDgYipc+veehSIhar0
MwEp2osdS1gpdTmCSe+m6ZMzjUfM2C/PKVyL7xWlsfGljzWEgJ+/bwQj6eVgFeFX
fpjZcb0mcQASoJyanDrv5BJdNfsveeA5kh4n6MP0JQSSFBgYvGD6Chdfj1LYpk+i
s1DngmGyOq+XWWnShzCk
=fRpP
-----END PGP SIGNATURE-----

--8jrliLN6r5m2F7oEXcXBvb2jQInpgjSPr--
