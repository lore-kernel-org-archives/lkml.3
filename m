Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3JHAF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:05:29 -0400
Received: from ring0.de ([91.143.88.219]:51036 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3JHAF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:05:26 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
	*      [93.206.232.179 listed in zen.spamhaus.org]
Date: Tue, 8 Oct 2013 02:05:16 +0200
From: Sebastian Reichel <sre@debian.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Felipe <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3] ARM: OMAP3: Fix hardware detection for omap3630 when
 booted with device tree
Message-ID: <20131008000515.GA2097@earth.universe>
Mail-Followup-To: Nishanth Menon <nm@ti.com>,
	=?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>, Felipe <balbi@ti.com>,
	Olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20131007192009.GA8949@atomide.com>
 <1381178629-13488-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1381178629-13488-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 07, 2013 at 03:43:49PM -0500, Nishanth Menon wrote:
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 39c7838..4fe5b9c 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -113,6 +113,7 @@ MACHINE_END
>  #ifdef CONFIG_ARCH_OMAP3
>  static const char *omap3_boards_compat[] __initdata = {
>  	"ti,omap3",
> +	"ti,omap343x",
            ^^^^
You used omap36xx everywhere, so I guess this should be
"ti,omap34xx"?

-- Sebastian

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJSU0w7AAoJENju1/PIO/qaieEP/jhUIVrxTJNRrBhvWUaYnaDj
ZBQ48YhINc5kW0QhrbF91PHmdc/ndzFQ0jtHC+pNzFVrsCsTFu+07Ut4HY5tS41d
hjSaUOlS0W821di2E744ypPZJHniM5T5yb/fLioQpa90nKc1OsDIhKiALo2myZk1
AY+TFMmmmM+fg4RqjRpxbnM9e6isIenC4EqJU+tSc2CXJIjXAnkQ/wysF4fVgfS8
chbjhpiQvTkHWxuIt14Xb1E58+r4hqb9iI4BOL6yqSsPA4v1eZxpDDpb2+K8NrYQ
fwNMdn914rexIylHooSCzk9+9kGiWUqNR0EKs+MirnugK5yqeaoPTm3QGHljjkDB
bvjvjSCGVS8H7kgxOj3sySCMqAEzO/Tl4XiMD+3tZMeoNnasYABpUZkD9fbFi4B8
WM2Dn3MIfQ3wOGZAOMHXybya/GMRe/IlNvOV4eI31+h0BSSTjzqdUyrbp/dgZIuP
2vjMVr9Lf0OilAqvC+9f/8ggsgkw64KhpFiZps0vKXfYeahVdyUBmadNbtfAE0Wz
s0FtKa4fGSat/qpAGxih7FaGID+SPyV0QQAiRA8FA6lF11kjUxtCGldzn2jIfRCl
2F3LGPwmI4rJaLNumRnnYt2k5XXU6zBx/T7uPbqGjjQlGJ5pO63Gyj7a9Vg8nUoh
U0l04xz976EECfv3qZcD
=a1qz
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
