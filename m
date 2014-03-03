Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaCCAFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:05:50 -0500
Received: from ozlabs.org ([203.10.76.45]:38092 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbaCCAFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:05:46 -0500
Date: Mon, 3 Mar 2014 11:08:09 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        jdl@jdl.com, devicetree-compiler@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Consistently use xrealloc instead of realloc
Message-ID: <20140303000809.GH12916@voom.fritz.box>
References: <1393792741-29043-1-git-send-email-xypron.glpk@gmx.de>
 <20140302234140.GD12916@voom.fritz.box>
 <5313C616.9010104@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7IgncvKP0CVPV/ZZ"
Content-Disposition: inline
In-Reply-To: <5313C616.9010104@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7IgncvKP0CVPV/ZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 01:00:22AM +0100, Heinrich Schuchardt wrote:
> >Note that in general dtc patches should be CCed to myself and Jon
> >Loeliger <jdl@jdl.com>, the dtc maintainers.
> >
>=20
> This is the relevant section in file MAINTAINERS of Torvald's git.
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAIN=
TAINERS
>=20
> OPEN FIRMWARE AND FLATTENED DEVICE TREE
> M:  Grant Likely <grant.likely@linaro.org>
> M:  Rob Herring <robh+dt@kernel.org>
> L:  devicetree@vger.kernel.org
> W:  http://fdt.secretlab.ca
> T:  git git://git.secretlab.ca/git/linux-2.6.git
> S:  Maintained
> F:  drivers/of/
> F:  include/linux/of*.h
> F:  scripts/dtc/
> K:  of_get_property
> K:  of_match_table
>=20
> If the information is not accurate, please, have it updated.

That's the maintainers information for the devicetree stuff included
in the Linux kernel tree, not for dtc as an upstream project.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--7IgncvKP0CVPV/ZZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTE8fpAAoJEGw4ysog2bOSDwEP/RicZWpvB3qAZcxGZ/gggUUR
N53NDdBXDJ5y8dpNh2enAVZk6W28Q4ZDgSsoYs8C0v4TISoJUmpAvrpAFtcMLRou
sLu5QnaLMucn8bbrPpWFZfqSk0kUzt21HHq0p5rwWYA+TFVoPeZGTqFSiV1dBpPU
MtNTYQ8UZwGiwLjyNoKL8J6DUrAj5S5j6MEg5esy7J3oJ7znAcuUZ6sw/QzPSVSl
9XShHzf7AgPUq6jACoAIajlG6ngQmLAK6vI3UZ/41Ocbc/txl41iac1Y5zM/e+Ym
RdEUTdsU1X5y7w6Ht3R3DJbQgdTVqLJbLSRGHj3//wy2BuTWN9LNbxOhK+vtplUe
+GzIfyDZBaPTFFDYjcSos+C5EZoAEH8dGg1siSdGBd75u3c2HmioR+T4j2HEKNzA
aVTKmuPpr6MRBVFh1ha3Dyuj6Yj9Owz3rzziQUVfyXr/SOE4UNEzQp8EjervjPuG
hOmNSr2F4tGK3g/uboL6ODiK0gEL1lvon7QVGgNH56RRY1lO8SXVxV5WvLKzbyK9
Z8Gn7pr6r6JAaOMH9Fbj8GC8qacLplZq/cB0rFbGWjkGCMcC0Gm3jX0HRtp+BupT
Zu5KSMvfd3CgqSVpv/NhmR0REh56AB12E+sSq1fVEvYy228o/oSQgzn5y07RnQNV
ZOeVn6/JIH9Shb5/BnD9
=8MZ6
-----END PGP SIGNATURE-----

--7IgncvKP0CVPV/ZZ--
