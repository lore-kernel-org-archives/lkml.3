Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbaDBIap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:30:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40297 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758139AbaDBIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:30:38 -0400
X-Sasl-enc: sW8CDX5H8bmuaU6symFymOL1nt5cGa4DXoKiBQLWVHIK 1396427435
Message-ID: <1396427412.2726.21.camel@perseus.fritz.box>
Subject: [ANNOUNCE] autofs 5.1.0 beta1 release
From: Ian Kent <raven@themaw.net>
To: autofs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Apr 2014 16:30:12 +0800
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pISYbW3eMeTGKZf99V+U"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pISYbW3eMeTGKZf99V+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

This is an initial beta release which adds the ability of autofs
to understand the amd map format.

Making autofs understand the amd map format is a significant change
and, due to the way it's implemented, forms the basis for further
changes for autofs 5.1. However, most of these changes won't add
functionality, they are meant to improve the current implementation.

One functionality change that this will eventually lead to is the
alility to specify a custom umount program in a map entry, but an
awful lot needs to be done before that can be added.

autofs
=3D=3D=3D=3D=3D=3D

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.1.0-beta1.tar.[gz|xz]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.1.0-beta1.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.1.0-beta1.tar.gz

See the README.amd-maps file for information about using amd format
maps.

Ian

--=-pISYbW3eMeTGKZf99V+U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJTO8qUAAoJEOdnc4D1T9ipRYgP/3PMaUxHySCNX4g3YOV0oft5
uJaUvSAWWR8fE5rB589CX8IiucYzSyLXlR/n1VrpsIihbrgfDDU7r1+lHVRQdwM2
E5/SLE4ycm2MOfM32OlX1QamMZ51jVhM6pf6zQt9ZbWH0hM6zItx10H3nKnaBTtl
Zru5+GkL5PKLiUGAxjCu8p1CuOlmLe4ej4yFvN/JHZALIcH6qlvNxbzpn7URCdxp
6W1rmW10bmGXX783lbPVpv7o6945s+HPolvfqDwdEgYQlWjcPNyhyUwxsxeFtjPH
B21Mj3sGXAbmBGbfTN23i+lRHg6HGQAiNa3GpLTrHj3IAaU8XOszHtlXdAsCk9H+
OOhjG8VgcqAN9vQfwW8sEIxOOOI3ZEOaRSToUscOaYLd89IXWHPTzP7+8MJraxIS
nJC9FEfZCbAv0TH5R8mRMN3q1BxzX5kZM2ePUdu+bPqriaUQa4pLlCo0QwyTQt74
lEBpSngox1JSZSBe94BeQSGgCl/EOVQNP7XYi8ewcb67qRhlIpx5/lmAmGusnmLQ
9gTUXtxKW8b6g7EHBY7pRUmDt0Pslt3N8i4NJ3lSOaGOU1kXknfbVt59NPB8U6dw
09XpG5hvE4m96SynhThN8UX4r3L/oqXnsnutr9fDDsP1epbf3s7uRZCzcf+U7Ggk
0f8HR/7DLFVeqKGuhFCw
=hil/
-----END PGP SIGNATURE-----

--=-pISYbW3eMeTGKZf99V+U--

