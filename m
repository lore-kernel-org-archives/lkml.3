Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaFEER2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:17:28 -0400
Received: from ozlabs.org ([103.22.144.67]:57423 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaFEER1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:17:27 -0400
Date: Thu, 5 Jun 2014 14:17:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] DeviceTree updates for 3.16
Message-ID: <20140605141718.07073dd0@canb.auug.org.au>
In-Reply-To: <CAL_JsqKPJzzR-Thvnd7Fw5aTymxvQBp+bf8sdmGfL-xHM+iJ-Q@mail.gmail.com>
References: <CAL_JsqKPJzzR-Thvnd7Fw5aTymxvQBp+bf8sdmGfL-xHM+iJ-Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/j4dcPF=I0IPySftXX50tRDH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j4dcPF=I0IPySftXX50tRDH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Wed, 4 Jun 2014 11:48:50 -0500 Rob Herring <robherring2@gmail.com> wrote:
>
> The correct resolution is keeping the first "if (!of_kset)" and
> dropping the 2nd one as found is no longer present. I'm not sure why,
> but this error doesn't show up in linux-next.

That would be because I did that merge resolution ... I informed Grant
at the time (since it affected his tree).

See https://lkml.kernel.org/r/<20140526150557.219ea08f@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/j4dcPF=I0IPySftXX50tRDH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj+9VAAoJEMDTa8Ir7ZwVWeYP/Rl4Yp/VRb4KL5byucGbmScJ
L8JGk01TOG2QrgDtvKSGqqwRikAKTLGvVijlfJU6Sx00g3jpB7y+Va/IC65Iy7hy
qJU991jY+OANaWrxvKd/6vcItUMFe+Fxb2kl1B1c86+B3angdDpCYj0FHfJ3P04n
yMDtauwRh3fqmIbwcKub2kh/lhu/VerF6pjkiLS/JqAY3NLXcjpdg+8tm/kZVB3h
ZXHm0iNtc4BavnH4P5gmcNRnECAKxN0pd1EMYMAgQjC+9y3PUunle9br9dbWArnf
yzef4wj6XwaierdEMfxVpgkfmxN/2zd8TP8MxDPfI8U7Hft/Ly8KI85MpbVoyV70
bZLpsfLMEnD7HUpaMjP14z/G/DDb621tnjmITVFkKTe7vTATcsCokZ5OowUzVZsp
Hc5ivu15v6n6i6g8rKDYhXnnggnCjczMM/MrT9+oxRjNpcv0f3WQB70GakWdl+Zl
DLMzy6CSJw6mrVHDbaz4CFnOeGie9PffwwXD8oA2+R4L9DPl2abqZoromUWdu0u+
k4tZEYACf45t4KfWXPw/dm1iKiCJqU7O3aiUp/3gonJIPXKBxBkgganCzYQVvU/p
NWyafkXShlifkSxAzUWgByKGjbadPWDiUs36lWlKLNJ1S4VCHmnoEFK8naF2lD7V
AWlqwIZI/X3hvXZWKgAz
=Gq+/
-----END PGP SIGNATURE-----

--Sig_/j4dcPF=I0IPySftXX50tRDH--
