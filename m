Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3LNMjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:39:18 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45715 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3LNMjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:39:17 -0500
Date: Sat, 14 Dec 2013 13:39:13 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20131214123912.GF17467@mithrandir>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <52AA0FC4.3090606@vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
Content-Disposition: inline
In-Reply-To: <52AA0FC4.3090606@vmware.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 08:34:28PM +0100, Thomas Hellstrom wrote:
> On 12/12/2013 03:36 PM, Thierry Reding wrote:
> >This is a simple test module that can be used to allocate, export and
> >delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
> >systems that lack a real second driver.
> >
> >
>=20
> Looks nice. I wonder whether this could be extended to create a "streamin=
g"
> dma-buf from a user space mapping. That could be used as a generic way to
> implement streaming (user) buffer objects, rather than to add explicit
> support for those in, for example, TTM.

I'm somewhat reluctant to beef this up needlessly to prevent it from
being used for purposes other than testing.

Thierry

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrFFwAAoJEN0jrNd/PrOhLJ4P+gMyHIBKKHsorpmlBOJrWbYG
FqXH7BjPNh3wTI7zLC7MSdzN+ErBs5YfbyejTCQPDf0e+Adql7zVskx+0ond7H7A
OrXUDTdM5b7sdDX8W3VZMUknk3ZcZmCNSmGdf53afkejxttT5h2/HMvSziPCsoa2
2idcPB/fUa51pnYtOJD7faPPOFhGoia02wqQn4iEU3hOBr3Ay/jbnOzkaExNtBQv
dx8cLxt27fl8KYBwThBpMfwwX5HvpgXPYgVKgihSP5zKzwznSCvI4eX8i3G5+i4j
b2ZPEHUbquyaERzE80TERejHNZsm4u4G7XNB/xBaCndDc9vPJ3HuTT+wH7/xf2jL
/auXoeXwSZbKSf47m5YnR3JJ3+BbWN0wnlcwIXNreSmf4FNA+TyUjyRvuIaJeBAd
qvD4Twlnaeu/yq7BKABG/czAMM57ZoGERQsIzC1EcT6gWDaV41AL81a0YOMN6j3a
/+YY1G742Y5I2hfFTz75/p4JqvQMSIFNfAER/k0esXp4v3faJTV6pZ9Fj/UhwIOh
1naVROu6AbUIZf+mcKYOW3VWCeDcohmMF5d9awwjwo/XnVzg/1cpj2O/iLDrMNQ+
yBE1wZ5tdwYODV224dmPzma3kucZJo2hvoebMxE+0RdBnT0pRP3eH9bJj8HFVi08
6IZ9yi/jWblqKkTDYaVn
=fZEz
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
