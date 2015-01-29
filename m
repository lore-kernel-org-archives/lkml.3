Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbbA2Jfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:35:50 -0500
Received: from ozlabs.org ([103.22.144.67]:53323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbbA2Jfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:35:43 -0500
Date: Thu, 29 Jan 2015 20:35:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Dave Airlie <airlied@linux.ie>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ben Goz <ben.goz@amd.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20150129203534.7fff65c3@canb.auug.org.au>
In-Reply-To: <54C9ED70.1020803@amd.com>
References: <20150129133857.2bdbb86d@canb.auug.org.au>
	<54C9ED70.1020803@amd.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jtFap7wBvK1zauDMs4nAFOG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jtFap7wBvK1zauDMs4nAFOG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Oded,

On Thu, 29 Jan 2015 10:21:04 +0200 Oded Gabbay <oded.gabbay@amd.com> wrote:
>
> So I think that Dave's drm-next now contains the correct code.
> Will you merge it again, or do you do it daily anyway ? I fear I'm entire=
ly=20
> clear with the details of the linux-next process.

I fetch all the trees again each morning and then merge them, so
tomorrow all will be well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/jtFap7wBvK1zauDMs4nAFOG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyf7sAAoJEMDTa8Ir7ZwVDZEP/2ZpRBos6gz0acDbR7VvL197
W71Uz9ZjQ6hWG7hqlvq178EikhFqOfuUFC92gOabfU89H+7/nMat5PrSIleZEq9a
Q3adDj6oFYmI7AiSKz6qfjD8BOYPLIyIQZ9BBATSmQyg+sXFfECOe82ZJybhs3Dj
swaJ9uo1AEA9MCvQnDE8WrlIvXD8x43tAiyM3Lf0f9ZZdwP2hcDtSCahGIwpYgBR
I4IwUhuKjBRxIa54sHEHpreKB5K0Z6UqBGByWLOpoBC5JWWnLaJ5AbyuLfuOLVoB
ezAQlLLfTMyJJWBXiIJQFKVeDjvmUdNGygy+uhpqZiDU59xj3af84hHGcrdEmv7U
Qb2GhQD1bneytLr/gpS3kxub+SS3wBiZaIjfm6BZs/lX6I3ksL3a4gwGtc/8MT5x
/5efLASi5jp9xuTBhFVJ5453585AhqyFsALqjNCWejKak7kFcuxmeSEYCctTq6hl
BynOM0dIAji74ZrQFpMjX9NAKnudBn2CBfeQNUcbDwOaaHFLTunbwk0q1N+PPM7U
VpxIuwEU8eco0GIOE7cx9lObj7ovamDPx/mx2JBI6VF6IjkkBjW6Ck/x1liJT2g7
sH6Mch9Ss0rElfDPNv+g1dxJJPAEPuZ3iBwhqetYCoyb9+136iyXEpkrDLc/XEdE
Ud85+cKYNgWGW/BUeSR0
=kLJk
-----END PGP SIGNATURE-----

--Sig_/jtFap7wBvK1zauDMs4nAFOG--
