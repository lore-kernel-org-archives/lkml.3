Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKBVxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:53:52 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49983 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750990AbaKBVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:53:51 -0500
Message-ID: <5456A787.5060104@free-electrons.com>
Date: Sun, 02 Nov 2014 18:52:07 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, hch@infradead.org, axboe@fb.com,
        dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at>
In-Reply-To: <1414933255-3795-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JbNBtS9S9bNoD2S98o8jad5tsCg30eLSx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JbNBtS9S9bNoD2S98o8jad5tsCg30eLSx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On 11/02/2014 10:00 AM, Richard Weinberger wrote:
> Convert the driver to blk-mq.
>=20

Maybe you can explain a bit better what's this all about?

Both the commit that introduces blk-mq and the paper on it talk about
high IOPS devices, multi-core, NUMA systems. I'm not sure this is the
case for UBI-based devices.

Probably some numbers would help us decide. Does the patch increases the
dynamic memory footprint? Is there any performance benefit?

I kind of like the negative diffstat, but the code doesn't look cleaner
or simpler.

In other words, we need a good reason before we agree on making this
"zen style" driver more complex.
--=20
Ezequiel Garc=EDa, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com


--JbNBtS9S9bNoD2S98o8jad5tsCg30eLSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUVqeOAAoJEIOKbhOEIHKi1igQAJznHIkPRH1fsybcBBfJLZpf
DYmtCyD9ur4RwlCPaJG56hy8gj00/SDqiF+oGeda6RgWpPHTgqcaNABcd10h/goE
WcW893jRnKu7+pUQSuHAx+b1nx/4j2UYGhp7KeiamDFTvwGHVX6pi5nUdHuhIdcr
BKYlmdXZjkdvDYt+ZCVuIP1iLW4WIxmAZTLOLR7t/S7iP/mhmThF0oZTryMt9gDR
U22rAuzA4g/JlFmOLu4b9Ma2IWsII1WhOl+Qje3yDQMm206XCbNoWCkDxS/N47tY
qZcvjt3fiNezku7WlbUyN0XV4G/IcgDWY8waQM6drUChINQeyuxi4uxWewh90i1F
kPwW/qpxYe+5oZl1pbrqBUn8Y9qVs5RoDsOwe6rowifftBtCmgr71PYmD3PmZ1xW
82j13W/GT3RbKXWB8J0URt18yDaHBTjyqQLXn5tM89m7UPVricjbGcAWzCjac7ef
mZ1QYxEzL95QerJsPI1ZdQAGlAjSnk2EavYtAIsNza+R7D2RCHv5cF5QroRdFPc+
oRO5OSDusCWwCKQY8xz1JxALneLPrJInii3braG+SkRYtaUj7aCwVVsq67VSr4Ua
ydG463E7SWBjTVsK3svyUvF2aM4kZczQ4M1ljozeVHD6eu9MP+T/MlnnfDdizTk+
ppowmli3bUwcJOnQvtN2
=ipWR
-----END PGP SIGNATURE-----

--JbNBtS9S9bNoD2S98o8jad5tsCg30eLSx--
