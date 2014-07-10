Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaGJMJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:09:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57348 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaGJMJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:09:12 -0400
Date: Thu, 10 Jul 2014 14:01:20 +0200
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinikatakamlinux@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, Sourav Poddar <sourav.poddar@ti.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Message-ID: <20140710120120.GD30458@sirena.org.uk>
References: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
 <1404982207-4707-2-git-send-email-harinik@xilinx.com>
 <CAMuHMdXO-PkQ+07F=aZEjvH1Kh7uhWK8i3V9w+1aHvvtg7wDoQ@mail.gmail.com>
 <CAFcVECJ93Lw1MRVU-=zLRbB6To--zmAxz8OLObu=mhV84-FTNA@mail.gmail.com>
 <CAMuHMdU2HyCwXBJTAyswyj7XqhzhHQ24MamGLLVgMwU4xi0kxQ@mail.gmail.com>
 <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lv0dYwq55yjFwMRW"
Content-Disposition: inline
In-Reply-To: <CAFcVEC+-bM91WmfwweDdTvJ7KwH+dxKDLkzsT82snWKhukLeYQ@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/2] spi: Add support for Zynq QSPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lv0dYwq55yjFwMRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 10, 2014 at 04:03:19PM +0530, Harini Katakam wrote:

> OK. Correct me if I'm wrong but announcing this support in master->flags is
> just to say the controller supports it - Like Punnaiah mentioned in the other

No, it's broken to set this if there is no ability to use it.

> mail, nothing specific needs to be done from the controller driver to enable
> dual/quad support. This is at the SOC/IP level.

How does the client driver select the width to use for a transfer?

--Lv0dYwq55yjFwMRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvoCHAAoJELSic+t+oim9RAkQAJz8R+eH3JIKhwdnVPZy39rq
q9oQD1jIGzuw8raIxv2ip1S9dQA11AwHBVHKGsGhxW2vcBJ+WwLKxtLrS9mGVlTh
71ER2yw4uglokBeqrBePhqUW3IPkx71YKlcde9UuB20+dlC0KLltqhY3RN7iNRKx
s2CU7xRmPuQChTvJCd97/MalpWRr+L0f9A++X6PLiTMr+TAduyAnobbFlukqURcQ
2UOGytJVKsNjsuSmI32ai/JPTWRekv/iakVG+IFmlXjQsAry4Zg/9LbclP157yv+
Mtsrv+uNJ5IbXtJZpezH+ZkaIqVbgsOWBaGt1BEtjeHNWKSbSvQ77k1mI5azPQYo
igA1JHAzoxoDLU4tPClF6xl7JqH1ua1MtHyWyMCTk1cJTwpHST9HhL1M1hBFfYuW
e6uO9cz1xtBSTMgNXR9OLcaye83BGE9E/rJ/Ob2wJ4+ZoVnlfo12meD+/GLZch82
HEb1qbWf1TIbCghnZ05aRJEXnYlrq1yrhskQIm+Fw+10F7muofUO30/EH9GpMNnn
xobDOeuo/TZUuDfbyxU3nyYtiZZr3YtQz1/nfmjIkGTPl2nZPhOUzT2cPGr/ZQtU
it32QdkylIs5WOkcDgxulKzSAw788Oac9QRExjOcfLIAK1B91GVj7tkr6PYxyo98
fo78SIR/V4JxvUoy9VLY
=z2by
-----END PGP SIGNATURE-----

--Lv0dYwq55yjFwMRW--
