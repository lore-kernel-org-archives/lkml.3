Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3BDUd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:33:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44353 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3BDUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:33:26 -0500
Date: Tue, 5 Feb 2013 07:33:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for Feb 4
Message-Id: <20130205073312.e534dda4b9b6b1bc95b3d25c@canb.auug.org.au>
In-Reply-To: <CAAG0J99hxOOGh74wQ2R47o0noRxQhNS8T_DNnbX2FX-rJ2wMzQ@mail.gmail.com>
References: <20130204183926.f5d5ab14b0ae4d22cb253202@canb.auug.org.au>
	<CAAG0J99hxOOGh74wQ2R47o0noRxQhNS8T_DNnbX2FX-rJ2wMzQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Feb_2013_07_33_12_+1100_pDybNxLzgssb3F.O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Feb_2013_07_33_12_+1100_pDybNxLzgssb3F.O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 4 Feb 2013 13:56:32 +0000 James Hogan <james.hogan@imgtec.com> wrot=
e:
>
> On 4 February 2013 07:39, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Merging signal/for-next (9005965 x86: convert to ksignal)
> > CONFLICT (content): Merge conflict in arch/x86/Kconfig
>=20
> I think this conflict has been resolved incorrectly.
>=20
> Al's commit 1820f96 "burying unused conditionals" removed
> GENERIC_SIGALTSTACK from config X86, but the merge
> (c5395e2affed5c42200cb6e21e3380995ef22ae3) left GENERIC_SIGALTSTACK
> in:

Thanks, I will fix that today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Feb_2013_07_33_12_+1100_pDybNxLzgssb3F.O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREBsIAAoJEECxmPOUX5FER1gQAJ/YGosBXKkOysluwCPolEFM
ItMq+W3sI4k8dPEdLVK2CnfhMuUGZyy2DHoA7y4lnAtLFHMKFECYBiBm4jGAEy2L
pU92R8iV8NG+URIaU2EY8Qv5BQvwTnkHMBdK29i87hRXEcPfo8jikpHWeLAD8UIi
qppZPM2U1vk63F13sfeJhYoSZar8/nXuV+RV/rUxqNwVVYAD3jS5BFuy6fVFy0T3
tFqHzSLfebtkhTQ03KpCijTlYsoiXleuQW9Phutnak+9JURTFmKFBB6e2Nhs4fb3
ThjTDSINqfXMJEj3896gSd3S62ZObr83/qC+kLliQrEtHOptJlPcZxp7Fsi4zMOy
g+rZeNn+qPjQO/NYWr9RCUmddmAtocasWposO/0ayIR6S6lKu8j8bBGZoZpzESeN
0TF9BmqfOhSVNSX6uxMSTF3VOUkxsjTysQSfLIJhdyjHcb0t/zKM/5JGj/Hqohzq
bJpNkXxHxwtmC5EfsE4Q7m404Ilm1fg+Tt99EDrSMtqZN4xlpvtq5HE6lvzS1ePq
wEqaz4TyKFRV5uLFrrSobZNNaifjL2tmPPMnbYuF5CM1aHrHI1VQ8TgegFPqE0Of
tUxqIyI12NaLNTq4XQEyqNeJ2XYW4BDPDPlpAi6iy7hsFriekXuz7VJ37AnOLsEf
GjVQfuxSqcKalr4+zepv
=UOKm
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Feb_2013_07_33_12_+1100_pDybNxLzgssb3F.O--
