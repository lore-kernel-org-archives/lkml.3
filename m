Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaIAPPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:15:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44925 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIAPPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:15:02 -0400
Date: Mon, 1 Sep 2014 16:13:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        jsarha@ti.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        alsa-devel@alsa-project.org, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org, Nicolin Chen <nicoleotsuka@gmail.com>
Message-ID: <20140901151356.GB29327@sirena.org.uk>
References: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
 <1409545781-20530-2-git-send-email-Li.Xiubo@freescale.com>
 <20140901133412.GA11312@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WnjMQ0y5QpAQNNgT"
Content-Disposition: inline
In-Reply-To: <20140901133412.GA11312@lunn.ch>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv1 1/7] ASoC: simple-card: Merge single and muti DAI link
 code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WnjMQ0y5QpAQNNgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 03:34:12PM +0200, Andrew Lunn wrote:
> On Mon, Sep 01, 2014 at 12:29:35PM +0800, Xiubo Li wrote:
> > This patch merge single DAI link and muti-DAI links code together,
> > and simply the simple-card driver code.

> It would be good to note that this breaks the Binary API with DT
> blobs. Old blobs will not work with this new C code.

That's not on, we need to maintian compatibility with the old DTs unless
there's a very strong reason not to.  Revising the binding is one option
for doing this, keeping the old binding in place and making a v2 binding
with the new functionality.

--WnjMQ0y5QpAQNNgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBI0xAAoJELSic+t+oim9z7IP/RoOAxgrSgXiS0mfFZwRC1Y0
WalauVxeKhP+mO36WOOxw9ZRx3u8BLIZQfKstRm+yypXmaOw9K6PF6Vde2KbhtL5
1ZtvVRHA1eLb07xKoPbZzlf3MmGxuKqjmS8j/vHLO2V0tb8iK0wGRAPrbl+/zSvw
DO10krrG/NlzGDw7ol6eM/WJFvDd7XdZbNStILVg+pVekoxMXwwYAZrJRI/HcHZf
9zu7dZcbNxRpadVh+/+0qhTHu9HhQ8Y6R1FJjRASTbs4sB0RPJ9iMF6iWDycXIsW
g7/OTg+lFiBxICEYQfxamfG0SDIPoDkWgnLOyU8Z6Xd1pWr0VCYCNICUOukYmIt6
SzDKj3QLvy0Q5VIi8l7kPw7j7BgWXxq0HQ2G22rl7Vs4JAf1txUcJkBBkgHjJyqy
BsWqcym7mU9Jt7ymLqsJvnsJxs2UkQ1yn8Y7kP7qvW3W8Rydqv6H527hSjSCkfZ6
ex21VZlKYGh/FraX7VLk0NTfqSK3E/qQ48K3eb43DGbOktnb48f8T17zqWRNlQeL
tkFIZILgzxSApuGlcbf5p8j6AXw8vebNFRT6xVKToKcwyemR58iVziHDnnXg3dHn
rjA3ExkOzAuSyuxM2K+s8oW2wZXHzMfXRvcTYsGjbB9N25bHln5jDpZV6voUMWs8
zeN1szFASOijgyUQimyh
=Zl56
-----END PGP SIGNATURE-----

--WnjMQ0y5QpAQNNgT--
