Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3HLIia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:38:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52638 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754237Ab3HLIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:38:28 -0400
Date: Mon, 12 Aug 2013 10:38:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCHv2 0/2] clk: sunxi: Add clock support for the A10s
Message-ID: <20130812083825.GO2911@lukather>
References: <1375735167-18031-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsxH/ny24k1NEYXc"
Content-Disposition: inline
In-Reply-To: <1375735167-18031-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsxH/ny24k1NEYXc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, Aug 05, 2013 at 10:39:24PM +0200, Maxime Ripard wrote:
> This small patchset adds support for the gates found in the Allwinner A10=
s SoC.
> Since the gates are the only clock that differ from the other supported
> Allwinner SoCs so far, the two patches are quite trivial.

It would be great if you could merge this in 3.12.
Do you have comments on this one?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JsxH/ny24k1NEYXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCJ8AAAoJEBx+YmzsjxAgersP+gOlq5Li1dXAV53l6KQporCr
MTj9AxiRU8tcIelizeebCQpz36dHHuyUV2wc7CM4b0V5a/M9BQO+Kus/rrq/ljLN
EQ4oPIJi5RTcvIqd+jjdyCt4ovtokinurstWtVUpkMARUoJLTAooVMa8e1dHixwn
+RnhELT/+Iz6GTZcL95tj5UCkZmEJyy1YdnpCoXgnnwm0nfgu/+5iaRl+c4OFyLj
3Wgd10W6Pem3zq7+Vhn0dRZ7LLJgJFToPre37izx8vfLko3c1s/kTsPQfsZof08e
XYwc+uUT+Z13gEv12MjpsvGqWnf4dcYw3081FeiDENzZXskLNTqsVfM72uxRmqh4
SK0O3fP0JtRs6GBlh3RsCT2F3hqsU62ZvhUxT8IOP0+SwQkXsGTEDMAoJPhZmiHi
k+iPUAyWF9gGVajlHwBWATkOJD+b6Tjc52+BRwHy/Cw/r0RjbmK3TQflgyyARNRL
hjiDGhVTuskBNBX7I7KcI7subEYDjZCJhhj/kWSLaGGgQOFZ9Kzgq1/gzcAv5Scx
mwtBunIHrek9Fqp8foqrj80oJa3awVsQeOLIkWN8+S2szh/shV0HuF437OGuHecj
pyX0ysLS45znG+7MbqJgYkVUF5+liQbLmgR6yxOl7t6L1zyIUp0etMBBQziWyjRh
r0dDO1ZIkefi9cI7Tf5n
=UhUg
-----END PGP SIGNATURE-----

--JsxH/ny24k1NEYXc--
