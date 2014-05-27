Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaE0GWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:22:24 -0400
Received: from ozlabs.org ([103.22.144.67]:43197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbaE0GWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:22:21 -0400
Date: Tue, 27 May 2014 16:22:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH linux-next] DRM: Armada: update dma_buf_export use
Message-ID: <20140527162213.0ecfb9d4@canb.auug.org.au>
In-Reply-To: <CAPM=9twkXSA2uyVPfdz=qbpM5H96tHHaD8HnTf7YGpB0QX1WZw@mail.gmail.com>
References: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
	<CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
	<20140525225435.GZ3693@n2100.arm.linux.org.uk>
	<20140526090623.77186cdf@canb.auug.org.au>
	<CAPM=9twkXSA2uyVPfdz=qbpM5H96tHHaD8HnTf7YGpB0QX1WZw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NhtPiUw9B9foMQRrg=1_=a3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NhtPiUw9B9foMQRrg=1_=a3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 27 May 2014 15:52:46 +1000 Dave Airlie <airlied@gmail.com> wrote:
>
> Then we should cc him.

He was cc'd on my email that you replied to ...

But I guess the extra prod won't hurt :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/NhtPiUw9B9foMQRrg=1_=a3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThC8aAAoJEMDTa8Ir7ZwV2SQP/23E4woKA2BejAUqqWg4dT0x
N0DmxpyIgTFI/yYYUWlXbeb6e33NGrQiWG0KJGEaqAAsWwHpQgEgzolw+w/TpugO
6TMj0fX81ulVzWpo1exbMo7titEXsFadqGgX2rHyIkWGQk/p7c5685dZzHaheRf/
0SPwWFmpv9V6btd5LKXEw9lOUvBYeIpAlRFuvJQAwWdt/vd0Bc+SX1EzPtLKQ6F+
g0TjTWgdnYD3Se1TGpR8lSVgx1I/dIOZJlF5XfOPcKOVvFLBkfaaWX/W7xJO2viV
c26LNRoj8F7MkTpDsD5Nz7hf5aut4A4ZhiIDtU9G0VppbmS2hTBIq+SqWh1zteAB
bpqISa0Z0IL1bZFOHtbkUsBkXV6/WFaCNW6Uvl7MDwS8p26PoRvqnduXl1hlujKO
htoWPqF5TvxeeMikHXIaFZhA6gF5jAKCAPRxk6q8NLvS1Fz0zJMiGa/VXgQxalFu
n21CujjJ/Fa5qv4le6MlcwnHp13JfCeWsusMpX73G4E9F3FMLOoEbQEs+L5VDnYq
mgShyoIjBrFBWTR/nKwlke8D7tz9NO0LoihkkJakHgJrbfpeLzRTnBvi5us4ZYup
d7sRs9aHC5yWbeEY6bRSviw70rNAMbWo13h/Z6plic0TXf6HsFl5OtRycu0aXNfW
XcyhZavnCeRGhveKwj9k
=Nh4i
-----END PGP SIGNATURE-----

--Sig_/NhtPiUw9B9foMQRrg=1_=a3--
